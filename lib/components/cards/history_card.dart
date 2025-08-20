import 'package:flutter/material.dart';
import 'package:tomtit_game/models/history_model.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/components/game_buttons/history_button.dart';
import 'package:tomtit_game/storage/game_score.dart';

class HistoryCard extends StatefulWidget {
  final HistoryModel historyItem;
  final bool isActive;
  final String backgroundImage;
  final String planetImage;
  final int currentIndex;
  final int totalCount;
  final PageController pageController;
  final Function(bool, String)? onQuestionAnswered;
  final int levelNumber;

  const HistoryCard({
    super.key,
    required this.historyItem,
    required this.backgroundImage,
    required this.planetImage,
    required this.currentIndex,
    required this.totalCount,
    required this.pageController,
    this.onQuestionAnswered,
    this.isActive = false,
    required this.levelNumber,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  int? _selectedQuestionIndex;
  List<List<bool>> _selectedAnswers = [];
  bool _isQuestionAnswered = false;
  bool _resultCardShown = false;
  bool? _lastAnswerCorrect;
  String? _currentQuestionId;
  int? _singleSelectedIndex;

  @override
  void initState() {
    super.initState();
    _initializeAnswers();
    if (widget.historyItem.questions != null &&
        widget.historyItem.questions!.isNotEmpty) {
      _selectedQuestionIndex = 0;
      _currentQuestionId = widget.historyItem.questions![0].id;
      _loadQuestionState();
    }
    _checkForResultCard();
  }

  void _checkForResultCard() {
    if (widget.historyItem.isResultCard) {
      setState(() {
        _resultCardShown = true;
      });
      return;
    }

    if (_selectedQuestionIndex != null && _currentQuestionId != null) {
      final wasShown = GameScoreManager.wasQuestionResultShownById(
        widget.levelNumber,
        _currentQuestionId!,
      );
      final isCorrect = GameScoreManager.getQuestionResultCorrectnessById(
        widget.levelNumber,
        _currentQuestionId!,
      );

      if (wasShown == true) {
        setState(() {
          _resultCardShown = true;
          _lastAnswerCorrect = isCorrect;
          _isQuestionAnswered = true;
        });
      }
    }
  }

  void _loadQuestionState() {
    if (_selectedQuestionIndex == null) return;

    final question = widget.historyItem.questions![_selectedQuestionIndex!];
    _currentQuestionId = question.id;

    // Проверяем, был ли ответ на текущий вопрос
    final isAnswered = GameScoreManager.getQuestionResultById(
            widget.levelNumber, _currentQuestionId!) !=
        null;

    if (isAnswered) {
      // Загружаем сохраненные ответы
      for (int i = 0; i < question.answers.length; i++) {
        final wasSelected = GameScoreManager.getQuestionResultById(
                widget.levelNumber, _currentQuestionId!,
                answerIndex: i) ??
            false;
        _selectedAnswers[_selectedQuestionIndex!][i] = wasSelected;

        // Для одиночного выбора запоминаем выбранный индекс
        if (wasSelected && question.isSingleChoice) {
          _singleSelectedIndex = i;
        }
      }
    }

    setState(() {
      _isQuestionAnswered = isAnswered;
    });
  }

  void _initializeAnswers() {
    if (widget.historyItem.questions != null) {
      _selectedAnswers = List.generate(
        widget.historyItem.questions!.length,
        (i) =>
            List.filled(widget.historyItem.questions![i].answers.length, false),
      );
    }
  }

  Future<void> _checkAnswers() async {
    final currentQuestion =
        widget.historyItem.questions![_selectedQuestionIndex!];
    final isSingleChoice = currentQuestion.isSingleChoice;
    int correctAnswersCount = 0;
    int totalCorrectAnswers = 0;

    // Считаем общее количество правильных ответов
    for (int i = 0; i < currentQuestion.answers.length; i++) {
      if (currentQuestion.answers[i].isCorrect) {
        totalCorrectAnswers++;
      }
    }

    // Проверяем выбранные ответы
    bool allCorrect = true;

    if (isSingleChoice) {
      // Для одиночного выбора: проверяем, выбран ли правильный ответ
      if (_singleSelectedIndex != null) {
        final selectedAnswer = currentQuestion.answers[_singleSelectedIndex!];
        allCorrect = selectedAnswer.isCorrect;
        correctAnswersCount = allCorrect ? 1 : 0;
      } else {
        allCorrect = false;
      }
    } else {
      // Для множественного выбора: проверяем все ответы
      for (int i = 0; i < currentQuestion.answers.length; i++) {
        final isCorrectAnswer = currentQuestion.answers[i].isCorrect;
        final isSelected = _selectedAnswers[_selectedQuestionIndex!][i];

        // Если ответ правильный И выбран - считаем
        if (isCorrectAnswer && isSelected) {
          correctAnswersCount++;
        }
        // Если ответ неправильный И выбран - это ошибка
        else if (!isCorrectAnswer && isSelected) {
          allCorrect = false;
        }
        // Если ответ правильный НО не выбран - тоже ошибка
        else if (isCorrectAnswer && !isSelected) {
          allCorrect = false;
        }
      }

      // Проверяем, что все правильные ответы выбраны и нет лишних
      allCorrect = allCorrect && (correctAnswersCount == totalCorrectAnswers);
    }

    // Сохраняем каждый ответ
    for (int i = 0; i < currentQuestion.answers.length; i++) {
      await GameScoreManager.saveQuestionAnswerById(
        widget.levelNumber,
        _currentQuestionId!,
        i,
        _selectedAnswers[_selectedQuestionIndex!][i],
      );
    }

    // Сохраняем факт ответа на вопрос и результат
    await GameScoreManager.saveQuestionResultById(
      widget.levelNumber,
      _currentQuestionId!,
      allCorrect,
    );

    // Начисляем очки
    if (correctAnswersCount > 0) {
      await GameScoreManager.awardPointsForPartialAnswer(
        widget.levelNumber,
        _currentQuestionId!,
        correctAnswersCount,
      );
    }

    // Сохраняем, что карточка результата была показана
    await GameScoreManager.saveResultCardShownById(
      widget.levelNumber,
      _currentQuestionId!,
    );

    setState(() {
      _isQuestionAnswered = true;
      _lastAnswerCorrect = allCorrect;
    });

    if (widget.onQuestionAnswered != null) {
      widget.onQuestionAnswered!(allCorrect, _currentQuestionId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.historyItem.isImageOnly)
            HistoryGameButton(
              onTap: () {},
              backgroundImage: widget.historyItem.pathImg!,
            )
          else
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.7,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: widget.isActive
                    ? Border.all(color: Colors.deepPurple, width: 2)
                    : null,
                image: DecorationImage(
                  image: AssetImage(widget.backgroundImage),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.9),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.historyItem.isResultCard
                                    ? (widget.historyItem.isCorrect ?? false)
                                        ? const Color.fromARGB(255, 2, 255, 23)
                                        : const Color.fromARGB(255, 252, 0, 0)
                                    : const Color.fromARGB(255, 255, 208, 66),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              widget.historyItem.title,
                              style: TextStyles.defaultStyle.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: widget.historyItem.isResultCard
                                    ? (widget.historyItem.isCorrect ?? false)
                                        ? const Color.fromARGB(255, 2, 255, 23)
                                        : const Color.fromARGB(255, 252, 0, 0)
                                    : const Color.fromARGB(255, 255, 208, 66),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (widget.historyItem.questions != null &&
                              widget.historyItem.questions!.isNotEmpty)
                            _buildQuestionSection()
                          else
                            Expanded(
                              child: Center(
                                child: _buildContentSection(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomSection(),
                ],
              ),
            ),
          if (!widget.historyItem.isImageOnly)
            Positioned(
              right: 15,
              top: -30,
              child: Image.asset(
                widget.planetImage,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    print('description: ${widget.historyItem.description}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.historyItem.description != null &&
              widget.historyItem.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.historyItem.description!,
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          if (widget.historyItem.pathImg != null)
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.45, // было 0.6
                ),
                child: Image.asset(
                  widget.historyItem.pathImg!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection() {
    final questions = widget.historyItem.questions!;
    final currentQuestion = questions[_selectedQuestionIndex!];
    final isSingleChoice = currentQuestion.isSingleChoice;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(currentQuestion.answers.length, (index) {
              final isCorrectAnswer = currentQuestion.answers[index].isCorrect;
              final isSelected =
                  _selectedAnswers[_selectedQuestionIndex!][index];
              final wasSelectedByUser =
                  isSelected; // Ответ был выбран пользователем

              Color? buttonColor;
              Color textColor = Colors.white;
              Color borderColor = Colors.white;
              double borderWidth = 1.0;

              if (_isQuestionAnswered) {
                // Всегда показываем правильные ответы зелёным
                if (isCorrectAnswer) {
                  buttonColor = Colors.green.withOpacity(0.3);
                  borderColor = Colors.green;
                  textColor = Colors.green;
                }
                // Показываем выбранные неправильные ответы красным
                else {
                  buttonColor = Colors.red.withOpacity(0.3);
                  borderColor = Colors.red;
                  textColor = Colors.red;
                }

                // Добавляем желтую рамку для ответов, выбранных пользователем
                if (wasSelectedByUser) {
                  borderColor =
                      const Color.fromARGB(255, 255, 208, 66); // Желтый цвет
                  borderWidth = 2.0; // Более толстая рамка
                }
              } else {
                // До ответа: желтый фон для выбранных ответов
                buttonColor = isSelected
                    ? const Color.fromARGB(255, 255, 208, 66).withOpacity(0.3)
                    : Colors.transparent;
                // Желтая рамка для выбранных ответов
                if (isSelected) {
                  borderColor = const Color.fromARGB(255, 255, 208, 66);
                  borderWidth = 2.0;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isQuestionAnswered
                      ? null
                      : () {
                          setState(() {
                            if (isSingleChoice) {
                              // Для одиночного выбора - сбрасываем все и выбираем текущий
                              for (int i = 0;
                                  i <
                                      _selectedAnswers[_selectedQuestionIndex!]
                                          .length;
                                  i++) {
                                _selectedAnswers[_selectedQuestionIndex!][i] =
                                    false;
                              }
                              _selectedAnswers[_selectedQuestionIndex!][index] =
                                  true;
                              _singleSelectedIndex = index;
                            } else {
                              // Для множественного выбора - переключаем текущий
                              _selectedAnswers[_selectedQuestionIndex!][index] =
                                  !_selectedAnswers[_selectedQuestionIndex!]
                                      [index];
                            }
                          });
                        },
                  child: Center(
                    child: Text(
                      currentQuestion.answers[index].answerText,
                      textAlign: TextAlign.center,
                      style: TextStyles.defaultStyle.copyWith(
                        fontSize: 13,
                        color: textColor,
                        fontWeight: _isQuestionAnswered && isCorrectAnswer
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          if (widget.historyItem.questions != null &&
              widget.historyItem.questions!
                  .isNotEmpty) // Убрали проверку на _isQuestionAnswered
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedQuestionIndex != null &&
                      _selectedQuestionIndex! <
                          widget.historyItem.questions!.length - 1)
                    _buildNavigationButton(
                      text: 'Далее',
                      onPressed: () {
                        setState(() {
                          _selectedQuestionIndex = _selectedQuestionIndex! + 1;
                          _currentQuestionId = widget.historyItem
                              .questions![_selectedQuestionIndex!].id;
                          _loadQuestionState();
                        });
                      },
                    )
                  else if (_selectedQuestionIndex != null)
                    _buildNavigationButton(
                      text: 'Проверить',
                      onPressed: _isQuestionAnswered ? () => {} : _checkAnswers,
                    ),
                ],
              ),
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double indicatorWidth = 30.0;
                final double maxOffset = constraints.maxWidth - indicatorWidth;
                final double offset =
                    maxOffset * widget.currentIndex / (widget.totalCount - 1);

                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: offset,
                      child: Container(
                        width: indicatorWidth,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 208, 66),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
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

  Widget _buildNavigationButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 208, 66),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyles.defaultStyle.copyWith(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}
