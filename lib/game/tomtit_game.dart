import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
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

  final Random _random = Random();
  ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('background.jpg')
      ..size = size;
    add(background);

    debugMode = true;

    sinica = SinicaComponent()
      ..position = Vector2((size.x / 2) - 25, size.y - 50);
    add(sinica);

    _bulletTimer = Timer(0.5, onTick: fireBullet, repeat: true);
    _meteorTimer = Timer(0.2, onTick: spawnMeteor, repeat: true);
    _nicikTimer = Timer(1.0, onTick: spawnNicik, repeat: true);

    overlays.add('ScoreOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _bulletTimer.update(dt);
    _meteorTimer.update(dt);
    _nicikTimer.update(dt);

    children.whereType<MeteoritComponent>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y) {
        component.removeFromParent();
      }
    });

    children.whereType<SemechkoComponent>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y + component.height) {
        component.removeFromParent();
      }
    });

    children.whereType<NicikComponent>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y + component.height) {
        component.removeFromParent();
      }
    });
  }

  void endGame() {
    isGameOver = true;
    showGameOverDialog();
  }

  void showGameOverDialog() {
    overlays.add("GameOver");
  }

  void restartGame() {
    print("aAAAAsdASDASD");
    isGameOver = false;
    scoreNotifier.value = 0;
    children.clear();
    onLoad();
  }

  void fireBullet() async {
    var bullet = SemechkoComponent()
      ..sprite = await loadSprite('semechko.png')
      ..size = Vector2(10, 10)
      ..position = Vector2(sinica.x - 5, sinica.y - 10);

    add(bullet);

    bullet.add(MoveEffect.by(
      Vector2(0, -size.y),
      EffectController(duration: size.y / bulletSpeed, curve: Curves.linear),
      onComplete: () => bullet.removeFromParent(),
    ));
  }

  void spawnMeteor() async {
    var meteor = MeteoritComponent()
      ..position = Vector2(_random.nextDouble() * (size.x - 30), -30);

    add(meteor);

    meteor.add(MoveEffect.by(
      Vector2(0, size.y),
      EffectController(duration: size.y / meteorSpeed, curve: Curves.linear),
      onComplete: () => meteor.removeFromParent(),
    ));
  }

  void spawnNicik() async {
    var nicik = NicikComponent()
      ..position = Vector2(_random.nextDouble() * (size.x - 30), -30);

    add(nicik);

    nicik.add(MoveEffect.by(
      Vector2(0, size.y),
      EffectController(duration: size.y / nicikSpeed, curve: Curves.linear),
      onComplete: () => nicik.removeFromParent(),
    ));
  }
}