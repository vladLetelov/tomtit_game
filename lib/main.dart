import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';

void main() async {
  debugPaintSizeEnabled = false;
  await GameScoreManager.init();
  FlutterError.onError = (details) {
    debugPrint('Caught Flutter error: ${details.exception}');
  };
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelSelectionScreen(),
    ),
  );
}
