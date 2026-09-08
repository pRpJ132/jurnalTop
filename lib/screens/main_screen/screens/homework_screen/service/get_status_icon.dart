import 'package:flutter/material.dart';

IconData getStatusIcon(int status) {
  switch (status) {
    case 0:
      return Icons.cancel_outlined;
    case 1:
      return Icons.check_circle_outline;
    case 2:
      return Icons.hourglass_top_outlined;
    case 3:
      return Icons.assignment_outlined;
    default:
      return Icons.circle_outlined;
  }
}