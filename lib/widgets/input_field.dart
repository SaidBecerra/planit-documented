// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/text_input.dart';

/// A custom form field widget that combines a label and an input field.
/// 
/// This widget displays a label above the text input field and provides the 
/// functionality for users to input text. It supports various configurations 
/// like input type, hint text, validation, and optional controller for text
/// management.
///
/// **Features:**
/// - Displays a label using the `LabelText` widget.
/// - Uses the `TextInput` widget for input functionality, with customizable 
///   hint text, keyboard type, and validation.
class InputField extends StatelessWidget {
  /// Creates an [InputField] widget.
  ///
  // [label] - The label text displayed above the input field.
  // [hint] - The hint text shown inside the input field.
  // [inputType] - The type of keyboard to display (e.g., text, email, etc.).
  // [validator] - An optional validation function for the input.
  // [onSaved] - An optional function to save the value of the input.
  // [onChanged] - An optional function to handle changes in the input.
  // [controller] - An optional TextEditingController to manage the input.
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
        LabelText(text: label),  // Display the label
        const SizedBox(
          height: 5,  // Small gap between the label and input
        ),
        TextInput(
          hintText: hint,  // Set the hint text
          onChanged: onChanged,
          textInputType: inputType,  // Set the input type (keyboard type)
          validator: validator ?? (value) => null,  // Use the provided validator
          onSaved: onSaved ?? (value) {},  // Use the provided onSaved function
          controller: controller,  // Pass the controller for text management
        ),
      ],
    );
  }
}
