import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/groupchat/groupchat_screen.dart';

class GroupChat extends StatelessWidget {
  const GroupChat(
      {required this.users,
      required this.imageUrl, 
      required this.name,
      required this.tripCount,
      super.key});

  final String name;
  final List<User?> users;
  final int tripCount;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    void onGroupChat(BuildContext context) {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const GroupchatScreen()));
    }

    return GestureDetector(
      onTap: () => onGroupChat(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 35,
              backgroundImage: NetworkImage(imageUrl),
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
