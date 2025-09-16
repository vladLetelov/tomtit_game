import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/components/cards/level_step_card.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/screens/level_histories_screen.dart';
import 'package:tomtit_game/screens/help_screen.dart';

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
      _totalScore = _calculateTotalScore();
    });
  }

  int _calculateTotalScore() {
    int total = 0;

    for (var levelEntry in levels.entries) {
      if (GameScoreManager.isLevelCompleted(levelEntry.key)) {
        total += 1;
      }
    }

    for (var levelEntry in levels.entries) {
      total += GameScoreManager.getQuestionPointsForLevel(levelEntry.key);
    }

    return total;
  }

  int _getMaxQuestionPoints() {
    int maxPoints = 0;
    for (var levelEntry in levels.entries) {
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

  void _startTutorial(BuildContext context) {
    final tutorialLevel = levels[0]!;
    final navigator = Navigator.of(context);

    navigator.push(
      MaterialPageRoute(
        builder: (context) => LevelHistoriesScreen(level: tutorialLevel),
      ),
    );
  }

  Future<ListView> _buildLevelCards() async {
    List<Widget> levelCards = [];

    // ДОБАВЛЯЕМ КАРТОЧКУ ОБУЧЕНИЯ В НАЧАЛО СПИСКА
    levelCards.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () {
              _startTutorial(context);
            },
            child: Container(
              width: 300,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  levels[0]!.historyButtonPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // ДОБАВЛЯЕМ КОННЕКТОР МЕЖДУ ОБУЧЕНИЕМ И ПЕРВЫМ УРОВНЕМ
    levelCards.add(const Center(child: LevelCardConnector()));

    for (var levelEntry in levels.entries) {
      final levelNumber = levelEntry.value.levelNumber;

      // Пропускаем уровень 0 (обучение) в основном списке уровней
      if (levelNumber == 0) continue;

      final bool isHistoryUnlocked;
      if (levelNumber == 1) {
        isHistoryUnlocked = GameScoreManager.isLevelCompleted(0);
      } else {
        isHistoryUnlocked =
            (GameScoreManager.getTotalLevelScore(levelNumber - 1)) >=
                levels[levelNumber - 1]!.scoreForNextLevel;
      }

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

      if (levelNumber < levels.length - 1) {
        levelCards.add(const Center(child: LevelCardConnector()));
      }
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      children: levelCards,
    );
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
          // Кнопка справки в AppBar - на одной линии с другими элементами
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon:
                  const Icon(Icons.help_outline, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
              tooltip: 'Справка',
            ),
          ),
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
}
