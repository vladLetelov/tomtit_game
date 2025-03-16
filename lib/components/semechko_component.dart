import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class SemechkoComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = game.semechkoSprite;
    size = Vector2.all(10);
    anchor = Anchor.center;
    position = Vector2(
        game.sinica.x - 5, game.sinica.y - 10
    );
    add(RectangleHitbox()..collisionType = CollisionType.active);
    add(MoveEffect.by(
      Vector2(0, -game.size.y),
      EffectController(duration: game.size.y / game.levelModel.bulletSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
    super.onLoad();
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MeteoritComponent) {
      other.removeFromParent();
      removeFromParent();
    }
  }
}
