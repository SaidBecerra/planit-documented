import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {required this.textInputType, required this.hintText, super.key});
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 50,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      keyboardType: textInputType,
    );
  }
}
