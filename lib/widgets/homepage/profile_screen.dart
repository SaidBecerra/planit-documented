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
  State<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<String?> fetchProfilePicture() async {
    if (currentUser == null) {
      return null; 
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['imageURL'] as String?;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  Future<String?> fetchProfileUsername() async {
    if (currentUser == null) {
      return null; 
    }
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['username'] as String?;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  Future<String?> fetchProfileEmail() async {
    if (currentUser == null) {
      return null; 
    }
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['email'] as String?;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: fetchProfilePicture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
        
                if (snapshot.hasError) {
                  return const Text('Error fetching profile picture');
                }
        
                final imageUrl = snapshot.data;
        
                if (imageUrl == null || imageUrl.isEmpty) {
                  return const Text('No profile picture available');
                }
        
                return CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 100, 
                );
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: fetchProfileUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
        
                if (snapshot.hasError) {
                  return const Text('Error fetching profile username');
                }
        
                final username = snapshot.data;
        
                if (username == null || username.isEmpty) {
                  return const Text('No username available');
                }
        
                return TitleText(
                  alignment: TextAlign.center,
                  text: username
                );
              },
            ),
            FutureBuilder<String?>(
              future: fetchProfileEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
        
                if (snapshot.hasError) {
                  return const Text('Error fetching profile picture');
                }
        
                final email = snapshot.data;
        
                if (email == null || email.isEmpty) {
                  return const Text('No profile email available');
                }
        
                return NormalText(
                  alignment: TextAlign.center,
                  text: email
                );
              },
            ),
            const Spacer(),
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
            )
          ],
        ),
      ),
    );
  }
}
