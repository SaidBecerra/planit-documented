import 'package:flutter/material.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';

class ActivityDislikeScreen extends StatelessWidget {
  ActivityDislikeScreen({super.key});

  void _onHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CustomNavigatonBar(),
      ),
      (route) => false,
    );
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
