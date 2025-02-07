import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom list tile widget that displays a location with an icon.
/// It provides a tappable interface for selecting a location.

class LocationListTile extends StatelessWidget {
  // Creates a [LocationListTile].
  ///
  // [location] is the name of the location to display.
  // [press] is the callback function that will be executed when the tile is tapped.
  const LocationListTile(
      {required this.location, required this.press, super.key});

/// The name of the location to display.
  final String location;

   /// The callback function that will be triggered when the list tile is tapped.
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// The main tappable list tile for displaying the location.
        ListTile(
          onTap: press, // Triggers the provided callback when tapped.
          horizontalTitleGap: 0, // Removes extra spacing between the icon and title.
          leading: const Icon(Icons.location_on_rounded), // Location icon on the left.
          title: Text(
            location, // Displays the location name.
            style: GoogleFonts.lato(
              fontSize: 16,  // Custom font style using Google Fonts (Lato).
            ),
          ),
        ),
        /// A divider to separate the list tile from the next item.
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 212, 212, 212), // Light gray color for the divider.
        )
      ],
    );
  }
}
