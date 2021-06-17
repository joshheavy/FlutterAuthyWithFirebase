import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0, vertical: 10.0
        ),
      ),
      onPressed: onPressed, 
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
