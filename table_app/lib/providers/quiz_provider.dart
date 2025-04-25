import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/data_generator.dart';
import '../screens/result_summary_screen.dart';

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
  bool quizCompleted = false;

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
    quizCompleted = false;
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
    quizCompleted = false;
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

    if (!context.mounted) return;

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      selectedAnswer = null;
      showCorrectAnswer = false;
      inputAnswer = '';
      notifyListeners();
    } else {
      quizCompleted = true;
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultSummaryScreen(
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            answers: userAnswers,
          ),
        ),
      );
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