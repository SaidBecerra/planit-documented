import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/registration/food_dislikes_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';

/// A screen that allows users to set a profile picture and choose a username.
///
// The user can select an image from the gallery using the [ImagePicker] package.
/// Once an image is selected and a valid username is entered, the image is uploaded
/// to Firebase Storage and the user's Firestore document is updated with the username
// and the image URL. On success, the screen navigates to the [FoodDislikesScreen].
class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  // Global key to access and validate the form.
  final _form = GlobalKey<FormState>();

  // Stores the image file selected by the user.
  File? _selectedImage;

  // Stores the username entered by the user.
  var _username = '';

  /// Opens the gallery for the user to pick an image.
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      // User cancelled image selection.
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  /// Validates the username input.
  ///
  /// Returns an error message if the username is empty or exceeds 25 characters.
  String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length > 25) {
      return 'Username must be below 25 characters';
    }
    return null;
  }

  /// Handles the continue button press.
  ///
  /// Validates the form and ensures an image is selected. If valid, it uploads the
  /// selected image to Firebase Storage, retrieves its download URL, updates the user's
  /// Firestore document with the username and image URL, and navigates to the
  // [FoodDislikesScreen].
  void _onContinue() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check that the form is valid and an image has been selected.
    if (!_form.currentState!.validate() || _selectedImage == null) {
      return;
    }

    if (_form.currentState!.validate() && currentUser != null) {
      // Save the form fields.
      _form.currentState!.save();
      try {
        // Create a reference to the profile picture location in Firebase Storage.
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${currentUser.uid}.jpg');

        // Upload the selected image.
        await storageRef.putFile(_selectedImage!);

        // Retrieve the download URL for the uploaded image.
        final imageUrl = await storageRef.getDownloadURL();

        // Update the user's Firestore document with the username and image URL.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'username': _username, 'imageURL': imageUrl});
        
        if (mounted) {
          // Navigate to the FoodDislikesScreen after a successful update.
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => FoodDislikesScreen()));
        }
      } on FirebaseAuthException catch (firestoreError) {
        if (mounted) {
          // If an error occurs, display a SnackBar with the error message.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving user data: $firestoreError')),
          );
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      // Using a custom scaffold layout for consistent UI styling.
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form, // Assign the form key.
          child: Column(
            // Arrange content in a vertical column.
            children: [
              Expanded(
                // Make the content scrollable within the available space.
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container for the profile picture area with a purple background.
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffE5D9F2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircleAvatar(
                              radius: 160,
                              backgroundColor: const Color(0xffCDC1FF),
                              // Display the selected image if available.
                              foregroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Button to trigger the image picker.
                      MainButton(
                        text: 'Add Image',
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        onTap: _pickImage,
                      ),
                      const SizedBox(height: 30),
                      // Input field for entering the username.
                      InputField(
                        label: 'Enter username',
                        hint: 'Ex: simpol',
                        inputType: TextInputType.name,
                        validator: usernameValidator,
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing above the continue button.
              // Button to continue to the next screen.
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MainButton(
                  text: 'Continue',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: _onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
