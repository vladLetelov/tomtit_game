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
  int? _lastPlayedLevel; // Для запоминания последнего играемого уровня

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

  // Объединяем загрузку прогресса и подсчёт очков в один метод
  Future<void> _loadData() async {
    await GameScoreManager.init();
    _updateTotalScore();
  }

  void _updateTotalScore() {
    setState(() {
      _totalScore = GameScoreManager.getTotalScore();
    });
  }

  // Метод для прокрутки к определенному уровню
  void _scrollToLevel(int levelNumber) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Примерная высота одной карточки уровня + коннектор
        const double itemHeight = 1000.0; // Настройте под ваш дизайн
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
    // Прокручиваем к последнему играемому уровню после построения
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
                  'Очки: $_totalScore',
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

      final bool isHistoryUnlocked = levelNumber == 1 ||
          (GameScoreManager.getLevelScore(levelNumber - 1)) >=
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
          // Сохраняем выбранный уровень как последний играемый
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
      controller: _scrollController, // Добавляем контроллер прокрутки
      padding: const EdgeInsets.all(16.0),
      children: levelCards,
    );
  }
}
