import 'package:flutter/material.dart';

class HistoryCardConnector extends StatelessWidget {
  const HistoryCardConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.deepPurple.withOpacity(0.5),
      ),
      width: 4,
      height: 24,
    );
  }
}
