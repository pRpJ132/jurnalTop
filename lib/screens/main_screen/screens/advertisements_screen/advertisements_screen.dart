import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/latest_news.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/main_screen/screens/advertisements_screen/dialog/show_newsdialog.dart';
import 'package:my_app/services/logger.dart';

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
    _isLoading.value = true;
    loadLatestNew();
    _isLoading.value = false;

  }

  void loadLatestNew() async {
    final response = await ApiClient.get(
      "news/operations/latest-news"
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      _latestNews.value = body.map<LatestNews>((el) => LatestNews.fromJson(el)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (_, isLoadingValue, _) {
        if (isLoadingValue) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
                ValueListenableBuilder(
                  valueListenable: _latestNews,
                  builder: (_, latestNewsValue, _) {
                    return Center(
                      child: ValueListenableBuilder(
                        valueListenable: _isOpen,
                        builder: (_, isOpenValue, _) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 20,
                            children: latestNewsValue.map((el) => GestureDetector(
                              onTap: () async {
                                if (isOpenValue) return;
                                _isOpen.value = true;
                                await _openNewsDetail(el);
                                _isOpen.value = false;
                              },
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: el.viewed
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
                                      Text(el.theme),
                                      Spacer(),
                                      Text(
                                        DateFormat('dd MMMM yyyy', 'ru').format(el.time),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )).toList()
                          );
                        }
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _openNewsDetail(LatestNews el) async {
    try {
      final response = await ApiClient.get(
        "news/operations/detail-news?news_id=${el.idBbs}",
      );
      ApiClient.post("news/operations/set-view", {"news_id": el.idBbs});
      el.viewed = true;

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        showNewsDialog(
          context,
          body['theme'],
          body['text_bbs'],
          DateTime.parse(body['time']),
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }
}