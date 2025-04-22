import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;
  final bool showCorrectAnswer;
  final VoidCallback onTap;
  final IconData? icon;

  const OptionTile({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    required this.showCorrectAnswer,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (showCorrectAnswer) {
      if (isCorrect) {
        color = Colors.green;
      } else if (isSelected) {
        color = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: color,
        child: ListTile(
          leading: icon != null ? Icon(icon, color: color != null ? Colors.white : null) : null,
          title: Text(
            text,
            style: TextStyle(color: color != null ? Colors.white : null),
          ),
          onTap: showCorrectAnswer ? null : onTap,
        ),
      ),
    );
  }
}