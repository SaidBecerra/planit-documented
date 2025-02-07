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

/// The FirebaseAuth instance for authentication operations.
final _firebase = FirebaseAuth.instance;

/// A registration screen that allows new users to create an account.
/// 
/// This screen collects user details such as full name, email, phone number, 
/// and password. After form validation, it registers the user using Firebase 
/// Authentication, saves additional user data to Firestore, uploads a default 
/// image to Firebase Storage if necessary, creates a default group chat, and 
/// finally navigates to the confirmation screen.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Global key to identify the form and validate it.
  final _form = GlobalKey<FormState>();
  // Controller for the phone number input field.
  final _phoneNumberController = TextEditingController();

  // Variables to store the user-entered data.
  var _enteredEmail = '';
  var _enteredName = '';
  var _enteredPassword = '';
  var _enteredPhoneNumber = '';

  /// Registers a new user.
  /// 
  /// This method validates the form, saves the entered data, creates a new user 
  /// with Firebase Authentication, and then saves additional user data to Firestore.
  /// It also uploads a default image to Firebase Storage for the user's group chat.
  /// Finally, it navigates to the ConfirmationScreen, passing the entered phone number.
  void _registerUser() async {
    if (_form.currentState!.validate()) {
      // Save all form fields.
      _form.currentState!.save();

      try {
        // Create a new user with email and password.
        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        try {
          // Save additional user details in Firestore.
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _enteredName,
            'email': _enteredEmail,
            'phoneNumber': _enteredPhoneNumber,
            'foodDislikes': [],
            'activityDislikes': [],
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Reference to the default group image in Firebase Storage.
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('default_images')
              .child('default_group.jpg');

          String defaultImageUrl;
          try {
            // Attempt to get the download URL for the default image.
            defaultImageUrl = await storageRef.getDownloadURL();
          } catch (error) {
            // If the image does not exist, load a local default image asset.
            final byteData = await rootBundle.load('assets/icons/yoda.jpg');
            final Uint8List fileData = byteData.buffer.asUint8List();

            // Upload the local default image to Firebase Storage.
            await storageRef.putData(fileData);
            defaultImageUrl = await storageRef.getDownloadURL();
          }

          // Create a new group chat for the user.
          await FirebaseFirestore.instance.collection('groupchats').add({
            'name': _enteredName,
            'imageUrl': defaultImageUrl,
            'createdAt': Timestamp.now(),
            'createdBy': userCredential.user!.uid,
            'members': [userCredential.user!.uid],
            'trips': [],
          });
        } on FirebaseAuthException catch (firestoreError) {
          // If saving user data fails, show an error and delete the user.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving user data: $firestoreError')),
          );
          await userCredential.user?.delete();
          return;
        }

        // Navigate to the ConfirmationScreen, passing the phone number.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) =>
                ConfirmationScreen(phoneNumber: _enteredPhoneNumber),
          ),
        );
      } on FirebaseAuthException catch (error) {
        // If user registration fails, display the error message.
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')),
        );
      }
    }
  }

  /// Navigates to the LoginScreen.
  void _onLogin(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (ctx) => const LoginScreen())
    );
  }

  /// Validates the user's full name.
  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter a valid name (letters and spaces only)';
    }
    return null;
  }

  /// Validates the user's email address.
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

  /// Validates the user's password.
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validates the user's phone number.
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
    // Dispose the phone number controller when the widget is removed.
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      // Using a custom ScaffoldLayout for consistent design.
      body: SingleChildScrollView(
        // Allows the content to be scrollable if the keyboard covers fields.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form, // Key to identify and validate the form.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text for the registration screen.
                const TitleText(text: 'Let\'s create a new account'),
                const SizedBox(
                  height: 6,
                ),
                // Informative text for the user.
                const NormalText(
                  text: 'Create an account by filling in the data below',
                  alignment: TextAlign.start,
                ),
                const SizedBox(
                  height: 30,
                ),
                // Input field for the user's full name.
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
                // Input field for the user's email.
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
                // Input field for the user's phone number.
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
                // Label for the password field.
                const LabelText(text: 'Password'),
                const SizedBox(
                  height: 5,
                ),
                // Input field for the password.
                PasswordField(
                  validator: passwordValidator,
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                // Main button to register the user.
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
                // Section for existing users to navigate to the login screen.
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
                // A prompt to sign up with alternative methods.
                const Center(
                  child: NormalText(
                    text: 'Or sign up with',
                    alignment: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                // Button to sign up with Google.
                MainButton(
                  text: 'Continue with Google',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  image: Image.asset(
                    'assets/images/google.png',
                    width: 20,
                  ),
                  onTap: () {}, // Google sign-up functionality can be added here.
                ),
                const SizedBox(
                  height: 40,
                ),
                // Terms and conditions text.
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
