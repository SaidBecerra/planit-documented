import 'package:flutter/material.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/text_input.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  InputField({
    required this.label,
    required this.hint,
    required this.inputType,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.controller,  // Added optional controller parameter
    super.key,
  });

  final String label;
  final String hint;
  final TextInputType inputType;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  void Function(String)? onChanged;
  final TextEditingController? controller;  // Added controller field

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(text: label),
        const SizedBox(
          height: 5,
        ),
        TextInput(
          hintText: hint,
          onChanged: onChanged,
          textInputType: inputType,
          validator: validator ?? (value) => null,
          onSaved: onSaved ?? (value) {},
          controller: controller,  // Pass the controller to TextInput
        ),
      ],
    );
  }
}