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
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение на весь экран (без SafeArea)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover, // Всегда cover для заполнения всего экрана
              ),
            ),
          ),

          // Основной контент в SafeArea
          SafeArea(
            bottom: false, // Отключаем нижний SafeArea для фона
            child: LayoutBuilder(
              builder: (context, constraints) {
                final safePadding = mediaQuery.padding;
                final viewInsets = mediaQuery.viewInsets;

                // Доступная высота с учетом SafeArea сверху
                final availableHeight = constraints.maxHeight - safePadding.top;
                final availableWidth = constraints.maxWidth;

                final isVerySmallScreen = availableHeight < 400;

                return Stack(
                  children: [
                    // Текущее изображение слайдшоу
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          key: ValueKey<int>(_currentIndex),
                          width: availableWidth * 0.9,
                          height: availableHeight * 0.8,
                          margin: EdgeInsets.only(
                            top: availableHeight * 0.05,
                            bottom: viewInsets.bottom > 0
                                ? viewInsets.bottom + 10
                                : 0,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(images[_currentIndex]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Сообщение о завершении
                    if (_showCompletion)
                      Positioned(
                        bottom: viewInsets.bottom +
                            20, // Учитываем системные элементы
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: availableWidth * 0.95,
                            maxHeight: availableHeight * 0.7,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ИГРА ПРОЙДЕНА',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen ? 24 : 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 20),

                                // Отображение количества набранных очков
                                ValueListenableBuilder(
                                  valueListenable: widget.game.scoreNotifier,
                                  builder: (context, score, child) {
                                    return Text(
                                      'Заработано ${getNicikUnit(_totalScore)}: $_totalScore',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isVerySmallScreen ? 16 : 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'Для их получения напишите нам на hr@nicetu.spb.ru и прикрепите скриншот этого экрана.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen ? 14 : 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 20),

                                ElevatedButton(
                                  onPressed: _returnToMenu,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                  ),
                                  child: Text(
                                    'В главное меню',
                                    style: TextStyle(
                                        fontSize: isVerySmallScreen ? 16 : 18,
                                        color: Colors.white),
                                  ),
                                ),

                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String getNicikUnit(num count) {
  final intCount = count.toInt();

  if (intCount % 10 == 1 && intCount % 100 != 11) {
    return 'ницик';
  } else if (intCount % 10 >= 2 &&
      intCount % 10 <= 4 &&
      (intCount % 100 < 10 || intCount % 100 >= 20)) {
    return 'ницика';
  } else {
    return 'нициков';
  }
}
