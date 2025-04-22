import 'package:flutter/material.dart';
import 'question_screen.dart';
import '../../models/question.dart'; // Added import for QuestionType

class TableDetailScreen extends StatelessWidget {
  final int tableNumber;

  const TableDetailScreen({super.key, required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table of $tableNumber'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(10, (index) {
                    final multiplier = index + 1;
                    return Text(
                      '$tableNumber x $multiplier = ${tableNumber * multiplier}',
                      style: const TextStyle(fontSize: 20),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      tableNumber: tableNumber,
                      isMultiplication: true,
                      questionType: QuestionType.multipleChoice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('Start Multiplication'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      tableNumber: tableNumber,
                      isMultiplication: false,
                      questionType: QuestionType.multipleChoice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('Start Division'),
            ),
          ],
        ),
      ),
    );
  }
}