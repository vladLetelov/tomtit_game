import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class MeteoritComponent extends SpriteComponent {
  MeteoritComponent() {
    size = Vector2(30, 30);  // Размер метеорита
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('meteorit.png');
    super.onLoad();
  }

  void spawnMeteor(double meteorSpeed, double screenHeight) {
    add(MoveEffect.by(
      Vector2(0, screenHeight),
      EffectController(duration: screenHeight / meteorSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
  }
}
