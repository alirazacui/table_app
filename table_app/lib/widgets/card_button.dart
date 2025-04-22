import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CardButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}