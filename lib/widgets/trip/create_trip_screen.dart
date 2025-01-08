import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/trip/blueprint_screen.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  void _onBluePrint(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const BluePrintScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: 'Let\'s create your trip!'),
            const SizedBox(
              height: 6,
            ),
            const NormalText(
              text: 'Create your trip by filling in the necessary data below',
              alignment: TextAlign.start,
            ),
            const SizedBox(
              height: 30,
            ),
            InputField(
              label: 'Name',
              hint: 'Ex: Friday Night Trip',
              inputType: TextInputType.name,
            ),
            const SizedBox(
              height: 30,
            ),
            MainButton(
              text: 'Start Creation',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onTap: () => _onBluePrint(context),
            ),
          ],
        ),
      ),
    ));
  }
}
