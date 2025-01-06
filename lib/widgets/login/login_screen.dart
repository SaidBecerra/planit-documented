import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/registration/registration_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/terms_text.dart';
import 'package:planit/widgets/text_input.dart';
import 'package:planit/widgets/title_text.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  void _onRegister(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: 'Let\'s log into your account!'),
            SizedBox(
              height: 6,
            ),
            NormalText(
              text: 'Log into your account by filling in the data below',
              alignment: TextAlign.start,
            ),
            SizedBox(
              height: 30,
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
                  text: 'Log in',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: () {
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
                text: 'Or log in with',
                alignment: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            MainButton(
              text: 'Log in with Google',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              image: Image.asset(
                'assets/images/google.png',
                width: 20,
              ),
              onTap: () {},
            ),
            Spacer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Center(
                  child: SizedBox(
                    child: TermsText(),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}