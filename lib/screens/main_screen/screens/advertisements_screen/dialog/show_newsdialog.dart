import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

void showNewsDialog(
  BuildContext context,
  String theme,
  String text,
  DateTime time,
) {
  showDialog(
    context: context,
    builder: (_) {
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
                  theme,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 10),
                Text(
                  DateFormat('dd MMMM yyyy', 'ru').format(time),
                ),
                SizedBox(height: 15),
            
                Html(data: text),
              ],
            ),
          ),
        ),
      );
    },
  );
}