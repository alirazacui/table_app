import 'package:flutter/material.dart';
import '../learn_table/question_screen.dart';
import '../../models/question.dart';

class TrainingConfigScreen extends StatefulWidget {
  const TrainingConfigScreen({super.key});

  @override
  State<TrainingConfigScreen> createState() => _TrainingConfigScreenState();
}

class _TrainingConfigScreenState extends State<TrainingConfigScreen> {
  final List<bool> _operations = [true, false, false, false]; // Multiply is default
  int _minNumber = 1;
  int _maxNumber = 10;
  QuestionType _selectedType = QuestionType.multipleChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty'),
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
            const Text('What would you like to train?', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _operationButton('Add', 0, Icons.add),
                _operationButton('Subtract', 1, Icons.remove),
                _operationButton('Multiply', 2, Icons.close),
                _operationButton('Divide', 3, Icons.percent), // Replaced Icons.divide
              ],
            ),
            const SizedBox(height: 20),
            const Text('Difficulty', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Min Number'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _minNumber = int.tryParse(value) ?? 1;
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Max Number'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _maxNumber = int.tryParse(value) ?? 10;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Type of Game', style: TextStyle(fontSize: 20)),
            DropdownButton<QuestionType>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: QuestionType.multipleChoice,
                  child: Text('Test'),
                ),
                DropdownMenuItem(
                  value: QuestionType.trueFalse,
                  child: Text('True/False'),
                ),
                DropdownMenuItem(
                  value: QuestionType.input,
                  child: Text('Input'),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final selectedOps = ['+', '-', '*', '/'].asMap().entries.where((e) => _operations[e.key]).map((e) => e.value).toList();
                  if (selectedOps.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select at least one operation')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(
                        questionType: _selectedType,
                        operations: selectedOps,
                        minNumber: _minNumber,
                        maxNumber: _maxNumber,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text('Start Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operationButton(String label, int index, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 2 || _operations.where((op) => op).length > 1 || !_operations[index]) {
            _operations[index] = !_operations[index];
          }
        });
      },
      child: Card(
        color: _operations[index] ? Colors.blue : Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, color: _operations[index] ? Colors.white : Colors.black),
              Text(
                label,
                style: TextStyle(
                  color: _operations[index] ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}