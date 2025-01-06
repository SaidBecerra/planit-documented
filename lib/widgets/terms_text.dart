import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.lato(
          color: Colors.black54,
          fontSize: 18,
        ),
        children: [
          const TextSpan(
            text: 'By proceeding, you agree to the ',
          ),
          TextSpan(
            text: 'Terms and Conditions',
            style: GoogleFonts.lato(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' and ',
          ),
          TextSpan(
            text: 'Privacy Policy',
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