import 'dart:math';
import '../models/question.dart';

class DataGenerator {
  static List<Question> generateQuestions({
    int? tableNumber,
    bool? isMultiplication,
    required QuestionType questionType,
    List<String>? operations,
    int? minNumber,
    int? maxNumber,
  }) {
    final random = Random();
    final questions = <Question>[];
    final ops = operations ?? (isMultiplication != null ? [isMultiplication ? '*' : '/'] : ['+', '-', '*', '/']);
    final min = minNumber ?? 1;
    final max = maxNumber ?? (tableNumber != null ? 10 : 100);

    for (int i = 0; i < 10; i++) {
      final op = ops[random.nextInt(ops.length)];
      int num1 = tableNumber ?? random.nextInt(max - min + 1) + min;
      int num2 = random.nextInt(max - min + 1) + min;
      String text;
      String correctAnswer;
      List<String> options = [];

      if (op == '/' && tableNumber != null) {
        num1 = num2 * tableNumber; // Ensure divisible for division
      }

      switch (op) {
        case '+':
          text = '$num1 + $num2 = ?';
          correctAnswer = (num1 + num2).toString();
          break;
        case '-':
          text = '$num1 - $num2 = ?';
          correctAnswer = (num1 - num2).toString();
          break;
        case '*':
          text = '$num1 x $num2 = ?';
          correctAnswer = (num1 * num2).toString();
          break;
        case '/':
          text = '$num1 ÷ $num2 = ?';
          correctAnswer = (num1 ~/ num2).toString();
          break;
        default:
          text = '';
          correctAnswer = '';
      }

      if (questionType == QuestionType.multipleChoice) {
        options = generateOptions(correctAnswer, text);
      } else if (questionType == QuestionType.trueFalse) {
        final isTrue = random.nextBool();
        final wrongAnswer = (int.parse(correctAnswer) + (random.nextBool() ? 1 : -1) * random.nextInt(10)).toString();
        text = '$text ${isTrue ? correctAnswer : wrongAnswer}';
        correctAnswer = isTrue.toString();
        options = ['True', 'False'];
      }

      questions.add(Question(
        text: text,
        correctAnswer: correctAnswer,
        options: options,
        type: questionType,
        operation: op,
      ));
    }
    return questions;
  }

  static List<String> generateOptions(String correctAnswer, String question) {
    final random = Random();
    final correct = int.parse(correctAnswer);
    final options = <String>{correctAnswer};

    while (options.length < 4) {
      final offset = random.nextInt(10) + 1;
      final wrong = correct + (random.nextBool() ? offset : -offset);
      if (wrong >= 0) options.add(wrong.toString());
    }

    return options.toList()..shuffle();
  }
}