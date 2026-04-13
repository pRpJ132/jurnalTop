import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/reviews_student.dart';
import 'package:my_app/network/api_client.dart';

class ReviewsStudentScreen extends StatefulWidget {
  const ReviewsStudentScreen({super.key});

  @override
  State<ReviewsStudentScreen> createState() => _ReviewsStudentScreenState();
}

class _ReviewsStudentScreenState extends State<ReviewsStudentScreen> {
  final ValueNotifier<List<ReviewsStudent>> _reviewsStudent = ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    loadLatestNew();
  }

  @override
  void dispose() {
    _reviewsStudent.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  void loadLatestNew() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get(
        "reviews/index/list"
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _reviewsStudent.value = body.map<ReviewsStudent>((el) => ReviewsStudent.fromJson(el)).toList();
      }
    } finally {
      _isLoading.value = false;
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Отзывы о студенте".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFF188194), width: 3),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _reviewsStudent,
                    builder: (context, reviewsStudentValue, child) {
                      return Column(
                        spacing: 20,
                        children: reviewsStudentValue.reversed.map((el) => Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color.fromARGB(255, 215, 213, 213)
                              )
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            children: [
                              Row(
                                crossAxisAlignment: .start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${el.teacher} (${el.fullSpec})"
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd.MM.yyyy").format(el.date)
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    el.message
                                  ),
                                ),
                              )
                            ],
                          ),
                        )).toList(),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}