import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/input_field.dart';

/// A screen for users to join an existing group chat by entering its group chat ID.
class JoinGroupchatScreen extends StatefulWidget {
  const JoinGroupchatScreen({super.key});

  @override
  State<JoinGroupchatScreen> createState() {
    return JoinGroupchatScreenState();
  }
}

class JoinGroupchatScreenState extends State<JoinGroupchatScreen> {
  final _form = GlobalKey<FormState>();
  var _groupchatID = '';

    /// Validates the group chat ID input field.
  String? groupchatNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  /// Handles the logic to join the group chat by updating the Firestore document.
  void _onJoin() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to join a group chat.')),
        );
        return;
      }
      final groupchatDoc =
          FirebaseFirestore.instance.collection('groupchats').doc(_groupchatID);
      final groupchatSnapshot = await groupchatDoc.get();

      if (!groupchatSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Group chat not found. Please check the ID.')),
        );
        return;
      }

      // Add the user to the group chat's members list.
      await groupchatDoc.update({
        'members': FieldValue.arrayUnion([currentUser.uid])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully joined the group chat!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
    }
    _form.currentState!.save();
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
              const TitleText(text: 'Let\'s join a groupchat!'),
              const SizedBox(
                height: 20,
              ),
              const TitleText(
                text: 'Join groupchat by entering it\'s ID',
                alignment: TextAlign.start,
              ),
              const SizedBox(
                height: 30,
              ),
              InputField(
                label: 'Groupchat ID',
                hint: 'Enter here',
                inputType: TextInputType.name,
                validator: groupchatNameValidator,
                onChanged: (value) {
                  setState(() {
                    _groupchatID = value;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MainButton(
                text: 'Join Groupchat',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () {
                  _onJoin();
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
