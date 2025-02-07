import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/invite_code_screen.dart';
import 'package:planit/widgets/groupchat_image_picker.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A screen that allows users to create a new group chat.
///
/// Users can enter a group chat name and select an image for the group chat.
/// Once the form is validated and the image is selected, the image is uploaded
/// to Firebase Storage and a new group chat is created in Firestore.
/// After successfully creating the group chat, the user is navigated to the
/// InviteCodeScreen with the new group chat's ID.
class CreateGroupchatScreen extends StatefulWidget {
  const CreateGroupchatScreen({super.key});

  @override
  State<CreateGroupchatScreen> createState() {
    return CreateGroupchatScreenState();
  }
}

class CreateGroupchatScreenState extends State<CreateGroupchatScreen> {
  // Global key to identify and validate the form.
  final _form = GlobalKey<FormState>();

  // Variable to store the selected image file for the group chat picture.
  File? _selectedImage;

  // Variable to store the entered group chat name.
  var _groupchatName = '';

  /// Creates a new group chat.
  ///
  /// Validates the form and checks if an image has been selected.
  /// If valid, uploads the selected image to Firebase Storage, retrieves the image URL,
  /// creates a new group chat document in Firestore with the provided name, image URL,
  /// and the current user's UID as the creator and first member.
  // Finally, navigates to the [InviteCodeScreen] with the newly created group chat's ID.
  void _createGroupchat() async {
    // Validate the form fields.
    final isValid = _form.currentState!.validate();

    // If form is not valid or no image has been selected, do not proceed.
    if (!isValid || _selectedImage == null) {
      return;
    }
    try {
      // Get the current authenticated user.
      final currentUser = FirebaseAuth.instance.currentUser!;
      
      // Create a reference for the group chat image in Firebase Storage.
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('groupchat_images')
          .child('${DateTime.now().toIso8601String()}.jpg');

      // Upload the selected image file to Firebase Storage.
      await storageRef.putFile(_selectedImage!);
      
      // Get the download URL of the uploaded image.
      final imageUrl = await storageRef.getDownloadURL();
      
      // Add a new document to the 'groupchats' collection in Firestore.
      final groupchatRef = await FirebaseFirestore.instance
          .collection('groupchats')
          .add({
        'name': _groupchatName,            // Name of the group chat.
        'imageUrl': imageUrl,              // URL of the group chat image.
        'createdAt': Timestamp.now(),      // Timestamp when the group chat was created.
        'createdBy': currentUser.uid,      // UID of the user who created the group chat.
        'members': [currentUser.uid],      // Initial list of members (only the creator).
        'trips': [],                       // Empty list for trips (to be filled later).
      });

      // Retrieve the generated group chat ID.
      final groupchatID = groupchatRef.id;

      // If the widget is still mounted, navigate to the InviteCodeScreen with the groupchatID.
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => InviteCodeScreen(groupchatID: groupchatID),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      // If there is an error during the process, clear existing SnackBars and show an error message.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
    // Save the form state.
    _form.currentState!.save();
  }

  /// Validator for the group chat name.
  ///
  /// Ensures the name is not empty and does not exceed 25 characters.
  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    if (value.length > 25) {
      return 'Name must be below 25 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      // Using a custom scaffold layout for consistent UI design.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form, // Assign the global key to the form.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main title for the screen.
                const TitleText(text: 'Let\'s create a groupchat!'),
                const SizedBox(height: 20),
                // Secondary title/instruction.
                const TitleText(
                  text: 'Create your groupchat by filling in the necessary data below',
                  alignment: TextAlign.start,
                ),
                const SizedBox(height: 30),
                // Input field for the group chat name.
                InputField(
                  label: 'Name',
                  hint: 'Ex: The Planners',
                  inputType: TextInputType.name,
                  validator: nameValidator,
                  onChanged: (value) {
                    setState(() {
                      _groupchatName = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // Label prompting the user to choose a group chat picture.
                const LabelText(text: 'Chose groupchat picture'),
                const SizedBox(height: 30),
                // Groupchat image picker widget.
                Center(
                  child: GroupchatImagePicker(
                    onPickedImage: (pickedImage) {
                      _selectedImage = pickedImage;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Button to trigger the group chat creation process.
                MainButton(
                  text: 'Create Groupchat',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: () {
                    _createGroupchat();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
