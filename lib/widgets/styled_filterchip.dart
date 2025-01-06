import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledFilterChip extends StatelessWidget {
  const StyledFilterChip(
      {required this.label,
      required this.selected,
      required this.onSelected,
      super.key});

  final String label;
  final bool selected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: SizedBox(
        width: MediaQuery.of(context).size.width * 0.32,
        height: 46,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Color(0xFFA294F9), // Light blue color when selected
      backgroundColor: Color(0xFF2C2C2C), // Dark gray background
      //checkmarkColor: Colors.transparent,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
