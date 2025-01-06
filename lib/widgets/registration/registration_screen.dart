import 'package:flutter/material.dart';
import 'package:planit/widgets/label_text.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/password_field.dart';
import 'package:planit/widgets/text_input.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/title_text.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
            LabelText(text: 'Password'),
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
                  onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
