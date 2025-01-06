import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({this.alignment, required this.text, super.key});
  
  final String text;
  final TextAlign? alignment;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: alignment,
    );
  }
}
