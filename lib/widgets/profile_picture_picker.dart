import 'dart:io';
import 'package:flutter/material.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that allows the user to pick an image from their gallery and display it as a profile picture.
///
/// This widget displays a large circular avatar that shows the selected image.
/// If no image is selected, it shows an empty avatar with a default background color.
/// A button below the avatar allows the user to open the image picker.
class ProfilePicturePicker extends StatefulWidget {
  /// Creates a [ProfilePicturePicker].
  ///
  // The [onPickedImage] callback is required and will be called with the selected image file.
  const ProfilePicturePicker({
    required this.onPickedImage,
    super.key,
  });

  // Callback function that returns the picked image as a [File].
  final void Function(File pickedImage) onPickedImage;

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  /// The file representing the picked image.
  File? _pickedImageFile;

  /// Opens the image picker to allow the user to select an image from the gallery.
  ///
  /// The picked image is resized to a maximum width of 150 pixels with 50% quality.
  // If an image is selected, it is stored in [_pickedImageFile] and passed to the [onPickedImage] callback.
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;  // User canceled the image picker.
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 160,
            backgroundColor: const Color.fromARGB(255, 202, 108, 220),  // Default background color.
            foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,  // Displays the picked image if available.
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),  // Icon for the button.
            label: const NormalText(
              alignment: TextAlign.start,
              text: 'Add Image',  // Button label.
            ),
          ),
        ],
      ),
    );
  }
}
