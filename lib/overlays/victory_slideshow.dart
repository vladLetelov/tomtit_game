import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/storage/user_data.dart';
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
  String? _userName;
  bool _isCheckingUserData = true;
  bool _hasUserData = false;
  bool _showNameForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GameScoreManager.setLevelScore(
          widget.game.levelModel.levelNumber, widget.game.scoreNotifier.value);
    });
    _checkUserData(); // Сначала проверяем наличие ФИО
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Проверяем, ввел ли пользователь ФИО
  Future<void> _checkUserData() async {
    final hasData = await UserDataManager.hasUserData();
    setState(() {
      _hasUserData = hasData;
      _isCheckingUserData = false;
      _showNameForm = !hasData; // Показываем форму если нет данных
    });

    // Если данные есть, загружаем остальное и запускаем слайдшоу
    if (hasData) {
      _loadData();
      _loadUserName();
      _startSlideshow();
    }
  }

  Future<void> _loadUserName() async {
    final userName = await UserDataManager.getUserName();
    setState(() {
      _userName = userName;
    });
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

  // Метод для сохранения имени и продолжения
  Future<void> _saveNameAndContinue(String name) async {
    await UserDataManager.saveUserName(name);
    setState(() {
      _hasUserData = true;
      _showNameForm = false;
      _userName = name;
    });
    _loadData();
    _startSlideshow();
  }

  // Виджет формы ввода имени
  Widget _buildNameForm() {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;
    const mainBackground = 'assets/images/multSpaceBackground.jpg';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(mainBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Поздравляем с прохождением!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.celebration_outlined,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _NameInputForm(
                          onNameSaved: _saveNameAndContinue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Показываем индикатор загрузки при проверке данных
    if (_isCheckingUserData) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Показываем форму ввода имени если нужно
    if (_showNameForm) {
      return _buildNameForm();
    }

    // Основной слайдшоу
    final images = widget.game.levelModel.victorySlideshowImages!;
    const mainBackground = 'assets/images/multSpaceBackground.jpg';
    final additionalBackground =
        widget.game.levelModel.victorySlideshowBackground;
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(mainBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (additionalBackground != null)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(additionalBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final safePadding = mediaQuery.padding;
                final viewInsets = mediaQuery.viewInsets;
                final availableHeight = constraints.maxHeight - safePadding.top;
                final availableWidth = constraints.maxWidth;
                final isVerySmallScreen = availableHeight < 400;

                return Stack(
                  children: [
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
                    if (_showCompletion)
                      Positioned(
                        bottom: viewInsets.bottom + 20,
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

                                const SizedBox(height: 10),

                                // Отображаем ФИО игрока
                                Text(
                                  'Игрок: $_userName',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: isVerySmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'Заработано ${getNicikUnit(_totalScore)}: $_totalScore',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
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

// Отдельный виджет для формы ввода имени
class _NameInputForm extends StatefulWidget {
  final Function(String) onNameSaved;

  const _NameInputForm({required this.onNameSaved});

  @override
  State<_NameInputForm> createState() => _NameInputFormState();
}

class _NameInputFormState extends State<_NameInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitName() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.onNameSaved(_nameController.text.trim());
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка сохранения: $e')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите ваше ФИО';
    }

    final nameParts =
        value.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      return 'Пожалуйста, введите фамилию, имя и отчество (полностью)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Для получения нициков необходимо представиться',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Фамилия Имя Отчество',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: _validateName,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Text(
              '⚠️ ФИО будет использоваться для отправки нициков и НЕ может быть изменено позже',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitName,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Продолжить просмотр результатов',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
