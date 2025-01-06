import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalText extends StatelessWidget {
  const NormalText({required this.alignment, required this.text, required,super.key});
  
  final String text;
  final TextAlign alignment;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      style: GoogleFonts.lato(
        color: const Color.fromARGB(255, 59, 59, 59),
        fontSize: 20,
      ),
    );  
  }
}
