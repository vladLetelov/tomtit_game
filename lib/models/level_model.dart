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
  final bool hasNiciks; // true - будут обычные ницики
  final bool hasColoredSinicis; // true - будут цветные птички
  final double? coloredSinicaFrequency; // null - не появляются
  final double? coloredSinicaSpeed; // скорость падения
  final double angryBirdBuffChance;
  final double bulletFrequencyBuffChance;
  final double extraLifeBuffChance;
  final double threeBulletsBuffChance;
  final double scoreForNextLevel;
  final List<HistoryModel> history;
  final String historyButtonPath;
  final HistoryModel? correctCard;
  final HistoryModel? incorrectCard;
  final int? timeLimit;
  final double sinicaSize;
  final bool? tripleSinicaMode;

  LevelModel({
    required this.levelNumber,
    required this.background,
    required this.bulletSpeed,
    required this.meteorSpeed,
    required this.nicikSpeed,
    required this.bulletFrequency,
    required this.meteorFrequency,
    required this.nicikFrequency,
    this.hasNiciks = true,
    this.hasColoredSinicis = false,
    this.coloredSinicaFrequency,
    this.coloredSinicaSpeed,
    required this.angryBirdBuffChance,
    required this.bulletFrequencyBuffChance,
    required this.extraLifeBuffChance,
    required this.threeBulletsBuffChance,
    required this.scoreForNextLevel,
    required this.history,
    required this.historyButtonPath,
    this.correctCard,
    this.incorrectCard,
    this.timeLimit,
    this.sinicaSize = 50.0,
    this.tripleSinicaMode = false,
  });
}
