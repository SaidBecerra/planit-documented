import 'package:flutter/material.dart';
import 'package:planit/widgets/filterchips_list.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/registration/activity_dislike_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';

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

  void _onActivityDislike(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => ActivityDislikeScreen()));
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
              FilterchipsList(selectedChips: foodChips),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
