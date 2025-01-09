import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/login/login_screen.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/confirmation_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _form = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  var _enteredEmail = '';
  var _enteredName = '';
  var _enteredPassword = '';
  var _enteredPhoneNumber = '';

  void _registerUser() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      try {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _enteredName,
            'email': _enteredEmail,
            'phoneNumber': _enteredPhoneNumber,
            'foodDislikes': {},
            'activityDislikes': {},
            'createdAt': FieldValue.serverTimestamp(),
          });

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('default_images')
              .child('default_group.jpg');

          String defaultImageUrl;
          try {
            defaultImageUrl = await storageRef.getDownloadURL();
          } catch (error) {
            final byteData = await rootBundle.load('assets/icons/yoda.jpg');
            final Uint8List fileData = byteData.buffer.asUint8List();

            await storageRef.putData(fileData);
            defaultImageUrl = await storageRef.getDownloadURL();
          }

          await FirebaseFirestore.instance.collection('groupchats').add({
            'name': _enteredName,
            'imageUrl': defaultImageUrl,
            'createdAt': Timestamp.now(),
            'createdBy': userCredential.user!.uid,
            'members': [userCredential.user!.uid],
            'trips': [],
          });
        } on FirebaseAuthException catch (firestoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving user data: $firestoreError')),
          );
          await userCredential.user?.delete();
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) =>
                ConfirmationScreen(phoneNumber: _enteredPhoneNumber),
          ),
        );
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')),
        );
      }
    }
  }

  void _onLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  }

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter a valid name (letters and spaces only)';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(text: 'Let\'s create a new account'),
                const SizedBox(
                  height: 6,
                ),
                const NormalText(
                  text: 'Create an account by filling in the data below',
                  alignment: TextAlign.start,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputField(
                  label: 'Full Name',
                  hint: 'Ex: Rosa Parks',
                  inputType: TextInputType.name,
                  validator: nameValidator,
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  label: 'Email',
                  hint: 'Ex: rosaparks@gmail.com',
                  inputType: TextInputType.emailAddress,
                  validator: emailValidator,
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  label: 'Phone Number',
                  hint: 'Ex: 5147714587',
                  inputType: TextInputType.phone,
                  validator: phoneNumberValidator,
                  onSaved: (value) {
                    _enteredPhoneNumber = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const LabelText(text: 'Password'),
                const SizedBox(
                  height: 5,
                ),
                PasswordField(
                  validator: passwordValidator,
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: MainButton(
                    text: 'Register',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: _registerUser,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const NormalText(
                        text: 'Already have an account?',
                        alignment: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          _onLogin(context);
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.lato(
                            color: const Color(0xFFA294F9),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: NormalText(
                    text: 'Or sign up with',
                    alignment: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                MainButton(
                  text: 'Continue with Google',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  image: Image.asset(
                    'assets/images/google.png',
                    width: 20,
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: SizedBox(
                      width: 400,
                      child: TermsText(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
