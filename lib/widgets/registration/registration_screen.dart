import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/login/login_screen.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/confirmation_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/text_input.dart';
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
  final _phoneNumberController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String? _verficationID;

  var _enteredEmail = '';
  var _enteredName = '';
  var _enteredPassword = '';
  var _enteredPhoneNumber = '';
  
  void _sendCodeToPhoneNumber() async{
    if (_form.currentState!.validate()){
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _enteredPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){

        },
        verificationFailed: (FirebaseAuthException e){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}'))
          );
        },
        codeSent: (String verficationID, int? resendToken) {
          _verficationID = verficationID;
        },
        codeAutoRetrievalTimeout: (String verficationID){
          _verficationID = verficationID;
        }
      );
    }
  }

  void _onPhoneVerification(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                ConfirmationScreen(phoneNumber: _phoneNumberController.text)));
  }

  void _onLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  } 

  String? nameValidator(String? value){
    if (value == null || value.trim().isEmpty){
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
  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
    return 'Please enter a valid email address';
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

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

void _register() async {
  final isValid = _form.currentState!.validate();

  if (!isValid){
    return;
  }
  _form.currentState!.save();
  try {
    final UserCredential = await _firebase.createUserWithEmailAndPassword(
      email: _enteredEmail,
      password: _enteredPassword
    );
  } on FirebaseAuthException catch(error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Authentication failed')));
  }
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
                const LabelText(text: 'Full Name'),
                const SizedBox(
                  height: 5,
                ),
                TextInput(
                  hintText: 'Ex: Rosa Parks',
                  textInputType: TextInputType.name,
                  validator: nameValidator,
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const LabelText(text: 'Email'),
                const SizedBox(
                  height: 5,
                ),
                TextInput(
                  hintText: 'Ex: rosaparks@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  validator: emailValidator,
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const LabelText(text: 'Phone Number'),
                const SizedBox(
                  height: 5,
                ),
                TextInput(
                    controller: _phoneNumberController,
                    textInputType: TextInputType.phone,
                    hintText: 'Ex: 5147714587',
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
                  height: 15,
                ),
                const SizedBox(
                  height: 5,
                ),
                PasswordField(
                  validator: passwordValidator,
                  onSaved: (value){
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
                      onTap: () {
                        _sendCodeToPhoneNumber;
                        _register;
                        _onPhoneVerification(context);
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
