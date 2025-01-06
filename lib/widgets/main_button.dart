import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
      required this.text,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.onTap,
      this.image,
      super.key});

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final Image? image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: image,
        label: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: foregroundColor,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
