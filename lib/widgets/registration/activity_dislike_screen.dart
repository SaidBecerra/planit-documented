import 'package:flutter/material.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityDislikeScreen extends StatelessWidget {
  ActivityDislikeScreen({super.key});

  /// Method to save selected dislikes to Firestore and navigate to home screen.
  void _onHome(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;  // Get the current authenticated user

    if (currentUser != null) {
      // Filter the selected dislikes based on the value of activityChips
      final selectedDislikes = activityChips.entries
          .where((entry) => entry.value)  // Where the value is true (indicating dislike)
          .map((entry) => entry.key)  // Get the key (activity name)
          .toList();  // Convert to a list of disliked activities

      try {
        // Update Firestore with the selected dislikes for the current user
        await FirebaseFirestore.instance
            .collection('users')  // Reference to the 'users' collection
            .doc(currentUser.uid)  // Document for the current user
            .update({
          'activityDislikes': selectedDislikes,  // Set the dislikes field to the selected activities
        });

        // Navigate to the home screen (CustomNavigatonBar) after success
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => const CustomNavigatonBar(),
          ),
          (route) => false,  // Remove all routes from the navigation stack
        );
      } catch (e) {
        // Show an error message if the Firestore update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save activity dislikes: $e')),
        );
      }
    }
  }

  // A map of activity names and their dislike status (initially false)
  final Map<String, bool> activityChips = {
    'Hiking': false,
    'Swimming': false,
    'Cycling': false,
    'Running': false,
    'Yoga': false,
    'Photography': false,
    'Painting': false,
    'Reading': false,
    'Gaming': false,
    'Cooking': false,
    'Gardening': false,
    'Dancing': false,
    'Meditation': false,
    'Surfing': false,
    'Rock Climbing': false,
    'Tennis': false,
    'Basketball': false,
    'Camping': false,
    'Traveling': false,
    'Music': false,
    'Writing': false,
  };

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.all(20),  // Padding for the screen layout
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 250,
                child: TitleText(
                  text: 'What are your activity dislikes?',  // Title text for the screen
                  alignment: TextAlign.center,  // Center alignment
                ),
              ),
              const SizedBox(
                height: 40,  // Space between title and filter chips
              ),
              Expanded(child: FilterchipsList(selectedChips: activityChips)),  // Display the activity filter chips
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,  // Padding at the bottom of the button
                  top: 20,     // Padding at the top of the button
                ),
                child: MainButton(
                    text: 'Next',  // Button text
                    backgroundColor: Colors.black,  // Background color
                    foregroundColor: Colors.white,  // Foreground color (text color)
                    onTap: () {
                      _onHome(context);  // Navigate to the next screen and save data
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
