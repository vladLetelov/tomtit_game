import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/components/cards/level_step_card.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/storage/user_data.dart'; // Добавляем импорт
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/screens/level_histories_screen.dart';
import 'package:tomtit_game/screens/help_screen.dart';
import 'package:tomtit_game/screens/user_data_screen.dart'; // Добавляем импорт

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _totalScore = 0;
  late ScrollController _scrollController;
  int? _lastPlayedLevel;
  bool _isCheckingUserData = true; // Флаг проверки данных пользователя
  bool _hasUserData = false; // Есть ли данные пользователя

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _checkUserData(); // Сначала проверяем данные пользователя
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Проверяем, ввел ли пользователь ФИО
  Future<void> _checkUserData() async {
    final hasData = await UserDataManager.hasUserData();
    setState(() {
      _hasUserData = hasData;
      _isCheckingUserData = false;
    });

    // Если данные есть, загружаем остальные данные
    if (hasData) {
      _loadData();
      _loadLastPlayedLevel();
    }
  }

  Future<void> _loadLastPlayedLevel() async {
    final lastLevel = await GameScoreManager.getLastPlayedLevel();
    if (mounted) {
      setState(() {
        _lastPlayedLevel = lastLevel;
      });
    }
  }

  Future<void> _loadData() async {
    await GameScoreManager.init();
    if (mounted) {
      _updateTotalScore();
    }
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

    levelCards.add(const Center(child: LevelCardConnector()));

    for (var levelEntry in levels.entries) {
      final levelNumber = levelEntry.value.levelNumber;

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

  // Метод для отображения диалога редактирования ФИО
  void _showEditNameDialog(BuildContext context) async {
    final currentName = await UserDataManager.getUserName();
    final canChangeName = await UserDataManager.isNameChangeAllowed();
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(canChangeName ? 'Редактирование ФИО' : 'Ваше ФИО'),
        content: canChangeName
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Фамилия Имя Отчество',
                      hintText: 'Введите ваше полное ФИО',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '* ФИО можно сменить ОДИН раз!!!',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 12,
                      color: Colors.red, // Лучше красным для предупреждения
                    ),
                  ),
                ],
              )
            : Text(
                currentName ?? 'Не указано',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          if (canChangeName)
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  try {
                    await UserDataManager.updateUserName(
                        controller.text.trim());
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ФИО сохранено')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Сохранить'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Если проверяем данные пользователя, показываем загрузку
    if (_isCheckingUserData) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: backgroundGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Если пользователь не ввел ФИО, показываем экран ввода
    if (!_hasUserData) {
      return UserNameScreen(
        onNameSaved: () {
          setState(() {
            _hasUserData = true;
          });
          _loadData();
          _loadLastPlayedLevel();
        },
      );
    }

    // Основной интерфейс выбора уровней
    if (_lastPlayedLevel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToLevel(_lastPlayedLevel!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        // title: const Text('Выберите уровень', style: TextStyles.defaultStyle),
        actions: [
          // Кнопка редактирования ФИО
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 28),
              onPressed: () {
                _showEditNameDialog(context);
              },
              tooltip: 'Редактировать ФИО',
            ),
          ),
          // Кнопка справки
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
