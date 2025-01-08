import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/groupchat.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 6,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                  GroupChat(
                    name: 'Goofy Goobers',
                    tripCount: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
