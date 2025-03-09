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
    sprite = await Sprite.load('semechko.png');
    size = Vector2.all(10);
    anchor = Anchor.center;
    add(RectangleHitbox(isSolid: true));
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

  void moveBullet(double bulletSpeed, double screenHeight) {
    add(MoveEffect.by(
      Vector2(0, -screenHeight),
      EffectController(duration: screenHeight / bulletSpeed, curve: Curves.linear),
      onComplete: () => removeFromParent(),
    ));
  }
}
