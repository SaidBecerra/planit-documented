import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
    {
      this.controller,
      required this.validator,
      required this.onSaved,
      required this.textInputType,
      required this.hintText,
      super.key
    }
  );
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 50,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
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
      controller: controller,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
