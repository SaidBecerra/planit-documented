import 'dart:io';
import 'package:flutter/material.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that allows users to pick and display an image for a group chat.
///
/// **Features:**
/// - Displays a circular avatar with the selected image (if any).
/// - Allows the user to pick an image from the gallery.
// - Calls the provided [onPickedImage] function with the picked image file.
class GroupchatImagePicker extends StatefulWidget {
  /// Creates a [GroupchatImagePicker] widget.
  ///
  // [onPickedImage] - A callback function to handle the picked image.
  const GroupchatImagePicker({required this.onPickedImage, super.key});
  
  final void Function(File pickedImage) onPickedImage;

  @override
  State<GroupchatImagePicker> createState() {
    return _GroupchatImagePickerState();
  }
}

class _GroupchatImagePickerState extends State<GroupchatImagePicker> {
  File? _pickedImageFile;

  /// Function to pick an image from the gallery and update the UI.
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    // Notify the parent widget with the picked image
    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the circular avatar with the picked image, or a grey placeholder
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        // Button to allow the user to pick an image
        TextButton.icon(
            onPressed: _pickImage,
            label:
                const NormalText(alignment: TextAlign.start, text: 'Add Image'))
      ],
    );
  }
}
