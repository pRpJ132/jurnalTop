import 'package:flutter/material.dart';

Color getStatusColor(int status) {
  switch (status) {
    case 0:
      return const Color.fromARGB(255, 211, 47, 47);
    case 1:
      return const Color.fromARGB(255, 46, 125, 50);
    case 2:
      return const Color.fromARGB(255, 218, 197, 14);
    case 3:
      return const Color.fromARGB(255, 21, 101, 192);
    default:
      return Colors.grey;
  }
}