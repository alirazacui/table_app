enum QuestionType { multipleChoice, trueFalse, input }

class Question {
  final String text;
  final String correctAnswer;
  final List<String> options;
  final QuestionType type;
  final String operation;

  Question({
    required this.text,
    required this.correctAnswer,
    this.options = const [],
    required this.type,
    required this.operation,
  });
}