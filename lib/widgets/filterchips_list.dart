import 'package:flutter/material.dart';
import 'package:planit/widgets/styled_filterchip.dart';

class FilterchipsList extends StatefulWidget {
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
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.selectedChips.entries.map((entry) {
              return StyledFilterChip(
                  label: entry.key,
                  selected: entry.value,
                  onSelected: (bool value) {
                    setState(() {
                      widget.selectedChips[entry.key] = value;
                    });
                  });
            }).toList(),
          ),
        ),
      ),
    );
  }
}
