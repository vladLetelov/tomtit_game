import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../game/tomtit_game.dart';

class NicikComponent extends SpriteComponent with HasGameReference<TomtitGame>, CollisionCallbacks{
  NicikComponent() {
    size = Vector2(30, 30);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('nicik.png');
    size = Vector2.all(30);
    add(RectangleHitbox());
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