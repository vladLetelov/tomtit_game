import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class MeteoritComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('meteorit.png');
    size = Vector2.all(30);
    anchor = Anchor.center;
    add(RectangleHitbox(isSolid: true));
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
