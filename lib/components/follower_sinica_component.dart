import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/components/nicik_component.dart';
import 'package:tomtit_game/components/ColoredSinicaComponent.dart';
import 'package:tomtit_game/components/sinica_component.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class FollowerSinicaComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {
  final SinicaComponent leader;
  final Vector2 offset;
  final List<Vector2> _positionHistory = [];
  final int _historyLength = 15; // Уменьшено количество кадров для более быстрого следования
  final int _delay; // Задержка для каждого клона
  bool _shouldRemove = false;
  
  // Переменные для притягивания к черной дыре
  bool _isBeingPulledByBlackHole = false;
  Vector2? _blackHolePosition;
  final double _pullSpeed = 200.0;

  FollowerSinicaComponent(this.leader, this.offset, this._delay);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(game.levelModel.sinicaSize * 0.7); // Делаем клонов на 30% меньше
    anchor = Anchor.center;
    position = leader.position + offset;
    add(RectangleHitbox());
    
    // Устанавливаем приоритет чуть ниже основной синицы
    priority = 9;
    
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is MeteoritComponent) {
      other.removeFromParent();
      _shouldRemove = true;
      game.endGame();
      removeFromParent();
    }

    if (other is NicikComponent || other is ColoredSinicaComponent) {
      game.onCollectItem();
      other.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Логика притягивания к черной дыре
    if (_isBeingPulledByBlackHole && _blackHolePosition != null) {
      final direction = (_blackHolePosition! - position).normalized();
      final movement = direction * _pullSpeed * dt;
      position += movement;
      
      // Добавляем эффект уменьшения размера при приближении к черной дыре
      final distance = position.distanceTo(_blackHolePosition!);
      if (distance < 100) {
        final scaleRatio = distance / 100;
        scale = Vector2.all(scaleRatio.clamp(0.1, 1.0));
      }
      
      // Проверяем, достигла ли синица черной дыры
      if (distance < 30) {
        print('Follower sinica reached black hole, being absorbed');
        _onAbsorbedByBlackHole();
      }
    } else {
      // Обычная логика следования за лидером
      // Добавляем текущую позицию лидера в историю
      _positionHistory.add(leader.position.clone());
      
      // Ограничиваем размер истории
      if (_positionHistory.length > _historyLength) {
        _positionHistory.removeAt(0);
      }
      
      // Используем задержку для каждого клона
      final targetIndex = _delay.clamp(0, _positionHistory.length - 1);
      if (_positionHistory.length > targetIndex) {
        final targetPosition = _positionHistory[_positionHistory.length - 1 - targetIndex];
        position = targetPosition + offset;
      } else if (_positionHistory.isNotEmpty) {
        // Если истории недостаточно, используем последнюю доступную позицию с смещением
        position = _positionHistory.last + offset;
      }
    }
  }

  // Метод для начала притягивания к черной дыре
  void startBlackHoleAttraction(Vector2 blackHolePosition) {
    print('Follower Sinica: Starting black hole attraction');
    _isBeingPulledByBlackHole = true;
    _blackHolePosition = blackHolePosition;
    print('Follower Sinica: Black hole position set to $blackHolePosition');
  }

  // Метод вызывается когда синица поглощается черной дырой
  void _onAbsorbedByBlackHole() {
    _shouldRemove = true;
    removeFromParent();
  }
}