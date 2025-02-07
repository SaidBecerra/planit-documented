import 'package:flutter/material.dart';
import 'package:planit/widgets/styled_filterchip.dart';

/// A widget that displays a list of filter chips with selectable states.
///
/// **Features:**
/// - Displays a list of `StyledFilterChip` widgets in a scrollable view.
/// - Allows the user to select or deselect filter chips, updating the state accordingly.
/// - Uses a `Map` of selected chips, where the key is the chip label and the value is a boolean indicating whether it's selected.
class FilterchipsList extends StatefulWidget {
  // Creates a [FilterchipsList] widget.
  ///
  // [selectedChips] - A map of selected chips, where the key is the chip label
  /// and the value is a boolean indicating whether the chip is selected.
  const FilterchipsList({required this.selectedChips, super.key});

  final Map selectedChips;

  @override
  State<FilterchipsList> createState() {
    return _FilterchipsListState();
  }
}

class _FilterchipsListState extends State<FilterchipsList> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,  // Show scrollbar thumb
      thickness: 6,           // Thickness of the scrollbar thumb
      radius: const Radius.circular(10),  // Rounded corners for the scrollbar
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 10),  // Padding to avoid clipping the scrollable area
        child: Wrap(
          spacing: 10,  // Space between chips horizontally
          runSpacing: 10,  // Space between chips vertically
          children: widget.selectedChips.entries.map((entry) {
            // Map each chip entry to a StyledFilterChip
            return StyledFilterChip(
                label: entry.key,  // Chip label
                selected: entry.value,  // Selected state of the chip
                onSelected: (bool value) {
                  setState(() {
                    // Update the selected state of the chip when toggled
                    widget.selectedChips[entry.key] = value;
                  });
                });
          }).toList(),
        ),
      ),
    );
  }
}
