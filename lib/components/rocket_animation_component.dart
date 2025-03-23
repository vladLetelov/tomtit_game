import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class RocketAnimationComponent extends SpriteComponent with HasGameReference<TomtitGame> {
  RocketAnimationComponent();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica_on_rocket.webp');

    anchor = Anchor.center;
    size = Vector2(50, 50);
    position = Vector2(-size.x, game.size.y * 0.7);

    // Пролет к центру экрана (слегка выше) + увеличение масштаба
    final moveToCenter = MoveToEffect(
      Vector2(game.size.x * 0.4, game.size.y * 0.5), // Почти центр, но немного выше
      EffectController(duration: 1.4, curve: Curves.easeOut),
    );

    final scaleUp = ScaleEffect.to(
      Vector2(4, 4),
      EffectController(duration: 1.6, curve: Curves.easeOut),
    );

    // Удаление вправо за пределы экрана + уменьшение масштаба
    final moveToRight = MoveToEffect(
      Vector2(game.size.x + size.x, game.size.y * 0.7), // За пределы экрана справа
      EffectController(duration: 1.2, curve: Curves.easeIn),
    );

    final scaleDown = ScaleEffect.to(
      Vector2(2, 2), // Возвращаемся к исходному размеру
      EffectController(duration: 1.2, curve: Curves.easeIn),
    );

    // Разворот за пределами экрана и возвращение вниз по центру
    final moveToBottomCenter = MoveToEffect(
      Vector2(game.size.x * 0.5, game.size.y - 80), // Центр нижней части экрана
      EffectController(duration: 1.5, curve: Curves.easeInOut),
    );

    // Исчезновение ракеты перед стартом
    final fadeOut = OpacityEffect.to(
      0, // Прозрачность 0
      EffectController(duration: 0.8, curve: Curves.easeInOut),
    );

    add(moveToCenter);
    add(scaleUp..onComplete = () {
      add(moveToRight);
      add(scaleDown..onComplete = () {
        add(moveToBottomCenter..onComplete = () {
          add(fadeOut..onComplete = () {
            removeFromParent();
            game.gameStarted = true;
          });
        });
      });
    });
  }
}