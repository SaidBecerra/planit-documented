import 'package:flutter/material.dart';

class TimeSlot extends StatelessWidget {
  final String text;
  final String time;
  final IconData? icon;
  final Color? color;

  const TimeSlot({
    super.key,
    required this.text,
    required this.time,
    this.icon,
    this.color = const Color(0xFFF0F1FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? const Color(0xFFF0F1FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color?.withOpacity(0.3) ?? Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
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
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: color ?? Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
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