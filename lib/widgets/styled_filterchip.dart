import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A custom-styled [FilterChip] widget with rounded corners and centered text.
///
/// This widget is used to display a selectable chip with a custom design.
/// It supports a label, selection state, and a callback when selected or deselected.
class StyledFilterChip extends StatelessWidget {
  /// Creates a [StyledFilterChip].
  ///
  // * [label]: The text displayed on the chip.
  // * [selected]: A boolean indicating whether the chip is selected.
  // * [onSelected]: A callback function that is triggered when the chip is selected or deselected.
  const StyledFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The text displayed on the chip.
  final String label;

  /// Indicates whether the chip is selected.
  final bool selected;

  /// Callback function triggered when the chip is selected or deselected.
  ///
  /// The function receives a boolean value (`true` if selected, `false` if deselected).
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: SizedBox(
        width: MediaQuery.of(context).size.width * 0.32,  // Sets the chip width to 32% of the screen width.
        height: 46,  // Fixed height for the chip.
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(  // Custom text style using Lato font.
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      selected: selected,  // Determines the chip's selection state.
      onSelected: onSelected,  // Triggers the provided callback on selection.
      selectedColor: const Color(0xFFA294F9),  // Light blue color when the chip is selected.
      backgroundColor: const Color(0xFF2C2C2C),  // Dark gray background when not selected.
      showCheckmark: false,  // Hides the default checkmark.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),  // Applies a circular shape to the chip.
      ),
    );
  }
}
