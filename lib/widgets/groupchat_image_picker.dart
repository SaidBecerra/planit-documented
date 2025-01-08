import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:image_picker/image_picker.dart';

class GroupchatImagePicker extends StatefulWidget {
  const GroupchatImagePicker({required this.onPickedImage, super.key});
  final void Function(File pickedImage) onPickedImage;
  @override
  State<GroupchatImagePicker> createState() {
    return _GroupchatImagePickerState();
  }
}

class _GroupchatImagePickerState extends State<GroupchatImagePicker> {
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
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            label:
                const NormalText(alignment: TextAlign.start, text: 'Add Image'))
      ],
    );
  }
}
