import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';


/// A screen that displays a group chat ID and allows the user to copy it or navigate back to the main screen.
class InviteCodeScreen extends StatefulWidget {
  /// The unique group chat ID to be displayed and shared.
  final String groupchatID;
  // Creates an [InviteCodeScreen] with the given [groupchatID].
  const InviteCodeScreen({required this.groupchatID, super.key});

  @override
  State<InviteCodeScreen> createState() => InviteCodeScreenState();
}

class InviteCodeScreenState extends State<InviteCodeScreen> {
  /// Text for the copy button. Initially set to 'Copy', but changes to 'Copied' after the groupchatID is copied.
  String _copyButtonText = 'Copy';

  /// Copies the group chat ID to the clipboard and updates the button text to 'Copied'.
  void _copy() {
    final value = ClipboardData(text: widget.groupchatID);
    Clipboard.setData(value);
    setState(() {
      _copyButtonText = 'Copied';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),  // Adds flexible spacing before the content to center it vertically.
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Displays a title message
                  const TitleText(
                    text: 'Here is your groupchat ID to send to your friends!',
                  ),
                  const SizedBox(height: 30),
                  // Displays the group chat ID in a styled container with selectable text
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
                      style: GoogleFonts.lato(fontSize: 29, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Copy button to copy the group chat ID
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: MainButton(
                      text: _copyButtonText,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onTap: _copy,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Adds flexible spacing after the content.
             // 'Done' button to navigate back to the main screen.
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: MainButton(
                text: 'Done',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () {
                  // Navigates to the CustomNavigationBar screen and removes all previous routes from the stack.
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
          ],
        ),
      ),
    );
  }
}