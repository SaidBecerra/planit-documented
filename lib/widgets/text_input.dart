import 'package:flutter/material.dart';

// A customizable text input widget that wraps a [TextFormField].
///
/// This widget provides a text field with custom styling and validation,
/// commonly used for user input forms.
///
/// **Features:**
/// - Supports input validation and saving with `validator` and `onSaved`.
/// - Provides custom hint text and keyboard input type.
/// - Optional `onChanged` callback to handle input changes.
// ignore: must_be_immutable
class TextInput extends StatelessWidget {
  /// Creates a [TextInput] widget.
  ///
  // * [hintText] is the placeholder text displayed inside the input field.
  // * [textInputType] specifies the type of keyboard to show (e.g., text, email, number).
  // * [validator] is a function for validating the input.
  // * [onSaved] is a callback to save the input value.
  // * [controller] is an optional controller for managing the input text.
  // * [onChanged] is an optional callback triggered whenever the input changes.
  TextInput({
    this.controller,
    required this.validator,
    required this.onSaved,
    required this.textInputType,
    required this.hintText,
    this.onChanged,
    super.key,
  });

  /// The placeholder text displayed inside the input field.
  final String hintText;

  /// Specifies the keyboard type (e.g., text, email, number).
  final TextInputType textInputType;

  /// An optional [TextEditingController] to control the input text.
  final TextEditingController? controller;

  /// A function to validate the input.
  ///
  /// Should return a string if validation fails or `null` if it passes.
  final String? Function(String?) validator;

  /// A callback to save the input value when the form is submitted.
  final void Function(String?) onSaved;

  /// An optional callback that triggers when the input value changes.
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 50,  // Limits the input length to 50 characters.
      decoration: InputDecoration(
        border: const OutlineInputBorder(), // Default border for the input field.
        hintText: hintText,  // Displays the placeholder text.
        counterText: '',  // Hides the character counter below the input field.
        filled: true,
        fillColor: Colors.white,  // Background color of the input field.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Rounded corners for the input field.
          borderSide: BorderSide(color: Colors.grey.shade200),  // Border color when not focused.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),  // Border color when focused.
        ),
      ),
      keyboardType: textInputType,  // Sets the keyboard type.
      controller: controller,  // Uses the provided controller, if any.
      validator: validator,  // Calls the validator function to validate input.
      onSaved: onSaved,  // Calls the onSaved callback to save the input value.
      onChanged: onChanged,  // Calls the onChanged callback when the input changes.
    );
  }
}
