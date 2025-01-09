import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/title_text.dart';

class InviteCodeScreen extends StatefulWidget {
  final String groupchatID;
  const InviteCodeScreen({required this.groupchatID, super.key});

  @override
  State<InviteCodeScreen> createState() {
    return InviteCodeScreenState();
  }
}

class InviteCodeScreenState extends State<InviteCodeScreen> {
    String _copyButtonText = 'Copy';  

  @override
  Widget build(BuildContext context) {
    void copy() {
      final value = ClipboardData(text: widget.groupchatID);
      Clipboard.setData(value);
      setState(() {
      _copyButtonText = 'Copied';
    });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TitleText(
                    text: 'Here is your groupchat ID to send to your friends!',
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 35, 34, 34),
                        width: 1.0,
                      ),
                    ),
                    child: SelectableText(
                      widget.groupchatID,
                      style: GoogleFonts.lato(fontSize: 30, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: MainButton(
                      text: _copyButtonText,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onTap: copy,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: MainButton(
                  text: 'Done',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const CustomNavigatonBar(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
