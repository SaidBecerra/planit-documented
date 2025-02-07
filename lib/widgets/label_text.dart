import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom widget to display a label with bold text style.
/// 
/// This widget is used to display a label with a predefined style that uses
/// the "Lato" font, with a bold weight and a fixed font size.
///
/// **Features:**
/// - The text is bold with a weight of `FontWeight.w700`.
/// - The font size is set to `18` for readability.
class LabelText extends StatelessWidget {
  // Creates a [LabelText] widget.
  ///
  // [text] - The label text to be displayed.
  const LabelText({required this.text, super.key});
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontWeight: FontWeight.w700, // Bold weight
        fontSize: 18, // Font size of 18
      ),
    );
  }
}
