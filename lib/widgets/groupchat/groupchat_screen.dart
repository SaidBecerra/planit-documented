import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/view_members.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/create_trip_screen.dart';

class GroupchatScreen extends StatelessWidget {
  const GroupchatScreen({required this.groupchatID, super.key});
    final String groupchatID; 

  void _onCreateTrip(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const CreateTripScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      actions: [
        const Spacer(),
        SizedBox(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ViewMembersScreen(groupchatID: groupchatID),
                )
              );
            },
            icon: const Icon(Icons.add_circle_outline_rounded)
          ),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                radius: Radius.circular(10),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(right: 12),
                  child: Text('hello'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: MainButton(
                text: 'Create Trip',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () {
                  _onCreateTrip(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
