import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/main_menu.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';

void main() {
  runApp(
    GameWidget<TomtitGame>.controlled(
      gameFactory: TomtitGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'ScoreOverlay': (_, game) => ScoreOverlay(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
