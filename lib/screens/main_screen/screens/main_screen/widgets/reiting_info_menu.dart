
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReitingInfoMenu extends StatefulWidget {
  const ReitingInfoMenu({super.key});

  @override
  State<ReitingInfoMenu> createState() => _ReitingInfoMenuState();
}

class _ReitingInfoMenuState extends State<ReitingInfoMenu> {
  static final _positionGroup = ValueNotifier<int>(-1);
  static final _positionStream = ValueNotifier<int>(-1);
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _loadReitingInfo();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (_, isLoadingValue, _) {
            return Skeletonizer(
              enabled: (isLoadingValue && 
                (_positionGroup.value == -1 || _positionStream.value == -1)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Рейтинг", 
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _positionGroup,
                          builder: (_, value, _) => Text(
                            "$value место в группе", 
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 20)
                          ),
                        ),
                      ),
                      Flexible(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _positionStream,
                          builder: (_, value, _) => Text(
                            "$value место в потоке", 
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 20)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  void _loadReitingInfo() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get("dashboard/progress/leader-group-points");
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        _positionGroup.value = data["studentPosition"].toInt();
      }

      final response2 = await ApiClient.get("dashboard/progress/leader-stream-points");
      if (response2.statusCode == 200) {
        final data = await jsonDecode(response2.body);
        _positionStream.value = data["studentPosition"].toInt();
      }
    } finally {
      _isLoading.value = false;
    }
  }
}