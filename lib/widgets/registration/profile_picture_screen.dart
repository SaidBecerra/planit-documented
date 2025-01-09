import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/profile_picture_picker.dart';
import 'package:planit/widgets/registration/food_dislikes_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() {
    return ProfilePictureScreenState();
  }
}

class ProfilePictureScreenState extends State<ProfilePictureScreen> {
    final _form = GlobalKey<FormState>();
  File? _selectedImage;
  var _username = '';
  
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

      if (!_form.currentState!.validate() || _selectedImage == null){
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
            .update({
          'username': _username,
          'imageURL': imageUrl
        });
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => FoodDislikesScreen()));
      } on FirebaseAuthException catch (firestoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving user data: $firestoreError')),
          );
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
            children: [
              SingleChildScrollView(
                child: Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 214, 255),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: ProfilePicturePicker(
                          onPickedImage: (pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Column(
                    children: [
                      InputField(
                        validator: usernameValidator,
                        onSaved: (value) {
                          _username = value!;
                        },
                        label: 'Enter Username',
                        hint: 'ex: username123',
                        inputType: TextInputType.name,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MainButton(
                          text: 'Continue',
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          onTap: () {
                            _onContinue();
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
