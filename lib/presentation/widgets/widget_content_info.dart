import 'package:flutter/material.dart';

Widget contentInfo({
  required Icon icon,
  required Text text,

}) {
  TextStyle textStyle = const TextStyle(fontWeight: FontWeight.normal);

  return Container(
    color: Colors.grey.withOpacity(0.2),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        const SizedBox(height: 1),
        Row(
          children: [
            Container(
              child: icon,
            ),
            const SizedBox(width: 8),
            Container(
              child: text,
            ),
          ],
        ),
      ],
    ),
  );
}
