import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that displays terms and conditions text with a styled format.
///
// This widget uses [RichText] to combine multiple [TextSpan]s, 
/// allowing for different text styles within a single block of text.
/// 
/// The main purpose of this widget is to inform users about accepting the
/// terms and conditions and privacy policy when proceeding.
class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,  // Aligns the text in the center.
      text: TextSpan(
        style: GoogleFonts.lato(   // Default text style using the Lato font.
          color: Colors.black54,
          fontSize: 18,
        ),
        children: [
          const TextSpan(
            text: 'By proceeding, you agree to the ',  // Regular text.
          ),
          TextSpan(
            text: 'Terms and Conditions',  // Bold text for emphasis.
            style: GoogleFonts.lato(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' and ',  // Regular text.
          ),
          TextSpan(
            text: 'Privacy Policy',  // Bold text for emphasis.
            style: GoogleFonts.lato(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
