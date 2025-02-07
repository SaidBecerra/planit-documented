import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom widget that displays styled title text using the Lato font.
///
/// This widget is primarily used for displaying title text with a specific style
/// (black color, bold weight, and 30pt font size).
/// 
// The [text] parameter is required, and [alignment] is optional for specifying
/// how the text should be aligned.

class TitleText extends StatelessWidget {
   // Creates a [TitleText] widget.
  ///
  // * [text]: The string to be displayed as the title.
  // * [alignment]: An optional parameter to set the text alignment (\example: left, center).

  const TitleText({this.alignment, required this.text, super.key});
  
  /// The text content to be displayed.
  final String text;
  /// The alignment of the text (example: left, center, or right).
  final TextAlign? alignment;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: Colors.black, // Sets the text color to black.
        fontSize: 30,  // Sets the font size to 30.
        fontWeight: FontWeight.bold,  // Sets the font weight to bold.
      ),
      textAlign: alignment,  // Applies the optional text alignment.
    );
  }
}
