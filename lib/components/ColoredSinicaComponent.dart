import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game/tomtit_game.dart';

class ColoredSinicaComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {
  ColoredSinicaComponent() {
    size = Vector2(30, 30);
  }

  @override
  Future<void> onLoad() async {
    final colors = ['Red', 'Blue'];
    final randomColor = colors[game.random.nextInt(colors.length)];
    sprite = await Sprite.load('sinica$randomColor.png');

    anchor = Anchor.center;
    position = Vector2(
      (game.random.nextDouble() * (game.size.x - 40)),
      (-40),
    );
    add(RectangleHitbox());
    add(MoveEffect.by(
      Vector2(0, game.size.y + size.y * 2),
      EffectController(
        duration: game.size.y / (game.levelModel.coloredSinicaSpeed ?? 200),
        curve: Curves.linear,
      ),
      onComplete: () => removeFromParent(),
    ));
  }
}
