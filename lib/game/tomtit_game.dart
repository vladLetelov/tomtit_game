import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:tomtit_game/components/background_component.dart';
import 'dart:async';
import 'dart:math';

import '../components/sinica_component.dart';
import '../components/meteorit_component.dart';
import '../components/semechko_component.dart';
import '../components/nicik_component.dart';
import 'package:flutter/material.dart';

class TomtitGame extends FlameGame with HasCollisionDetection {
  late SinicaComponent sinica;
  late SpriteComponent background;
  final double bulletSpeed = 300;
  final double meteorSpeed = 150;
  final double nicikSpeed = 200;
  double direction = 0;

  /*
  * Таймеры спавна
  * */
  late Timer _bulletTimer;
  late Timer _meteorTimer;
  late Timer _nicikTimer;

  final Random random = Random();
  ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    background = BackgroundComponent()
      ..size = size;
    add(background);

    // debugMode = true;

    sinica = SinicaComponent()
      ..position = Vector2((size.x / 2) - 25, size.y - 50);
    add(sinica);

    _bulletTimer = Timer(0.5, onTick: () => add(SemechkoComponent()), repeat: true);
    _meteorTimer = Timer(0.2, onTick: () => add(MeteoritComponent()), repeat: true);
    _nicikTimer = Timer(1.0, onTick: () => add(NicikComponent()), repeat: true);

    overlays.add('ScoreOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _bulletTimer.update(dt);
    _meteorTimer.update(dt);
    _nicikTimer.update(dt);
  }

  void endGame() {
    isGameOver = true;
    showGameOverDialog();
  }

  void showGameOverDialog() {
    overlays.add("GameOver");
  }

  void restartGame() {
    isGameOver = false;
    scoreNotifier.value = 0;
    removeWhere((component) => true);
    onLoad();
  }
}