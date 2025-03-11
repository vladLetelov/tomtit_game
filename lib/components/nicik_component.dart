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
    anchor = Anchor.center;
    position = Vector2( (game.random.nextDouble() * (game.size.x - 30)), (-30) );
    add(RectangleHitbox());
    add(MoveEffect.by(
      Vector2(0, game.size.y + size.y * 2),
      EffectController(duration: game.size.y / game.nicikSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
    super.onLoad();
  }
}