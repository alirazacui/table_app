import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/test_result.dart';
import '../services/db_helper.dart';
import '../utils/data_generator.dart';

class QuizProvider with ChangeNotifier {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  String? selectedAnswer;
  String inputAnswer = '';
  bool showCorrectAnswer = false;
  bool showAnswers = false;
  List<Map<String, String>> userAnswers = [];
  QuestionType currentQuestionType = QuestionType.multipleChoice;

  void initializeQuiz({
    int? tableNumber,
    bool? isMultiplication,
    required QuestionType questionType,
    List<String>? operations,
    int? minNumber,
    int? maxNumber,
  }) {
    questions = DataGenerator.generateQuestions(
      tableNumber: tableNumber,
      isMultiplication: isMultiplication,
      questionType: questionType,
      operations: operations,
      minNumber: minNumber,
      maxNumber: maxNumber,
    );
    currentQuestionIndex = 0;
    correctAnswers = 0;
    wrongAnswers = 0;
    selectedAnswer = null;
    inputAnswer = '';
    showCorrectAnswer = false;
    userAnswers = [];
    currentQuestionType = questionType;
    notifyListeners();
  }

  void initializeMistakeQuiz(List<Map<String, String>> answers) {
    questions = answers
        .where((answer) => answer['correct'] != answer['user'])
        .map((answer) => Question(
              text: answer['question']!,
              correctAnswer: answer['correct']!,
              options: answer['correct'] == 'True' || answer['correct'] == 'False'
                  ? ['True', 'False']
                  : DataGenerator.generateOptions(answer['correct']!, answer['question']!),
              type: currentQuestionType,
              operation: answer['question']!.contains('+')
                  ? '+'
                  : answer['question']!.contains('-')
                      ? '-'
                      : answer['question']!.contains('*')
                          ? '*'
                          : '/',
            ))
        .toList();
    currentQuestionIndex = 0;
    correctAnswers = 0;
    wrongAnswers = 0;
    selectedAnswer = null;
    inputAnswer = '';
    showCorrectAnswer = false;
    userAnswers = [];
    notifyListeners();
  }

  void answerQuestion(String answer, BuildContext context) async {
    if (!context.mounted) return;
    final question = questions[currentQuestionIndex];
    final isCorrect = answer == question.correctAnswer;
    userAnswers.add({
      'question': question.text,
      'correct': question.correctAnswer,
      'user': answer,
    });

    if (isCorrect) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }

    selectedAnswer = answer;
    showCorrectAnswer = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (currentQuestionIndex < 9) {
      currentQuestionIndex++;
      selectedAnswer = null;
      showCorrectAnswer = false;
      inputAnswer = '';
      notifyListeners();
    } else {
      final result = TestResult(
        completedTests: 1,
        accuracy: correctAnswers / (correctAnswers + wrongAnswers) * 100,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        complexity: questionTypeToComplexity(question.type),
        timestamp: DateTime.now(),
        answers: userAnswers,
      );
      await DBHelper().insertTestResult(result);
    }
  }

  String questionTypeToComplexity(QuestionType type) {
    switch (type) {
      case QuestionType.trueFalse:
        return 'Easy';
      case QuestionType.multipleChoice:
        return 'Medium';
      case QuestionType.input:
        return 'Hard';
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}