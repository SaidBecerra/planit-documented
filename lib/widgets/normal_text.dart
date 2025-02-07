import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom text widget for displaying normal text with customizable alignment.
///
/// This widget uses the `Lato` font from Google Fonts to display text with a custom color and size.
// The alignment of the text can be adjusted via the [alignment] property.
///
/// **Features:**
/// - Customizable text alignment.
class NormalText extends StatelessWidget {
  /// Creates a [NormalText] widget.
  ///
  // * [text] is the text to be displayed.
  // * [alignment] is the text alignment (e.g., [TextAlign.start], [TextAlign.center]).
  const NormalText({required this.alignment, required this.text, super.key});
  
  /// The text to be displayed.
  final String text;
  
  // The alignment for the text (e.g., [TextAlign.left], [TextAlign.center]).
  final TextAlign alignment;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,  // The actual text content.
      textAlign: alignment,  // Aligns the text based on the specified alignment.
      style: GoogleFonts.lato(  // Uses the Lato font style.
        color: const Color.fromARGB(255, 59, 59, 59),  // Dark gray color for text.
        fontSize: 20,  // Font size set to 20.
      ),
    );  
  }
}
