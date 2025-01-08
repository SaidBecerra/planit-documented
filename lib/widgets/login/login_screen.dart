// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/homepage/home_screen.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/text_input.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  var _enteredEmail = '';
  var _enteredPassword = '';
  final _form = GlobalKey<FormState>();

  void _onRegister(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const RegistrationScreen()));
  }

  void _onHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CustomNavigatonBar(),
      ),
      (route) => false,
    );
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

  void login() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      final UserCredential = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(text: 'Let\'s log into your account!'),
                const SizedBox(
                  height: 6,
                ),
                const NormalText(
                  text: 'Log into your account by filling in the data below',
                  alignment: TextAlign.start,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputField(
                  label: 'Email',
                  hint: 'Ex: rosaparks@gmail.com',
                  inputType: TextInputType.emailAddress,
                  onSaved: (value) {
                    _enteredEmail = value!;
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
                      text: 'Log in',
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onTap: () {
                        login;
                        _onHome(context);
                      }),
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
                        text: 'Don\'t have an account?',
                        alignment: TextAlign.center,
                      ),
                      TextButton(
                        child: Text(
                          'Register',
                          style: GoogleFonts.lato(
                            color: const Color(0xFFA294F9),
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          _onRegister(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: NormalText(
                    text: 'Or log in with',
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
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: SizedBox(
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
