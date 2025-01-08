import 'package:flutter/material.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/registration/activity_dislike_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDislikesScreen extends StatelessWidget {
  FoodDislikesScreen({super.key});

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

  void _onActivityDislike(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final selectedDislikes = foodChips.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'foodDislikes': selectedDislikes,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => ActivityDislikeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save dislikes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 250,
                child: TitleText(
                  text: 'What are your food dislikes?',
                  alignment: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: FilterchipsList(selectedChips: foodChips),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 20,
                ),
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
