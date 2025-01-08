import 'dart:io';
import 'package:flutter/material.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePicker extends StatefulWidget {
  const ProfilePicturePicker({required this.onPickedImage, super.key});
  final void Function(File pickedImage) onPickedImage;
  @override
  State<ProfilePicturePicker> createState() {
    return _ProfilePicturePickerState();
  }
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
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
            backgroundColor: const Color.fromARGB(255, 202, 108, 220),

            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton.icon(
              onPressed: _pickImage,
              label: const NormalText(
                  alignment: TextAlign.start, text: 'Add Image'))
        ],
      ),
    );
  }
}
