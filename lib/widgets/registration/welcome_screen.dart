import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/registration/registration_screen.dart';

import 'package:planit/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TitleText(text: 'Let\'s Get Started!'),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 350,
                  child: NormalText(
                    alignment: TextAlign.center,
                    text:
                        'Create a PlanIt account or login if you already have an account',
                  )),
              SizedBox(height: 40),
              MainButton(
                text: 'Register with Email',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                image: Image.asset(
                  'assets/images/mail.png',
                  width: 20,
                  color: Colors.white,
                ),
                onTap: () {
                  _onRegister(context);
                },
              ),
              SizedBox(height: 20),
              NormalText(
                text: 'Or',
                alignment: TextAlign.center,
              ),
              SizedBox(height: 20),
              MainButton(
                text: 'Continue with Google',
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                image: Image.asset(
                  'assets/images/google.png',
                  width: 20,
                ),
                onTap: () {
                  _onRegister(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NormalText(
                    text: 'Already have an Account?',
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
