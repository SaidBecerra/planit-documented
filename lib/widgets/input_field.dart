import 'package:flutter/material.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/text_input.dart';

class InputField extends StatelessWidget {
  const InputField(
      {required this.label,
      required this.hint,
      required this.inputType,
      this.validator,
      this.onSaved,
      super.key});

  final String label;
  final String hint;
  final TextInputType inputType;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;

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
          textInputType: inputType,
          validator: validator ?? (value) => null,
          onSaved: onSaved ?? (value) {},
        ),
      ],
    );
  }
}
