class HistoryModel {
  final String title;
  final String? description;
  final String? pathImg;
  final List<String>? additionalImages;
  final List<Question>? questions;
  final bool isResultCard; // Новая поле - является ли карточка результатом
  final bool?
      isCorrect; // Новое поле - правильный ли ответ (только для карточек результата)
  final int? questionId; // Уникальный ID вопроса
  final List<HistoryModel>? resultCards; // Карты результатов для этого вопроса
  final bool isImageOnly;
  final String? relatedQuestionId;

  HistoryModel({
    required this.title,
    this.description,
    this.pathImg,
    this.additionalImages,
    this.questions,
    this.isResultCard = false,
    this.isCorrect,
    this.isImageOnly = false,
    this.questionId,
    this.resultCards,
    this.relatedQuestionId,
  });
}

class Question {
  final String id;
  final String questionText;
  final List<Answer> answers;
  final HistoryModel? correctCard; // Карточка для правильного ответа
  final HistoryModel? incorrectCard; // Карточка для неправильного ответа

  Question({
    required this.id,
    required this.questionText,
    required this.answers,
    this.correctCard,
    this.incorrectCard,
  });

  // Метод для определения типа вопроса
  bool get isSingleChoice {
    // Если только один правильный ответ - это одиночный выбор
    int correctCount = 0;
    for (var answer in answers) {
      if (answer.isCorrect) {
        correctCount++;
      }
    }
    return correctCount == 1;
  }
}

class Answer {
  final String answerText; // Текст ответа
  final bool isCorrect; // Флаг, указывающий, является ли ответ правильным

  Answer({
    required this.answerText,
    required this.isCorrect,
  });
}
