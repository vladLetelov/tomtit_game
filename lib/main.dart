import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelSelectionScreen(),
    ),
  );
}
