// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication instance used for signing in users.
final _firebase = FirebaseAuth.instance;

/// A screen that allows existing users to log in to their account.
///
/// The screen provides input fields for email and password, and buttons
/// to log in, navigate to registration, or sign in using Google.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables to store the user's entered email and password.
  var _enteredEmail = '';
  var _enteredPassword = '';

  // A GlobalKey to uniquely identify the form and enable form validation.
  final _form = GlobalKey<FormState>();

  /// Navigates to the RegistrationScreen when the user opts to register.
  void _onRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const RegistrationScreen()),
    );
  }

  /// Navigates to the home screen by replacing the current navigation stack.
  void _onHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CustomNavigatonBar(),
      ),
      (route) => false,
    );
  }

  /// Validates the email input field.
  ///
  /// Returns an error message if the email is empty or doesn't match a valid format.
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

  /// Validates the password input field.
  ///
  /// Returns an error message if the password is empty or less than 6 characters.
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Attempts to log in the user using Firebase Authentication.
  ///
  /// Validates the form, saves the input values, and signs in with the provided credentials.
  /// On success, navigates to the home screen; on failure, displays an error message.
  void login() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      // ignore: unused_local_variable
      final userCredential = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      _onHome(context);
    } on FirebaseAuthException catch (error) {
      // Clear any existing SnackBars before showing a new error message.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      // Custom scaffold layout for consistent app design.
      body: SingleChildScrollView(
        // Allows the content to be scrollable, especially on smaller screens.
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text for the login screen.
                const TitleText(text: 'Let\'s log into your account!'),
                const SizedBox(
                  height: 6,
                ),
                // Instructional text for the user.
                const NormalText(
                  text: 'Log into your account by filling in the data below',
                  alignment: TextAlign.start,
                ),
                const SizedBox(
                  height: 30,
                ),
                // Email input field.
                InputField(
                  validator: emailValidator,
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
                // Label for the password field.
                const LabelText(text: 'Password'),
                const SizedBox(
                  height: 5,
                ),
                // Password input field.
                PasswordField(
                  validator: passwordValidator,
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                // Login button.
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: MainButton(
                    text: 'Log in',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: login,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Row with a prompt to register for users who don't have an account.
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
                // Text indicating an alternative login method.
                const Center(
                  child: NormalText(
                    text: 'Or log in with',
                    alignment: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                // Button for logging in with Google (currently no action defined).
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
                // Display the terms and conditions text.
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
