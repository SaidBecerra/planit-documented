import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/create_trip_screen.dart';

class GroupchatScreen extends StatelessWidget {
  const GroupchatScreen({super.key});

  void _onCreateTrip(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const CreateTripScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
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
