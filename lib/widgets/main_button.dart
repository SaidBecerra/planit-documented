import 'package:flutter/material.dart';

/// A custom button widget that displays a button with an optional icon and text.
/// 
/// The button's appearance (color, size, etc.) is fully customizable through
/// the provided properties. The button also has an `onTap` callback that triggers
/// when the button is pressed.
///
/// **Features:**
/// - Displays an optional icon alongside the text.
class MainButton extends StatelessWidget {
  // Creates a [MainButton] widget.
  //
  // [text] - The text displayed on the button.
  // [backgroundColor] - The background color of the button.
  // [foregroundColor] - The color of the button's text.
  // [onTap] - A callback function triggered when the button is tapped.
  // [image] - An optional image/icon to display alongside the text.
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
