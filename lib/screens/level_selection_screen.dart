import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/components/cards/level_step_card.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/enums/level_step.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int lastLevel = 1;
  LevelStep lastLevelStep = LevelStep.level;

  @override
  void initState() {
    super.initState();
    _loadLastProgress();
  }

  Future<void> _loadLastProgress() async {
    int savedLevel = await GameScoreManager.getLastLevel();
    LevelStep savedStep = await GameScoreManager.getLastLevelStep();
    setState(() {
      lastLevel = savedLevel;
      lastLevelStep = savedStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        title: const Text('Выберите уровень', style: TextStyles.defaultStyle),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final levelEntry = levels.entries.elementAt(index);
            final int levelNumber = levelEntry.value.levelNumber;
            final bool isLocked = levelNumber > lastLevel;

            // Определяем шаги, которые доступны
            bool isLevelUnlocked = levelNumber < lastLevel || (levelNumber == lastLevel && lastLevelStep.index >= LevelStep.level.index);
            bool isVideoUnlocked = levelNumber < lastLevel || (levelNumber == lastLevel && lastLevelStep.index >= LevelStep.video.index);
            bool isQuestionsUnlocked = levelNumber < lastLevel || (levelNumber == lastLevel && lastLevelStep.index >= LevelStep.questions.index);

            return LevelStepCard(
              level: levelEntry.value,
              isLocked: isLocked,
              isLevelUnlocked: isLevelUnlocked,
              isVideoUnlocked: isVideoUnlocked,
              isQuestionsUnlocked: isQuestionsUnlocked,
            );
          },
          separatorBuilder: (context, index) => const Center(
            child: LevelCardConnector(),
          ),
        ),
      ),
    );
  }
}
