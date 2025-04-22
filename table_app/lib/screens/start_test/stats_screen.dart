import 'package:flutter/material.dart';
import '../learn_table/question_screen.dart';
import '../../models/question.dart';
import '../../services/db_helper.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int completedTests = 0;
  double accuracy = 0.0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final results = await DBHelper().getTestResults();
    setState(() {
      completedTests = results.length;
      correctAnswers = results.fold(0, (sum, r) => sum + r.correctAnswers);
      wrongAnswers = results.fold(0, (sum, r) => sum + r.wrongAnswers);
      accuracy = correctAnswers + wrongAnswers > 0
          ? (correctAnswers / (correctAnswers + wrongAnswers) * 100).roundToDouble()
          : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _statRow('Completed Tests', completedTests.toString()),
                    _statRow('Accuracy', '$accuracy%'),
                    _statRow('Correct Answers', correctAnswers.toString()),
                    _statRow('Wrong Answers', wrongAnswers.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Choose Complexity', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            _complexityButton(context, 'Easy', QuestionType.trueFalse),
            _complexityButton(context, 'Medium', QuestionType.multipleChoice),
            _complexityButton(context, 'Hard', QuestionType.input),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _complexityButton(BuildContext context, String label, QuestionType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionScreen(
                questionType: type,
                operations: ['+', '-', '*', '/'],
                minNumber: 1,
                maxNumber: 100,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(label),
      ),
    );
  }
}