// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/question.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/counter_display.dart';
import '../../widgets/option_tile.dart';
import '../result_summary_screen.dart';

class QuestionScreen extends StatefulWidget {
  final int? tableNumber;
  final bool? isMultiplication;
  final QuestionType questionType;
  final List<String>? operations;
  final int? minNumber;
  final int? maxNumber;

  const QuestionScreen({
    super.key,
    this.tableNumber,
    this.isMultiplication,
    required this.questionType,
    this.operations,
    this.minNumber,
    this.maxNumber,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool showReadySetGo = true;
  int animationStep = 0;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.initializeQuiz(
      tableNumber: widget.tableNumber,
      isMultiplication: widget.isMultiplication,
      questionType: widget.questionType,
      operations: widget.operations,
      minNumber: widget.minNumber,
      maxNumber: widget.maxNumber,
    );
    startAnimation();
  }

  void startAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => animationStep = 1);
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => animationStep = 2);
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => showReadySetGo = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Quiz?'),
            content: const Text('Your progress will be lost. Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        if (shouldExit ?? false) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exit Quiz?'),
                  content:
                      const Text('Your progress will be lost. Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (shouldExit ?? false) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            if (showReadySetGo) {
              return Center(
                child: Text(
                  animationStep == 0
                      ? 'Ready'
                      : animationStep == 1
                          ? 'Set'
                          : 'Go!',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ).animate().fadeIn(duration: 800.ms).scale(),
              );
            }

            if (quizProvider.currentQuestionIndex >= 10) {
              return ResultSummaryScreen(
                correctAnswers: quizProvider.correctAnswers,
                wrongAnswers: quizProvider.wrongAnswers,
                answers: quizProvider.userAnswers,
              );
            }

            final question =
                quizProvider.questions[quizProvider.currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CounterDisplay(
                    current: quizProvider.currentQuestionIndex + 1,
                    total: 10,
                    correct: quizProvider.correctAnswers,
                    wrong: quizProvider.wrongAnswers,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (quizProvider.showCorrectAnswer &&
                      question.type == QuestionType.trueFalse)
                    Text(
                      '${question.text} = ${question.correctAnswer}',
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  const SizedBox(height: 20),
                  if (question.type == QuestionType.multipleChoice)
                    ...question.options.map((option) {
                      return OptionTile(
                        text: option,
                        isCorrect: option == question.correctAnswer,
                        isSelected: quizProvider.selectedAnswer == option,
                        showCorrectAnswer: quizProvider.showCorrectAnswer,
                        onTap: () {
                          quizProvider.answerQuestion(option, context);
                        },
                      );
                    }),
                  if (question.type == QuestionType.trueFalse)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OptionTile(
                          text: 'True',
                          isCorrect: question.correctAnswer == 'True',
                          isSelected: quizProvider.selectedAnswer == 'True',
                          showCorrectAnswer: quizProvider.showCorrectAnswer,
                          onTap: () {
                            quizProvider.answerQuestion('True', context);
                          },
                          icon: Icons.check,
                        ),
                        const SizedBox(width: 20),
                        OptionTile(
                          text: 'False',
                          isCorrect: question.correctAnswer == 'False',
                          isSelected: quizProvider.selectedAnswer == 'False',
                          showCorrectAnswer: quizProvider.showCorrectAnswer,
                          onTap: () {
                            quizProvider.answerQuestion('False', context);
                          },
                          icon: Icons.close,
                        ),
                      ],
                    ),
                  if (question.type == QuestionType.input)
                    _buildNumberPad(context, quizProvider, question),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNumberPad(
      BuildContext context, QuizProvider quizProvider, Question question) {
    final answerLength = question.correctAnswer.length;
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: quizProvider.inputAnswer),
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Answer',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          children: [
            ...List.generate(9, (index) => index + 1).map((number) =>
                _numberButton(number.toString(), quizProvider, answerLength)),
            _numberButton('0', quizProvider, answerLength),
            ElevatedButton(
              onPressed: quizProvider.inputAnswer.isNotEmpty
                  ? () {
                      quizProvider.inputAnswer = quizProvider.inputAnswer
                          .substring(0, quizProvider.inputAnswer.length - 1);
                      quizProvider.notifyListeners();
                    }
                  : null,
              child: const Icon(Icons.backspace),
            ),
            ElevatedButton(
              onPressed: quizProvider.inputAnswer.length == answerLength
                  ? () {
                      quizProvider.answerQuestion(
                          quizProvider.inputAnswer, context);
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _numberButton(
      String number, QuizProvider quizProvider, int maxLength) {
    return ElevatedButton(
      onPressed: quizProvider.inputAnswer.length < maxLength
          ? () {
              quizProvider.inputAnswer += number;
              quizProvider.notifyListeners();
            }
          : null,
      child: Text(number, style: const TextStyle(fontSize: 20)),
    );
  }
}
