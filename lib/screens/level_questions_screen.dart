import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/models/question_model.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class LevelQuestionsScreen extends StatefulWidget {
  const LevelQuestionsScreen({
    super.key,
    required this.level,
    required this.currentQuestionsSet
  });

  final LevelModel level;
  final int currentQuestionsSet;

  @override
  State<LevelQuestionsScreen> createState() => _LevelQuestionsScreenState();
}

class _LevelQuestionsScreenState extends State<LevelQuestionsScreen> {
  int _currentQuestionIndex = 0;
  List<Color> _buttonColors = [Colors.deepPurple, Colors.deepPurple, Colors.deepPurple, Colors.deepPurple]; // Для 4 кнопок
  late int lastLevel;
  late LevelStep step;

  @override
  void initState() {
    GameScoreManager.getLastLevel().then((val) {
      lastLevel = val;
    });
    GameScoreManager.getLastLevelStep().then((val) {
      step = val;
    });
    super.initState();
  }

  void _handleAnswer(int selectedIndex) {
    final QuestionModel currentQuestion = widget.level.questions[widget.currentQuestionsSet][_currentQuestionIndex];

    setState(() {
      // Если ответ правильный, кнопка становится зеленой
      if (selectedIndex == currentQuestion.rightAnswer) {
        _buttonColors[selectedIndex] = Colors.green;
        // Переход к следующему вопросу через 1 секунду
        Future.delayed(const Duration(seconds: 1), () {
          if (_currentQuestionIndex < widget.level.questions[widget.currentQuestionsSet].length - 1) {
            setState(() {
              _currentQuestionIndex++;
              // Сбрасываем цвета кнопок для следующего вопроса
              _buttonColors = [Colors.deepPurple, Colors.deepPurple, Colors.deepPurple, Colors.deepPurple];
            });
          } else {
            if (lastLevel == widget.level.levelNumber && lastLevel != 7) { // HERE 7 IS COUNT OF LEVELS
              GameScoreManager.saveLastLevelStep(LevelStep.level);
              GameScoreManager.saveLastLevel(lastLevel + 1);
            }
            _showTestCompletionDialog();
          }
        });
      } else {
        // Если ответ неправильный, кнопка становится красной
        _buttonColors[selectedIndex] = Colors.red;
      }
    });
  }

  // Функция для отображения диалога завершения теста
  void _showTestCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              constraints: const BoxConstraints(
                maxHeight: 500, // Ограничение высоты
              ),
              decoration: BoxDecoration(
                color: deepDarkPurple.withOpacity(0.9),
                border: Border.all(
                  width: 2,
                  color: Colors.deepPurple,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Тест завершен!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Вы успешно завершили тест!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LevelSelectionScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(150, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        child: const Text(
                          'В меню',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameWidget<TomtitGame>.controlled(
                                gameFactory: () => TomtitGame(levelModel: levels[lastLevel + 1]!),
                                overlayBuilderMap: {
                                  'GameOver': (_, game) => GameOver(game: game),
                                  'ScoreOverlay': (_, game) => ScoreOverlay(game: game),
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(150, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        child: const Text(
                          'Следующий уровень',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.level.questions[widget.currentQuestionsSet][_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        title: const Text('Вопросы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined, color: Colors.white),
            tooltip: 'Выйти в меню',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LevelSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: backgroundGradient
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentQuestion.question,
                style: TextStyles.defaultStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // 4 кнопки для вариантов ответов
              Column(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_buttonColors[index] == Colors.deepPurple) {
                          // Только если кнопка еще не была нажата
                          _handleAnswer(index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60), // Увеличиваем высоту кнопок
                        backgroundColor: _buttonColors[index], // Цвет каждой кнопки
                      ),
                      child: Text(
                        currentQuestion.variants[index],
                        style: TextStyles.defaultStyle,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
