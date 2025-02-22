import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class SemechkoComponent extends SpriteComponent {
  SemechkoComponent() {
    size = Vector2(10, 10);  // Размер пули
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('semechko.png');
    super.onLoad();
  }

  void moveBullet(double bulletSpeed, double screenHeight) {
    add(MoveEffect.by(
      Vector2(0, -screenHeight),
      EffectController(duration: screenHeight / bulletSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
  }
}
