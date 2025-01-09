import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/invite_code_screen.dart';
import 'package:planit/widgets/groupchat/view_members.dart';
import 'package:planit/widgets/groupchat_image_picker.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateGroupchatScreen extends StatefulWidget{
    const CreateGroupchatScreen({super.key});
    @override
  State<CreateGroupchatScreen> createState() {
    return CreateGroupchatScreenState();
  }
}

class CreateGroupchatScreenState extends State<CreateGroupchatScreen> {
  final _form = GlobalKey<FormState>();
  
  File? _selectedImage;
  var _groupchatName = '';

  void _createGroupchat() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _selectedImage == null){
      return;
    }
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('groupchat_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      
      final groupchatRef = await FirebaseFirestore.instance.collection('groupchats').add({
        'name': _groupchatName,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'createdBy': currentUser.uid,
        'members': [currentUser.uid],
        'tripCount': 0,
      });

    final groupchatID = groupchatRef.id;

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) =>  InviteCodeScreen(groupchatID: groupchatID,),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
    }
    _form.currentState!.save();
  }

  
  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    if (value.length > 25){
      return 'Name must be below 25 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleText(text: 'Let\'s create a groupchat!'),
              const SizedBox(
                height: 20,
              ),
              const TitleText(
                text: 'Create your groupchat by filling in the necessary data below',
                alignment: TextAlign.start,
              ),
              const SizedBox(
                height: 30,
              ),
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
              const SizedBox(
                height: 30,
              ),
              const LabelText(text: 'Chose groupchat picture'),
              const SizedBox(height: 30,),
              Center(child: GroupchatImagePicker(onPickedImage: (pickedImage) {
                _selectedImage = pickedImage;
              },)),
              const SizedBox(
                height: 30,
              ),
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
    )
    );
  }
}