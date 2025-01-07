import 'package:flutter/material.dart';
import 'package:planit/widgets/login/login_screen.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const RegistrationScreen()));
  }

void _onLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/welcome-page.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const TitleText(text: 'Let\'s Get Started!'),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                    width: 350,
                    child: NormalText(
                      alignment: TextAlign.center,
                      text:
                          'Create a PlanIt account or login if you already have an account',
                    )),
                const SizedBox(height: 40),
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
                const SizedBox(height: 20),
                const NormalText(
                  text: 'Or',
                  alignment: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
