import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile(
      {required this.location, required this.press, super.key});

  final String location;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.location_on_rounded),
          title: Text(
            location,
            style: GoogleFonts.lato(
              fontSize: 16,
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 212, 212, 212),
        )
      ],
    );
  }
}
