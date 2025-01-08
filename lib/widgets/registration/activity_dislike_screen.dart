import 'package:flutter/material.dart';
import 'package:planit/widgets/homepage/home_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityDislikeScreen extends StatelessWidget {
  ActivityDislikeScreen({super.key});

void _onHome(BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    final selectedDislikes = activityChips.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'activityDislikes': selectedDislikes,
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save activity dislikes: $e')),
      );
    }
  }
}

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
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 250,
                child: TitleText(
                  text: 'What are your activity dislikes?',
                  alignment: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              FilterchipsList(selectedChips: activityChips),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MainButton(
                    text: 'Next',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: () {
                      _onHome(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
