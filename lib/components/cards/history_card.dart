import 'package:flutter/material.dart';
import 'package:tomtit_game/models/history_model.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class HistoryCard extends StatefulWidget {
  final HistoryModel historyItem;
  final bool isActive;
  final String backgroundImage;
  final String planetImage;
  final int currentIndex;
  final int totalCount;
  final PageController pageController;
  final Function(bool)? onQuestionAnswered;

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
  });
  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  int? _selectedQuestionIndex;
  List<List<bool>> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _initializeAnswers();
    if (widget.historyItem.questions != null &&
        widget.historyItem.questions!.isNotEmpty) {
      _selectedQuestionIndex = 0;
    }
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

  void _checkAnswers() {
    final currentQuestion =
        widget.historyItem.questions![_selectedQuestionIndex!];
    bool allCorrect = true;

    for (int i = 0; i < currentQuestion.answers.length; i++) {
      if (currentQuestion.answers[i].isCorrect !=
          _selectedAnswers[_selectedQuestionIndex!][i]) {
        allCorrect = false;
        break;
      }
    }

    if (widget.onQuestionAnswered != null) {
      widget.onQuestionAnswered!(allCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.5,
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
                              color: const Color.fromARGB(255, 255, 208, 66),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            widget.historyItem.title,
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 208, 66),
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
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  widget.historyItem.description,
                                  style: TextStyles.defaultStyle.copyWith(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
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
          Positioned(
            right: 10,
            top: -20,
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

  Widget _buildQuestionSection() {
    final questions = widget.historyItem.questions!;
    final currentQuestion = questions[_selectedQuestionIndex!];

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(currentQuestion.answers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswers[_selectedQuestionIndex!]
                            [index]
                        ? const Color.fromARGB(255, 255, 208, 66)
                        : Colors.transparent,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.white, // Белая рамка
                        width: 1.0, // Толщина рамки
                      ),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedAnswers[_selectedQuestionIndex!][index] =
                          !_selectedAnswers[_selectedQuestionIndex!][index];
                    });
                  },
                  child: Text(
                    currentQuestion.answers[index].answerText,
                    style: TextStyles.defaultStyle.copyWith(
                      color: Colors.white,
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
              widget.historyItem.questions!.isNotEmpty)
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
                        });
                      },
                    )
                  else if (_selectedQuestionIndex != null)
                    _buildNavigationButton(
                      text: 'Проверить',
                      onPressed: _checkAnswers,
                    ),
                ],
              ),
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double indicatorWidth = 30.0;
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
          fontSize: 20,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}
