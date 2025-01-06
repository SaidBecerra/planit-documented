import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/confirmation_screen.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/text_input.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/title_text.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _phoneNumberController = TextEditingController();

  void _onPhoneVerification(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                ConfirmationScreen(phoneNumber: _phoneNumberController.text)));
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(110, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/left-arrow.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(text: 'Let\'s create a new account'),
              SizedBox(
                height: 6,
              ),
              NormalText(
                text: 'Create an account by filling in the data below',
                alignment: TextAlign.start,
              ),
              SizedBox(
                height: 30,
              ),
              LabelText(text: 'Full Name'),
              SizedBox(
                height: 5,
              ),
              TextInput(
                hintText: 'Ex: Rosa Parks',
                textInputType: TextInputType.name,
              ),
              SizedBox(
                height: 15,
              ),
              LabelText(text: 'Email'),
              SizedBox(
                height: 5,
              ),
              TextInput(
                hintText: 'Ex: rosaparks@gmail.com',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 15,
              ),
              LabelText(text: 'Phone Number'),
              SizedBox(
                height: 5,
              ),
              TextInput(
                  controller: _phoneNumberController,
                  textInputType: TextInputType.phone,
                  hintText: 'Ex: 5147714587'),
              SizedBox(
                height: 15,
              ),
              LabelText(text: 'Password'),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 5,
              ),
              PasswordField(),
              SizedBox(
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
                      _onPhoneVerification(context);
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NormalText(
                      text: 'Already have an account?',
                      alignment: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                          color: Color(0xFFA294F9),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: NormalText(
                  text: 'Or sign up with',
                  alignment: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
    );
  }
}
