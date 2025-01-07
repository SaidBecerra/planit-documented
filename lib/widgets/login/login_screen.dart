import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/homepage/dashboard_screen.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/text_input.dart';
import 'package:planit/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  void _onRegister(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const RegistrationScreen()));
  }

  void _onHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const DashboardScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SingleChildScrollView(
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
              const LabelText(text: 'Email'),
              const SizedBox(
                height: 5,
              ),
              const TextInput(
                hintText: 'Ex: rosaparks@gmail.com',
                textInputType: TextInputType.emailAddress,
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
              const PasswordField(),
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
                      onPressed: () {
                        _onRegister(context);
                      },
                      child: Text(
                        'Register',
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
    );
  }
}
