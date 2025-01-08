import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/groupchat/groupchat_screen.dart';

class GroupChat extends StatelessWidget {
  const GroupChat({required this.name, required this.tripCount, super.key});

  final String name;
  final int tripCount;

  @override
  Widget build(BuildContext context) {

    void onGroupChat(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const GroupchatScreen()));
  } 

    return GestureDetector(
      onTap: () => onGroupChat(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 35,
              backgroundImage: AssetImage('assets/icons/yoda.jpg'),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '2 days ago',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: const Color(0xff646d6d),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Trips created: $tripCount',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
