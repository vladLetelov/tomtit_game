import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../game/tomtit_game.dart';

class NicikComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {

  @override
  Future<void> onLoad() async {
    sprite = game.nicikSprite;
    size = Vector2.all(30);
    anchor = Anchor.center;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    super.onLoad();
  }

  void reset() {
    children.removeWhere((component) => component is MoveEffect);
    position = Vector2((game.random.nextDouble() * (game.size.x - 30)), (-30));
    add(MoveEffect.by(
      Vector2(0, game.size.y + size.y * 2),
      EffectController(duration: game.size.y / game.levelModel.nicikSpeed, curve: Curves.linear),
      onComplete: () {
        removeFromParent();
        game.nicikPool.add(this);
      },
    ));
  }
}