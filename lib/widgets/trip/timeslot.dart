// Import the material design package
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// A widget that displays a time slot with text, time, and an optional icon
class TimeSlot extends StatelessWidget {
  // Required and optional parameters for the time slot
  final String text;      // Main text to display
  final String time;      // Time text to display
  final IconData? icon;   // Optional icon to show
  final Color? color;     // Optional color for styling (defaults to light blue)

  // Constructor with required and optional parameters
  const TimeSlot({
    super.key,
    required this.text,
    required this.time,
    this.icon,
    this.color = const Color(0xFFF0F1FF),
  });

  @override
  Widget build(BuildContext context) {
    // Full width container for the time slot
    return SizedBox(
      width: double.infinity,
      child: Container(
        // Spacing and padding
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        // Container styling with rounded corners and border
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? const Color(0xFFF0F1FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color?.withOpacity(0.3) ?? Colors.transparent,
            width: 1,
          ),
        ),
        // Row layout for icon and text content
        child: Row(
          children: [
            // Conditional icon display with container
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color?.withOpacity(0.1) ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),  // Spacing after icon
            ],
            // Expanded column for text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main text with custom styling
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: color ?? Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),  // Spacing between texts
                  // Time text with grey color
                  Text(
                    time,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}