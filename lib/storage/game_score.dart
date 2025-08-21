import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomtit_game/levels.dart';

/// Centralized manager for game progress and scores using SharedPreferences.
class GameScoreManager {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs!.containsKey('level_1_history_completed')) {
      await _setDefaults();
    }
  }

  static Future<void> _setDefaults() async {
    await _prefs!.setBool('level_1_history_completed', false);
    await _prefs!.setInt('lastLevel', 1);
    await _prefs!.setInt('lastUnlockedLevel', 1);
  }

  static Future<void> saveLastLevel(int level) async =>
      await _prefs!.setInt("lastLevel", level);

  static int getLastLevel() => _prefs!.getInt("lastLevel") ?? 1;

  static Future<void> setLevelUnlocked(int level) async =>
      await _prefs!.setInt('lastUnlockedLevel', level);

  static int getLastUnlockedLevel() => _prefs!.getInt('lastUnlockedLevel') ?? 1;

  static bool isLevelHistoryCompleted(int levelNumber) =>
      _prefs!.getBool('level_${levelNumber}_history_completed') ?? false;

  static Future<void> setLevelHistoryCompleted(int levelNumber) async =>
      await _prefs!.setBool('level_${levelNumber}_history_completed', true);

  static bool isLevelCompleted(int levelNumber) =>
      _prefs!.getBool('level_${levelNumber}_completed') ?? false;

  static Future<void> setLevelCompleted(int levelNumber) async =>
      await _prefs!.setBool('level_${levelNumber}_completed', true);

  // Level availability methods
  static bool isLevelHistoryAvailable(int levelNumber) =>
      _prefs!.getBool('level_${levelNumber}_history_available') ?? false;

  static Future<void> setLevelHistoryAvailable(int levelNumber) async =>
      await _prefs!.setBool('level_${levelNumber}_history_available', true);

  static bool isLevelGameUnlocked(int levelNumber) =>
      _prefs!.getBool('level_${levelNumber}_game_unlocked') ?? false;

  static Future<void> setLevelGameUnlocked(int levelNumber) async =>
      await _prefs!.setBool('level_${levelNumber}_game_unlocked', true);

  static bool areLevelRequirementsMet(int levelNumber) =>
      _prefs!.getBool('level_${levelNumber}_requirements_met') ?? false;

  static Future<void> setLevelRequirementsMet(int levelNumber) async =>
      await _prefs!.setBool('level_${levelNumber}_requirements_met', true);

  static int getLevelScore(int levelNumber) =>
      _prefs!.getInt('level_${levelNumber}_score') ?? 0;

  static Future<void> setLevelScore(int levelNumber, int score) async =>
      await _prefs!.setInt('level_${levelNumber}_score', score);

  static Future<void> saveQuestionResultCard(
    int levelNumber,
    int questionIndex,
    bool isCorrect,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionIndex}_result_shown',
      true,
    );
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionIndex}_result_correct',
      isCorrect,
    );
  }

  static bool? wasQuestionResultShown(int levelNumber, int questionIndex) {
    return _prefs!.getBool(
      'level_${levelNumber}_question_${questionIndex}_result_shown',
    );
  }

  static bool? getQuestionResultCorrectness(
      int levelNumber, int questionIndex) {
    return _prefs!.getBool(
      'level_${levelNumber}_question_${questionIndex}_result_correct',
    );
  }

  static Future<void> saveQuestionAnswer(
    int levelNumber,
    int questionIndex,
    int answerIndex,
    bool isSelected,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionIndex}_answer_$answerIndex',
      isSelected,
    );
  }

  static List<bool> getQuestionAnswers(
    int levelNumber,
    int questionIndex,
    int answerCount,
  ) {
    return List.generate(answerCount, (i) {
      return _prefs!.getBool(
            'level_${levelNumber}_question_${questionIndex}_answer_$i',
          ) ??
          false;
    });
  }

  static bool? getQuestionResult(int levelNumber, int questionIndex,
      {int? answerIndex}) {
    if (answerIndex != null) {
      return _prefs!.getBool(
          'level_${levelNumber}_question_${questionIndex}_answer_$answerIndex');
    }
    return _prefs!.getBool('level_${levelNumber}_question_$questionIndex');
  }

  static Future<Map<int, bool>> getLevelQuestionResults(int levelNumber) async {
    final results = <int, bool>{};
    for (var key in _prefs!.getKeys()) {
      if (key.startsWith('level_${levelNumber}_question_') &&
          key.endsWith('_result_correct')) {
        final questionIndex = int.tryParse(key.split('_')[3]);
        if (questionIndex != null) {
          results[questionIndex] = _prefs!.getBool(key) ?? false;
        }
      }
    }
    return results;
  }

  static Future<void> saveResultCardShown(
      int levelNumber, int questionIndex) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionIndex}_result_shown',
      true,
    );
  }

  static bool wasResultCardShown(int levelNumber, int questionIndex) {
    return _prefs!.getBool(
          'level_${levelNumber}_question_${questionIndex}_result_shown',
        ) ??
        false;
  }

  static Future<void> saveQuestionResult(
    int levelNumber,
    int questionIndex,
    bool isCorrect,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_$questionIndex',
      isCorrect,
    );
  }

  // Новые методы для работы с уникальными ID вопросов

  static Future<void> saveQuestionAnswerById(
    int levelNumber,
    String questionId,
    int answerIndex,
    bool isSelected,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionId}_answer_$answerIndex',
      isSelected,
    );
  }

  static bool? getQuestionResultById(int levelNumber, String questionId,
      {int? answerIndex}) {
    if (answerIndex != null) {
      return _prefs!.getBool(
          'level_${levelNumber}_question_${questionId}_answer_$answerIndex');
    }
    return _prefs!.getBool('level_${levelNumber}_question_$questionId');
  }

  static Future<void> saveQuestionResultById(
    int levelNumber,
    String questionId,
    bool isCorrect,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_$questionId',
      isCorrect,
    );
  }

  static Future<void> saveResultCardShownById(
      int levelNumber, String questionId) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionId}_result_shown',
      true,
    );
  }

  static bool? wasQuestionResultShownById(int levelNumber, String questionId) {
    return _prefs!.getBool(
      'level_${levelNumber}_question_${questionId}_result_shown',
    );
  }

  static bool? getQuestionResultCorrectnessById(
      int levelNumber, String questionId) {
    return _prefs!.getBool(
      'level_${levelNumber}_question_${questionId}_result_correct',
    );
  }

  static Future<void> saveQuestionResultCardById(
    int levelNumber,
    String questionId,
    bool isCorrect,
  ) async {
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionId}_result_shown',
      true,
    );
    await _prefs!.setBool(
      'level_${levelNumber}_question_${questionId}_result_correct',
      isCorrect,
    );
  }

  /// Возвращает общую сумму очков, набранных на всех уровнях.
  static int getTotalScore() {
    // Предполагаем, что уровни нумеруются с 1 до N без пропусков.
    int totalScore = 0;
    for (var levelEntry in levels.entries) {
      totalScore +=
          getLevelScore(levelEntry.key); // Суммируем очки за каждый уровень
    }
    return totalScore;
  }

  /// Награждает игрока очками за правильный ответ на вопрос
  static Future<void> awardPointsForCorrectAnswer(
      int levelNumber, String questionId, int points) async {
    // Проверяем, были ли уже начислены очки за этот вопрос
    if (wasQuestionAwarded(levelNumber, questionId)) {
      return; // Не начисляем повторно
    }

    // Получаем текущие очки за вопросы
    final int currentQuestionScore = getQuestionPointsForLevel(levelNumber);

    // Сохраняем новые очки за вопросы
    await _prefs!.setInt(
        'level_${levelNumber}_question_points', currentQuestionScore + points);

    // Сохраняем факт награждения за этот конкретный вопрос
    await _prefs!
        .setBool('level_${levelNumber}_question_${questionId}_awarded', true);
  }

  /// Проверяет, были ли уже начислены очки за этот вопрос
  static bool wasQuestionAwarded(int levelNumber, String questionId) {
    return _prefs!
            .getBool('level_${levelNumber}_question_${questionId}_awarded') ??
        false;
  }

  /// Получает количество очков за правильные ответы на вопросы в уровне
  static int getQuestionPointsForLevel(int levelNumber) {
    return _prefs!.getInt('level_${levelNumber}_question_points') ?? 0;
  }

  /// Получает общее количество правильных ответов на вопросы в уровне
  static int getCorrectAnswersCount(int levelNumber) {
    int correctCount = 0;

    for (var key in _prefs!.getKeys()) {
      if (key.startsWith('level_${levelNumber}_question_') &&
          !key.contains('_answer_') &&
          !key.contains('_awarded') &&
          !key.contains('_result_') &&
          !key.contains('_shown')) {
        final isCorrect = _prefs!.getBool(key);
        if (isCorrect == true) {
          correctCount++;
        }
      }
    }

    return correctCount;
  }

  /// Награждает игрока очками за частично правильный ответ
  static Future<void> awardPointsForPartialAnswer(
      int levelNumber, String questionId, int points) async {
    // Проверяем, были ли уже начислены очки за этот вопрос
    if (wasQuestionAwarded(levelNumber, questionId)) {
      return; // Не начисляем повторно
    }

    // Получаем текущие очки за уровень
    int currentScore = getLevelScore(levelNumber);
    // Добавляем награду
    int newScore = currentScore + points;
    // Сохраняем новые очки
    await setLevelScore(levelNumber, newScore);

    // Сохраняем факт награждения за этот конкретный вопрос
    await _prefs!
        .setBool('level_${levelNumber}_question_${questionId}_awarded', true);

    // Сохраняем количество начисленных очков
    await _prefs!.setInt(
        'level_${levelNumber}_question_${questionId}_awarded_points', points);
  }

  static const String _lastPlayedLevelKey = 'last_played_level';

  static Future<void> setLastPlayedLevel(int levelNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPlayedLevelKey, levelNumber);
  }

  static Future<int?> getLastPlayedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPlayedLevelKey);
  }

  /// Получает общий счет уровня (игра + вопросы)
  static int getTotalLevelScore(int levelNumber) {
    final int gameScore = getLevelScore(levelNumber);
    final int questionScore = getQuestionPointsForLevel(levelNumber);
    return gameScore + questionScore;
  }
}
