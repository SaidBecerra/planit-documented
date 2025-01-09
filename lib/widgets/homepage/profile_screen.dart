import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/registration/welcome_screen.dart';
import 'package:planit/widgets/title_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> fetchUserData() async {
    if (currentUser == null) {
      return null;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  Widget _buildDislikesSection(String title, List<dynamic> dislikes) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          if (dislikes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No dislikes added yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dislikes.map((dislike) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    dislike,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading profile'));
            }

            final userData = snapshot.data;
            if (userData == null) {
              return const Center(child: Text('No profile data available'));
            }

            return Column(
              children: [
                CircleAvatar(
                  backgroundImage: userData['imageURL'] != null &&
                          userData['imageURL'].isNotEmpty
                      ? NetworkImage(userData['imageURL'])
                      : null,
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  child: userData['imageURL'] == null ||
                          userData['imageURL'].isEmpty
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                TitleText(
                  alignment: TextAlign.center,
                  text: userData['username'] ?? 'No username',
                ),
                NormalText(
                  alignment: TextAlign.center,
                  text: userData['email'] ?? 'No email',
                ),
                const SizedBox(height: 24),
                _buildDislikesSection(
                  'Food Dislikes',
                  userData['foodDislikes'] ?? [],
                ),
                _buildDislikesSection(
                  'Activity Dislikes',
                  userData['activityDislikes'] ?? [],
                ),
                const SizedBox(height: 24),
                MainButton(
                  text: 'Log Out',
                  backgroundColor: const Color(0xFFFF6F6F),
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
            );
          },
        ),
      ),
    );
  }
}