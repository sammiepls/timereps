import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final Color backgroundColor;

  const Button(
      {required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.brown,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: Colors.grey.shade900,
        ),
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ));
  }
}
