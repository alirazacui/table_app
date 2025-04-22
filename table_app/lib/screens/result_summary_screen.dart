import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'learn_table/question_screen.dart';

class ResultSummaryScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final List<Map<String, String>> answers;

  const ResultSummaryScreen({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.answers,
  });

  String getRemark() {
    final score = correctAnswers / (correctAnswers + wrongAnswers);
    if (score >= 0.9) return 'Excellent!';
    if (score >= 0.7) return 'Good!';
    if (score >= 0.5) return 'Keep Practicing!';
    return 'Try Harder!';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Results: $correctAnswers Correct, $wrongAnswers Incorrect',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              getRemark(),
              style: const TextStyle(fontSize: 28, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    quizProvider.showAnswers = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _AnswersScreen(answers: answers),
                      ),
                    );
                  },
                  child: const Text('See Answers'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswersScreen extends StatelessWidget {
  final List<Map<String, String>> answers;

  const _AnswersScreen({required this.answers});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final answer = answers[index];
          final isCorrect = answer['correct'] == answer['user'];
          return Card(
            child: ListTile(
              title: Text(answer['question']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Correct: ${answer['correct']}'),
                  Text(
                    'Your Answer: ${answer['user']}',
                    style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                quizProvider.initializeMistakeQuiz(answers);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      questionType: quizProvider.currentQuestionType,
                    ),
                  ),
                );
              },
              child: const Text('Work on Mistakes'),
            ),
          ],
        ),
      ),
    );
  }
}