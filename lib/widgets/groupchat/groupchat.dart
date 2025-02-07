import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/groupchat/groupchat_screen.dart';

/// A stateless widget representing a single group chat item.
///
/// This widget displays a group's avatar (using an image URL), its name, and the number
// of trips created in the group chat. When tapped, it navigates to the [GroupchatScreen]
/// for that group chat, using the provided group chat ID.
class GroupChat extends StatelessWidget {
  // Creates a [GroupChat] widget.
  ///
  // [users] is a list of Firebase [User] objects representing the members of the group.
  // [imageUrl] is the URL for the group's avatar image.
  // [name] is the name of the group chat.
  // [tripCount] is the number of trips created in this group chat.
  // [groupchatID] is the unique identifier for the group chat.
  const GroupChat({
    required this.users,
    required this.imageUrl, 
    required this.name,
    required this.tripCount,
    required this.groupchatID,
    super.key,
  });

  // Group chat properties
  final String name;
  final String groupchatID;
  final List<User?> users;
  final int tripCount;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    /// Navigates to the [GroupchatScreen] for this group chat.
    ///
    /// When the group chat item is tapped, this function is called to push the
    /// [GroupchatScreen] onto the navigation stack, passing the group chat ID.
    void onGroupChat(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => GroupchatScreen(groupchatID: groupchatID),
        ),
      );
    }

    return GestureDetector(
      // Detects taps on the group chat item.
      onTap: () => onGroupChat(context),
      child: Padding(
        // Add padding around the entire row.
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circle avatar displaying the group's image.
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 35,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            // Expanded widget to fill available horizontal space.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group chat name displayed in bold.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Display the trip count for the group chat.
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
