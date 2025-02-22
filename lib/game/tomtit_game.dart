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
import '../components/nicik.dart'; // Импортируем Nicik
import 'package:flutter/material.dart'; // Для отображения диалогового окна

class TomtitGame extends FlameGame {
  late SinicaComponent sinica;
  late SpriteComponent background;
  final double bulletSpeed = 300;
  final double meteorSpeed = 150;
  final double nicikSpeed = 200; // Скорость ницика
  double direction = 0;
  late Timer _bulletTimer;
  late Timer _meteorTimer;
  late Timer _nicikTimer; // Таймер для спавна нициков
  final Random _random = Random();
  ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('background.jpg')
      ..size = size;
    add(background);

    sinica = SinicaComponent()
      ..sprite = await loadSprite('sinica.png')
      ..size = Vector2(50, 50)
      ..position = Vector2((size.x / 2) - 25, size.y - 50);
    add(sinica);

    _bulletTimer = Timer(0.5, onTick: fireBullet, repeat: true);
    _meteorTimer = Timer(0.2, onTick: spawnMeteor, repeat: true);
    _nicikTimer = Timer(1.0, onTick: spawnNicik, repeat: true); // Спавн нициков каждую секунду

    overlays.add('ScoreOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return; // Если игра закончена, не обновляем объекты

    _bulletTimer.update(dt);
    _meteorTimer.update(dt);
    _nicikTimer.update(dt); // Обновляем таймер нициков

    // Удаляем объекты, вышедшие за границы экрана
    children.whereType<MeteoritComponent>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y) {
        component.removeFromParent();
      }
    });

    children.whereType<SemechkoComponent>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y) {
        component.removeFromParent();
      }
    });

    children.whereType<Nicik>().toList().forEach((component) {
      if (component.y < -component.height || component.y > size.y) {
        component.removeFromParent();
      }
    });

    checkCollisions();
    checkBulletMeteorCollisions();
  }

  void checkCollisions() {
    for (var meteor in children.whereType<MeteoritComponent>()) {
      if (meteor.toRect().overlaps(sinica.toRect())) {
        endGame();
        return;
      }
    }

    // Столкновение с нициком
    for (var nicik in children.whereType<Nicik>()) {
      if (nicik.toRect().overlaps(sinica.toRect())) {
        scoreNotifier.value += 1;
        nicik.removeFromParent();
      }
    }
  }

  void checkBulletMeteorCollisions() {
    for (var bullet in children.whereType<SemechkoComponent>()) {
      for (var meteor in children.whereType<MeteoritComponent>()) {
        if (bullet.toRect().overlaps(meteor.toRect())) {
          // Удаляем семечку и метеорит при столкновении
          bullet.removeFromParent();
          meteor.removeFromParent();
          break; // Прерываем внутренний цикл, чтобы не проверять другие метеориты
        }
      }
    }
  }

  void endGame() {
    isGameOver = true;
    showGameOverDialog();
  }

  void showGameOverDialog() {
    overlays.add("GameOver");
  }

  // Перезапуск игры
  void restartGame() {
    isGameOver = false;
    scoreNotifier.value = 0;
    children.clear();
    onLoad();
  }

  void fireBullet() async {
    var bullet = SemechkoComponent()
      ..sprite = await loadSprite('semechko.png')
      ..size = Vector2(10, 10)
      ..position = Vector2(sinica.x + sinica.width / 2 - 5, sinica.y - 10);

    add(bullet);

    bullet.add(MoveEffect.by(
      Vector2(0, -size.y),
      EffectController(duration: size.y / bulletSpeed, curve: Curves.linear),
      onComplete: () => bullet.removeFromParent(),
    ));
  }

  void spawnMeteor() async {
    var meteor = MeteoritComponent()
      ..sprite = await loadSprite('meteorit.png')
      ..size = Vector2(30, 30)
      ..position = Vector2(_random.nextDouble() * (size.x - 30), -30);

    add(meteor);

    meteor.add(MoveEffect.by(
      Vector2(0, size.y),
      EffectController(duration: size.y / meteorSpeed, curve: Curves.linear),
      onComplete: () => meteor.removeFromParent(),
    ));
  }

  void spawnNicik() async {
    var nicik = Nicik()
      ..sprite = await loadSprite('nicik.png') // Загрузите спрайт для ницика
      ..size = Vector2(30, 30)
      ..position = Vector2(_random.nextDouble() * (size.x - 30), -30);

    add(nicik);

    nicik.add(MoveEffect.by(
      Vector2(0, size.y),
      EffectController(duration: size.y / nicikSpeed, curve: Curves.linear),
      onComplete: () => nicik.removeFromParent(),
    ));
  }
}