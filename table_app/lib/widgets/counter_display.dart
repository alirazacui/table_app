import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int current;
  final int total;
  final int correct;
  final int wrong;

  const CounterDisplay({
    super.key,
    required this.current,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Question $current/$total',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _counterBox(correct, Colors.green),
            const SizedBox(width: 20),
            _counterBox(wrong, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _counterBox(int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}