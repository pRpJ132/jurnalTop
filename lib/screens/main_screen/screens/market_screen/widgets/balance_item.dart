import 'package:flutter/material.dart';

Widget balanceItem(String value, String asset) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Image.asset(asset, width: 18),
      ],
    ),
  );
}