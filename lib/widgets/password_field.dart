import 'package:flutter/material.dart';

/// A custom password input field with a toggleable visibility option.
///
/// This widget provides a password input field with a built-in "show/hide password" feature.
/// It displays an icon in the suffix of the input field, which the user can tap to toggle password visibility.
class PasswordField extends StatefulWidget {
  // Creates a [PasswordField].
  ///
  // * [validator] is a required function that validates the input value.
  // * [onSaved] is a required function that saves the input value.
  const PasswordField({
    super.key,
    required this.validator,
    required this.onSaved,
  });

  /// Function to validate the input. Returns a string if validation fails, or null if the input is valid.
  final String? Function(String?) validator;

  /// Function to handle saving the input value.
  final void Function(String?) onSaved;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  /// Determines whether the password is obscured or visible.
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,  // Obscures the text if true, showing dots instead of characters.
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Rounded corners for the input field.
        ),
        hintText: 'Enter your password',  // Placeholder text for the input field.
        filled: true,
        fillColor: Colors.white,  // White background for the input field.
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,  // Icon toggles between visibility states.
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;  // Toggles password visibility.
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),  // Light gray border when not focused.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),  // Darker gray border when focused.
        ),
      ),
      validator: widget.validator,  // Validates the input using the provided validator function.
      onSaved: widget.onSaved,  // Saves the input using the provided onSaved function.
    );
  }
}
