import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/groupchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The HomeScreen displays the list of group chats that the current user is a member of.
/// 
// It listens to real-time updates from Firestore using a [StreamBuilder] and shows a list
// of [GroupChat] widgets. If no group chats are found, an appropriate message is shown.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current authenticated user from FirebaseAuth.
    final currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        // Expanded widget to fill available vertical space.
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            // Create a stream that listens to the 'groupchats' collection in Firestore,
            // filtering for documents where the 'members' array contains the current user's uid.
            stream: FirebaseFirestore.instance
                .collection('groupchats')
                .where('members', arrayContains: currentUser?.uid)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Show a loading indicator while the data is being fetched.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // If an error occurs while fetching data, display an error message.
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              // If no data is returned or there are no documents, show a message.
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No groupchats found. Create one to get started!'),
                );
              }

              // Retrieve the list of documents (group chats) from the snapshot.
              final docs = snapshot.data!.docs;

              return Scrollbar(
                // Configure scrollbar appearance.
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    // Map each document to a GroupChat widget.
                    children: docs.map((doc) {
                      // Convert document data to a Map<String, dynamic>.
                      final data = doc.data() as Map<String, dynamic>;
                      return GroupChat(
                        // Pass the current user inside a list to the GroupChat widget.
                        users: [currentUser],
                        // Display the group chat name.
                        name: data['name'] as String,
                        // Calculate the number of trips, defaulting to 0 if null.
                        tripCount: (data['trips'] as List?)?.length ?? 0,
                        // Provide the image URL for the group chat.
                        imageUrl: data['imageUrl'] as String,
                        // Pass the document id as the group chat ID.
                        groupchatID: doc.id,
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
