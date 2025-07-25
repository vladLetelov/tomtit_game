import 'package:tomtit_game/models/question_model.dart';
import 'package:tomtit_game/models/history_model.dart';

class LevelModel {
  final int levelNumber;
  final String background;
  final double bulletSpeed;
  final double meteorSpeed;
  final double nicikSpeed;
  final double bulletFrequency;
  final double meteorFrequency;
  final double nicikFrequency;
  final double angryBirdBuffChance;
  final double bulletFrequencyBuffChance;
  final double extraLifeBuffChance;
  final double threeBulletsBuffChance;
  final double scoreForNextLevel;
  final String videoPath;
  final List<QuestionModel> questions;
  final List<HistoryModel> history;
  final String historyButtonPath;
  final HistoryModel? correctCard;
  final HistoryModel? incorrectCard;

  LevelModel({
    required this.levelNumber,
    required this.background,
    required this.bulletSpeed,
    required this.meteorSpeed,
    required this.nicikSpeed,
    required this.bulletFrequency,
    required this.meteorFrequency,
    required this.nicikFrequency,
    required this.angryBirdBuffChance,
    required this.bulletFrequencyBuffChance,
    required this.extraLifeBuffChance,
    required this.threeBulletsBuffChance,
    required this.scoreForNextLevel,
    required this.videoPath,
    required this.questions,
    required this.history,
    required this.historyButtonPath,
    this.correctCard,
    this.incorrectCard,
  });
}
