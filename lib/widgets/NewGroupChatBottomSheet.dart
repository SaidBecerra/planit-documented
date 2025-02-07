// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/groupchat/create_groupchat_screen.dart';
import 'package:planit/widgets/groupchat/join_groupchat_screen.dart';

/// A bottom sheet widget that offers options to either create a new group chat
/// or join an existing group chat.
///
/// This widget provides two main actions:
/// - Create a new group chat to facilitate trip planning.
/// - Join a group chat to engage with the community.
///
/// The bottom sheet includes a cancel button that dismisses the sheet.
///
/// **Features:**
/// - Option to create a new group chat.
/// - Option to join an existing group chat.
class NewGroupChatBottomSheet extends StatelessWidget {
  // Creates a [NewGroupChatBottomSheet] widget.
  const NewGroupChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Option to create a new group chat
          _buildOption(
            icon: Icons.chat_bubble_outline,
            title: 'New GroupChat',
            subtitle: 'Add a groupchat to be able to create trips',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CreateGroupchatScreen()));
            },
          ),
          // Option to join an existing group chat
          _buildOption(
            icon: Icons.group_outlined,
            title: 'Join GroupChat',
            subtitle: 'Join the community around you',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const JoinGroupchatScreen()));
            },
          ),
          const SizedBox(height: 8),
          // Cancel button to dismiss the bottom sheet
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Helper method to build the options (Create GroupChat, Join GroupChat).
  ///
  // [icon] - The icon to be displayed for the option.
  // [title] - The main title text for the option.
  // [subtitle] - A short description for the option.
  // [onTap] - The callback function to be executed when the option is tapped.
  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
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
