import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:my_app/network/api_client.dart';
import 'package:toastification/toastification.dart';

Future<void> showNewsDialog(
  BuildContext context,
  int idBbs,
) async {
  late BuildContext dialogContext;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      dialogContext = ctx;
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    final response = await ApiClient.get(
      "news/operations/detail-news?news_id=$idBbs",
    );

    Map<String, dynamic>? body;

    if (response.statusCode == 200) {
      body = jsonDecode(response.body);
    }

    if (body == null) {
      throw Exception("Ошибка данных");
    }

    Navigator.pop(dialogContext);

    showDialog(
      context: context,
      builder: (ctx) {
        dialogContext = ctx;
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body?['theme'] ?? '-',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('dd MMMM yyyy', 'ru')
                        .format(DateTime.parse(body?['time'])),
                  ),
                  const SizedBox(height: 15),
                  Html(data: body?['text_bbs'] ?? '-'),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    Navigator.pop(dialogContext);
    toastification.show(
      context: context,
      title: const Text("Ошибка загрузки объявления"),
      autoCloseDuration: const Duration(seconds: 4),
      style: ToastificationStyle.fillColored,
      type: ToastificationType.error,
    );
  }
}