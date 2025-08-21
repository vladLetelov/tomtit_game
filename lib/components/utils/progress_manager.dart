import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/storage/game_score.dart';

enum ContentType { history, gameLevel }

class ProgressManager {
  // Разблокировка следующего контента после завершения текущего
  static Future<void> unlockNextContent(
      int currentLevel, ContentType completedContentType) async {
    if (completedContentType == ContentType.history) {
      // После истории разблокируем игровой уровень
      await GameScoreManager.setLevelGameUnlocked(currentLevel);
    } else if (completedContentType == ContentType.gameLevel) {
      // После игрового уровня разблокируем историю следующего уровня
      if (currentLevel < levels.length) {
        await GameScoreManager.setLevelHistoryCompleted(currentLevel + 1);
        await GameScoreManager.setLevelRequirementsMet(currentLevel + 1);
      }
    }
  }

  // Получение типа следующего доступного контента
  static ContentType? getNextContentType(int currentLevel) {
    final bool isHistoryCompleted =
        GameScoreManager.isLevelHistoryCompleted(currentLevel);
    final bool isGameCompleted = GameScoreManager.getLevelScore(currentLevel) >=
        levels[currentLevel]!.scoreForNextLevel;

    if (!isHistoryCompleted) {
      return ContentType.history;
    } else if (!isGameCompleted) {
      return ContentType.gameLevel;
    } else if (currentLevel < levels.length) {
      return ContentType.history; // Следующая история
    }

    return null; // Все пройдено
  }

  // Проверка, доступен ли следующий контент
  static bool hasNextContent(int currentLevel) {
    return getNextContentType(currentLevel) != null;
  }

  // Получение номера следующего уровня для истории
  static int? getNextHistoryLevel(int currentLevel) {
    if (currentLevel < levels.length) {
      return currentLevel + 1;
    }
    return null;
  }
}
