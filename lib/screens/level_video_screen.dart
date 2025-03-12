import 'package:flutter/material.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/screens/level_questions_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:tomtit_game/models/level_model.dart';

class LevelVideoScreen extends StatefulWidget {
  const LevelVideoScreen({
    super.key,
    required this.level,
  });

  final LevelModel level;

  @override
  State<LevelVideoScreen> createState() => _LevelVideoScreenState();
}

class _LevelVideoScreenState extends State<LevelVideoScreen> {
  late VideoPlayerController _controller;
  bool _videoFinished = false;
  late int lastLevel;
  late LevelStep step;

  @override
  void initState() {
    super.initState();
    GameScoreManager.getLastLevel().then((val) {
      lastLevel = val;
    });
    GameScoreManager.getLastLevelStep().then((val) {
      step = val;
    });
    _controller = VideoPlayerController.asset('assets/videos/${widget.level.videoPath}')
      ..initialize().then((_) {
        // После того как видео инициализируется, начинаем воспроизведение
        setState(() {});
      });

    // Добавляем слушатель для отслеживания окончания видео
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          if (lastLevel == widget.level.levelNumber && step != LevelStep.questions) {
            step = LevelStep.questions;
            GameScoreManager.saveLastLevelStep(LevelStep.questions);
          }
          _videoFinished = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _playAgain() {
    setState(() {
      _videoFinished = false;
      _controller.seekTo(Duration.zero);
      _controller.play();
    });
  }

  void _goToQuestions() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LevelQuestionsScreen(level: widget.level)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Видео для уровня')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Center(
          child: _controller.value.isInitialized
              ? Stack(
            children: [
              // Видео, которое масштабируется с сохранением пропорций
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio, // Сохраняем пропорции видео
                  child: VideoPlayer(_controller),
                ),
              ),
              // Кнопка управления в правом нижнем углу
              Positioned(
                bottom: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause // Иконка паузы
                        : Icons.play_arrow, // Иконка воспроизведения
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: _playPause, // Обработка клика для паузы/воспроизведения
                ),
              ),
              // Кнопки после завершения видео
              if (_videoFinished)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _playAgain,
                        child: const Text('Посмотреть снова'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _goToQuestions,
                        child: const Text('Перейти к вопросам'),
                      ),
                    ],
                  ),
                ),
            ],
          )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
