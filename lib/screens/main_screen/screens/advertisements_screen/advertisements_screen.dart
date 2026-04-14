import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/latest_news.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/main_screen/screens/advertisements_screen/dialog/show_newsdialog.dart';
import 'package:my_app/services/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdvertisementsScreen extends StatefulWidget {
  const AdvertisementsScreen({super.key});

  @override
  State<AdvertisementsScreen> createState() => _AdvertisementsScreenState();
}

class _AdvertisementsScreenState extends State<AdvertisementsScreen> {
  final ValueNotifier<List<LatestNews>> _latestNews = ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    loadLatestNew();
  }

  @override
  void dispose() {
    _isOpen.dispose();
    _isLoading.dispose();
    _latestNews.dispose();
    super.dispose();
  }

  void loadLatestNew() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get(
        "news/operations/latest-news"
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _latestNews.value = body.map<LatestNews>((el) => LatestNews.fromJson(el)).toList();
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Объявления".toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 15),
            ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (_, isLoadingValue, _) {
                if(isLoadingValue) {
                  return Skeletonizer(
                    enabled: isLoadingValue,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 2,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) => Container(
                        width: MediaQuery.of(context).size.width < 600 ? double.infinity : 350,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border(
                            top: BorderSide(color: Color(0xFF188194), width: 5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('------------------------------'),
                              Spacer(),
                              Text(
                                DateFormat('dd MMMM yyyy', 'ru').format(DateTime.now()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return ValueListenableBuilder(
                  valueListenable: _latestNews,
                  builder: (_, latestNewsValue, _) {
                    return Center(
                      child: ValueListenableBuilder(
                        valueListenable: _isOpen,
                        builder: (_, isOpenValue, _) {
                          return GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 2,
                            ),
                            itemCount: latestNewsValue.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () async {
                                if (isOpenValue) return;
                                _isOpen.value = true;
                                await _openNewsDetail(latestNewsValue[index]);
                                _isOpen.value = false;
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width < 600 ? double.infinity : 350,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: latestNewsValue[index].viewed
                                      ? const Color.fromARGB(117, 243, 243, 243)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border(
                                    top: BorderSide(color: Color(0xFF188194), width: 5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(latestNewsValue[index].theme),
                                      Spacer(),
                                      Text(
                                        DateFormat('dd MMMM yyyy', 'ru').format(latestNewsValue[index].time),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    );
                  }
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNewsDetail(LatestNews el) async {
    try {
      ApiClient.post("news/operations/set-view", {"news_id": el.idBbs});
      el.viewed = true;

      showNewsDialog(
        context,
        el.idBbs,
      );
    } catch (e) {
      logger.e(e);
    }
  }
}