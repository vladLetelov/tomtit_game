import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class Nicik extends SpriteComponent {
  Nicik() {
    size = Vector2(30, 30);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('nicik.png');
    super.onLoad();
  }

  void spawnNicik(double nicikSpeed, double screenHeight) {
    add(MoveEffect.by(
      Vector2(0, screenHeight),
      EffectController(duration: screenHeight / nicikSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
  }
}