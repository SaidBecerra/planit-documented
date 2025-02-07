import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A square-shaped text field widget used for OTP (One-Time Password) input.
///
/// This widget is designed to display a single input box for OTP digits with a customized 
/// appearance. It automatically moves the focus to the next field when the user enters a digit, 
/// and moves focus to the previous field if the input is deleted.
///
/// **Features:**
/// - Custom size based on screen width.
class OtpSquare extends StatelessWidget {
  //  Creates an [OtpSquare] widget.
  ///
  // * [inputFormatters] is an optional list of input formatters used to restrict input.
  const OtpSquare({
    super.key,
    required this.inputFormatters,
  });

  /// Optional input formatters that limit the characters that can be entered.
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    // Determines the size of the square based on the screen width.
    double size = MediaQuery.of(context).size.width * 0.14;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),  // Rounded corners for the square.
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(138, 158, 158, 158),  // Light shadow effect.
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),  // Slight offset for shadow.
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,  // No border when the field is not focused.
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,  // No border when the field is enabled.
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFA294F9), width: 2),  // Blue border on focus.
          ),
          filled: true,
          fillColor: Colors.white,  // White background for the input field.
        ),
        textAlign: TextAlign.center,  // Center the text inside the input field.
        keyboardType: TextInputType.number,  // Only numeric input is allowed.
        inputFormatters: inputFormatters,  // Optional input formatters.
        onChanged: (value) {
          // Moves focus to the next field when one digit is entered.
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } 
          // Moves focus to the previous field when input is cleared.
          else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
