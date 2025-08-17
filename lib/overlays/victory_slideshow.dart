import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
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

  @override
  void initState() {
    super.initState();
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

  void _returnToMenu() {
    Navigator.of(widget.game.buildContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LevelSelectionScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.game.levelModel.victorySlideshowImages!;

    return Stack(
      children: [
        // Фоновое изображение
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BackgroundHistoryPage.jpg'),
              fit: BoxFit.cover,
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
                ],
              ),
            ),
          ),
      ],
    );
  }
}
