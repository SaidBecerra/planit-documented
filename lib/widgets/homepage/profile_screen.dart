import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/registration/welcome_screen.dart';
import 'package:planit/widgets/title_text.dart';

/// A screen that displays the user's profile information,
/// including their profile picture, username, email, and their dislikes.
///
/// The screen fetches the user data from Firestore, and displays two sections:
/// one for food dislikes and one for activity dislikes. It also provides a
/// "Log Out" button that signs the user out and navigates back to the welcome screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Retrieve the currently authenticated user.
  final currentUser = FirebaseAuth.instance.currentUser;

  /// Fetches the user data from Firestore for the current user.
  ///
  /// Returns a [Map<String, dynamic>] containing the user data,
  /// or `null` if no user is logged in or an error occurs.
  Future<Map<String, dynamic>?> fetchUserData() async {
    if (currentUser == null) return null;

    try {
      // Get the document for the current user from the 'users' collection.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      // Return the user data if the document exists.
      if (userDoc.exists) return userDoc.data();
    } catch (e) {
      // Clear any existing SnackBars and show an error message.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  /// Builds a section widget for displaying a list of dislikes.
  ///
  // [title] is the title for the section (e.g. "Food Dislikes").
  // [dislikes] is a list of dislikes to display.
  // [icon] is the icon to show next to the title.
  Widget _buildDislikesSection(String title, List<dynamic> dislikes, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Subtle shadow for a raised effect.
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with icon and title.
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // If there are no dislikes, show an informative message.
          if (dislikes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'No dislikes added yet',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          // Otherwise, display the list of dislikes as chips.
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dislikes.map((dislike) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    dislike,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Use a FutureBuilder to fetch and display user data.
      child: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for the data.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If an error occurs, display an error message.
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading profile',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // If no data is available, inform the user.
          final userData = snapshot.data;
          if (userData == null) {
            return const Center(child: Text('No profile data available'));
          }

          // If user data is fetched successfully, build the profile UI.
          return SingleChildScrollView(
            child: Column(
              children: [
                // Top container with profile picture, username, and email.
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          // Display the user's profile image if available.
                          backgroundImage: userData['imageURL'] != null &&
                                  userData['imageURL'].isNotEmpty
                              ? NetworkImage(userData['imageURL'])
                              : null,
                          radius: 60,
                          backgroundColor: Colors.white,
                          // If no image is available, display a default icon.
                          child: userData['imageURL'] == null ||
                                  userData['imageURL'].isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey.shade300,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display the username.
                      TitleText(
                        alignment: TextAlign.center,
                        text: userData['username'] ?? 'No username',
                      ),
                      const SizedBox(height: 4),
                      // Display the email.
                      NormalText(
                        alignment: TextAlign.center,
                        text: userData['email'] ?? 'No email',
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                // Section with the dislikes and logout button.
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Build the Food Dislikes section.
                      _buildDislikesSection(
                        'Food Dislikes',
                        userData['foodDislikes'] ?? [],
                        Icons.restaurant,
                      ),
                      // Build the Activity Dislikes section.
                      _buildDislikesSection(
                        'Activity Dislikes',
                        userData['activityDislikes'] ?? [],
                        Icons.sports_basketball,
                      ),
                      const SizedBox(height: 24),
                      // Log Out button.
                      MainButton(
                        text: 'Log Out',
                        backgroundColor: const Color(0xFFA294F9),
                        foregroundColor: Colors.black,
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
