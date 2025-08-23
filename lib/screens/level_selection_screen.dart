import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/components/cards/level_step_card.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _totalScore = 0;
  late ScrollController _scrollController;
  int? _lastPlayedLevel;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadData();
    _loadLastPlayedLevel();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLastPlayedLevel() async {
    final lastLevel = await GameScoreManager.getLastPlayedLevel();
    setState(() {
      _lastPlayedLevel = lastLevel;
    });
  }

  Future<void> _loadData() async {
    await GameScoreManager.init();
    _updateTotalScore();
  }

  void _updateTotalScore() {
    setState(() {
      // Используем новый метод для подсчета общего счета
      _totalScore = _calculateTotalScore();
    });
  }

  int _calculateTotalScore() {
    int total = 0;

    // Очки за пройденные уровни
    for (var levelEntry in levels.entries) {
      if (GameScoreManager.isLevelCompleted(levelEntry.key)) {
        total += 1; // По 1 очку за каждый пройденный уровень
      }
    }

    // Очки за полностью правильные ответы на вопросы
    for (var levelEntry in levels.entries) {
      total += GameScoreManager.getQuestionPointsForLevel(levelEntry.key);
    }

    return total;
  }

  int _getMaxQuestionPoints() {
    int maxPoints = 0;
    for (var levelEntry in levels.entries) {
      // Предполагаем, что в каждом уровне может быть несколько вопросов
      // Каждый полностью правильный ответ дает 1 очко
      if (levelEntry.value.history != null) {
        for (var historyItem in levelEntry.value.history!) {
          if (historyItem.questions != null) {
            maxPoints += historyItem.questions!.length;
          }
        }
      }
    }
    return maxPoints;
  }

  void _scrollToLevel(int levelNumber) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        const double itemHeight = 1000.0;
        final double targetPosition = (levelNumber - 1) * itemHeight;
        _scrollController.animateTo(
          targetPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastPlayedLevel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToLevel(_lastPlayedLevel!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        title: const Text('Выберите уровень', style: TextStyles.defaultStyle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'Ницики: $_totalScore/${levels.length + _getMaxQuestionPoints()}',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: FutureBuilder(
          future: _buildLevelCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return snapshot.data ?? const SizedBox();
          },
        ),
      ),
    );
  }

  Future<ListView> _buildLevelCards() async {
    List<Widget> levelCards = [];

    for (var levelEntry in levels.entries) {
      final levelNumber = levelEntry.value.levelNumber;

      // Используем общий счет для проверки разблокировки истории
      final bool isHistoryUnlocked = levelNumber == 1 ||
          (GameScoreManager.getTotalLevelScore(levelNumber - 1)) >=
              levels[levelNumber - 1]!.scoreForNextLevel;

      final bool isLevelUnlocked =
          GameScoreManager.isLevelHistoryCompleted(levelNumber) &&
              GameScoreManager.areLevelRequirementsMet(levelNumber);

      levelCards.add(LevelStepCard(
        level: levelEntry.value,
        isLocked: !isHistoryUnlocked,
        isLevelUnlocked: isLevelUnlocked,
        isHistoryUnlocked: isHistoryUnlocked,
        onLevelCompleted: () {
          _updateTotalScore();
        },
        onLevelSelected: (levelNumber) {
          GameScoreManager.setLastPlayedLevel(levelNumber);
          setState(() {
            _lastPlayedLevel = levelNumber;
          });
        },
      ));

      if (levelNumber < levels.length) {
        levelCards.add(const Center(child: LevelCardConnector()));
      }
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      children: levelCards,
    );
  }
}
