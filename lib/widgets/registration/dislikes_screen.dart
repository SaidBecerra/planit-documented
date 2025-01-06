import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/styled_filterchip.dart';
import 'package:planit/widgets/title_text.dart';

class DislikesScreen extends StatefulWidget {
  const DislikesScreen({super.key});

  @override
  State<DislikesScreen> createState() {
    return _DislikesScreenState();
  }
}

class _DislikesScreenState extends State<DislikesScreen> {
  Map<String, bool> selectedChips = {
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
    'Ethiopian': false,
    'Fusion': false,
    'Vegetarian/Vegan': false,
    'Seafood': false,
    'BBQ': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(110, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/left-arrow.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: TitleText(
                  text: 'What are your dislikes?',
                  alignment: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: Radius.circular(10),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 10),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedChips.entries.map((entry) {
                        return StyledFilterChip(
                            label: entry.key,
                            selected: entry.value,
                            onSelected: (bool value) {
                              setState(() {
                                selectedChips[entry.key] = value;
                              });
                            });
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MainButton(
                    text: 'Next',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
