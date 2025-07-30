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
  });
}

class Question {
  final String questionText; // Текст вопроса
  final List<Answer> answers; // Список ответов

  Question({
    required this.questionText,
    required this.answers,
  });
}

class Answer {
  final String answerText; // Текст ответа
  final bool isCorrect; // Флаг, указывающий, является ли ответ правильным

  Answer({
    required this.answerText,
    required this.isCorrect,
  });
}
