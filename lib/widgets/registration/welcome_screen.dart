import 'package:flutter/material.dart';
import 'package:planit/widgets/login/login_screen.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';

/// A welcome screen that introduces the app and offers options to register or login.
///
/// This screen displays a welcome image along with some text and buttons. Users can:
/// - Register with Email (or via Google, which currently navigates to the registration screen).
/// - Navigate to the login screen if they already have an account.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  /// Navigates to the RegistrationScreen.
  void _onRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const RegistrationScreen()),
    );
  }

  /// Navigates to the LoginScreen.
  void _onLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a custom background color.
      backgroundColor: const Color(0xFFF5EFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display a welcome image inside a container with rounded corners.
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
                const SizedBox(height: 40),
                // Display the title text.
                const TitleText(text: 'Let\'s Get Started!'),
                const SizedBox(height: 10),
                // Display informational text with a fixed width.
                const SizedBox(
                  width: 350,
                  child: NormalText(
                    alignment: TextAlign.center,
                    text: 'Create a PlanIt account or login if you already have an account',
                  ),
                ),
                const SizedBox(height: 40),
                // Button to register with email.
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
                // A text divider.
                const NormalText(
                  text: 'Or',
                  alignment: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Button to continue with Google.
                MainButton(
                  text: 'Continue with Google',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  image: Image.asset(
                    'assets/images/google.png',
                    width: 20,
                  ),
                  onTap: () {
                    // Currently also navigates to registration.
                    _onRegister(context);
                  },
                ),
                const SizedBox(height: 20),
                // Row with text and a button to navigate to the login screen.
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
