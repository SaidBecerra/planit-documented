import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/otp_square.dart';
import 'package:planit/widgets/registration/dislikes_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({required this.phoneNumber, super.key});
  final String phoneNumber;

  void _onContinue(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => DislikesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: 'Input OTP Code'),
            SizedBox(
              height: 10,
            ),
            NormalText(
                alignment: TextAlign.left,
                text:
                    'Please enter the OTP Code that we have sent to + $phoneNumber'),
            SizedBox(
              height: 15,
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  OtpSquare(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  OtpSquare(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  OtpSquare(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  OtpSquare(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  OtpSquare(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NormalText(
                    text: 'Using a different Phone Number?',
                    alignment: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Change',
                      style: GoogleFonts.lato(
                        color: Color(0xFFA294F9),
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            MainButton(
                text: 'Continue',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () {
                  _onContinue(context);
                }),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MainButton(
                  text: 'Resent Code',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
