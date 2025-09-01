import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/levels.dart';
import 'dart:async';

class VictorySlideshow extends StatefulWidget {
  final TomtitGame game;

  const VictorySlideshow({super.key, required this.game});

  @override
  State<VictorySlideshow> createState() => _VictorySlideshowState();
}

class _VictorySlideshowState extends State<VictorySlideshow> {
  int _currentIndex = 0;
  Timer? _timer;
  bool _showCompletion = false;
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GameScoreManager.setLevelScore(
          widget.game.levelModel.levelNumber, widget.game.scoreNotifier.value);
    });
    _loadData();
    _startSlideshow();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSlideshow() {
    final images = widget.game.levelModel.victorySlideshowImages!;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < images.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _showCompletion = true;
        });
      }
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

  void _returnToMenu() {
    Navigator.of(widget.game.buildContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LevelSelectionScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.game.levelModel.victorySlideshowImages!;
    final bgImage = widget.game.levelModel.victorySlideshowBackground ??
        'assets/images/BackgroundHistoryPage.jpg';
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Stack(
      children: [
        // Фоновое изображение
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImage),
              fit: isMobile ? BoxFit.cover : BoxFit.contain,
            ),
          ),
        ),

        // Текущее изображение слайдшоу
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            key: ValueKey<int>(_currentIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(images[_currentIndex]),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Сообщение о завершении
        if (_showCompletion)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ИГРА ПРОЙДЕНА',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Отображение количества набранных очков
                  ValueListenableBuilder(
                    valueListenable: widget.game.scoreNotifier,
                    builder: (context, score, child) {
                      return Text(
                        'Заработано нициков: $_totalScore',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    child: const Text(
                      'Для их получения напишите нам hr@nicetu.spb.ru и прикрепите скриншот этого экрана.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _returnToMenu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'В главное меню',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
