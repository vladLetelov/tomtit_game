class QuestionModel {
  QuestionModel({required this.question, required this.variants, required this.rightAnswer});

  final String question;
  final List<String> variants;
  final int rightAnswer;
}