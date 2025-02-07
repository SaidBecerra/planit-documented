import 'package:flutter/material.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/registration/activity_dislike_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A screen that allows users to select food types they dislike.
/// 
/// The selected food dislikes are saved to Firebase Firestore under the
/// current user's document. Once the data is saved, the user is navigated
/// to the ActivityDislikeScreen.
class FoodDislikesScreen extends StatelessWidget {
  // Creates a [FoodDislikesScreen] widget.
  FoodDislikesScreen({super.key});

  /// A map of food categories and a boolean value indicating whether the
  /// user dislikes that food type.
  final Map<String, bool> foodChips = {
    'Asian': false,
    'Mexican': false,
    'Italian': false,
    'American': false,
    'Indian': false,
    'Mediterranean': false,
    'French': false,
    'Greek': false,
    'Thai': false,
    'Japanese': false,
    'Chinese': false,
    'Korean': false,
    'Vietnamese': false,
    'Turkish': false,
    'Spanish': false,
    'Middle Eastern': false,
    'Brazilian': false,
    'Caribbean': false,
    'Vegetarian/Vegan': false,
    'Seafood': false,
    'BBQ': false,
  };

  /// Saves the selected food dislikes to Firestore and navigates to the
  /// ActivityDislikeScreen.
  void _onActivityDislike(BuildContext context) async {
    // Retrieve the current authenticated user.
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Filter out the food types where the value is true (disliked)
      final selectedDislikes = foodChips.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      try {
        // Update the 'foodDislikes' field in the user's document in Firestore.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'foodDislikes': selectedDislikes,
        });

        // Navigate to the ActivityDislikeScreen after successful update.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => ActivityDislikeScreen()),
        );
      } catch (e) {
        // If there is an error, display a SnackBar with the error message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save dislikes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      // Use a custom ScaffoldLayout for a consistent app design.
      body: Padding(
        padding: const EdgeInsets.all(20), // Outer padding for the screen.
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title text centered in a fixed width container.
              const SizedBox(
                width: 250,
                child: TitleText(
                  text: 'What are your food dislikes?',
                  alignment: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40, // Spacing between title and filter chips.
              ),
              // The filter chip list displays selectable food options.
              Expanded(
                child: FilterchipsList(selectedChips: foodChips),
              ),
              // Padding around the "Next" button.
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 20,
                ),
                // Custom button that triggers the _onActivityDislike method.
                child: MainButton(
                    text: 'Next',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: () {
                      _onActivityDislike(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
