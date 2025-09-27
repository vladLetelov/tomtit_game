// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/storage/user_data.dart';

void main() async {
  debugPaintSizeEnabled = false;
  await GameScoreManager.init();
  await UserDataManager.init(); // Добавляем инициализацию UserDataManager
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
