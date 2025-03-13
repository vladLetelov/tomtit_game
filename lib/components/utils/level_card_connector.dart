import 'package:flutter/material.dart';

class LevelCardConnector extends StatelessWidget {
  const LevelCardConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.deepPurple,
      ),
      width: 6,
      height: 32,
    );
  }
}
