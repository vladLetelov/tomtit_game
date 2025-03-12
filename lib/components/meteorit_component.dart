import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class MeteoritComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = game.meteoritSprite;
    size = Vector2.all(30);
    anchor = Anchor.center;
    position = Vector2( (game.random.nextDouble() * (game.size.x - 30)) , (-30));
    add(RectangleHitbox());
    add(MoveEffect.by(
      Vector2(0, game.size.y + size.y * 2),
      EffectController(duration: game.size.y / game.levelModel.meteorSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
    super.onLoad();
  }
}
