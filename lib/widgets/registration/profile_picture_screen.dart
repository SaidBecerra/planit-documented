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

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  final _form = GlobalKey<FormState>();
  File? _selectedImage;
  var _username = '';

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
      _selectedImage = File(pickedImage.path);
    });
  }

  String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length > 25) {
      return 'Username must be below 25 characters';
    }
    return null;
  }

  void _onContinue() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!_form.currentState!.validate() || _selectedImage == null) {
      return;
    }

    if (_form.currentState!.validate() && currentUser != null) {
      _form.currentState!.save();
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${currentUser.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'username': _username, 'imageURL': imageUrl});
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => FoodDislikesScreen()));
        }
      } on FirebaseAuthException catch (firestoreError) {
        if (mounted) {
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(
            // Changed from SingleChildScrollView to Column
            children: [
              Expanded(
                // Wrap the scrollable content in Expanded
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Purple container with only the circle avatar
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
                              foregroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MainButton(
                        text: 'Add Image',
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        onTap: _pickImage,
                      ),
                      const SizedBox(height: 30),
                      // Username TextField
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
              const SizedBox(
                  height: 20), // Add spacing above the continue button
              // Continue Button
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
