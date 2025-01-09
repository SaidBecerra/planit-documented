import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';

class TripSummary extends StatefulWidget {
  const TripSummary({required this.tripId, super.key});

  final String tripId;

  @override
  State<TripSummary> createState() {
    return _TripSummaryState_();
  }
}

class _TripSummaryState_ extends State<TripSummary> {
  List<Map<String, dynamic>> savedTrips = [];
  String tripName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);

      final tripDoc = await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .get();

      if (!tripDoc.exists) {
        throw Exception('Trip not found');
      }

      final tripData = tripDoc.data()!;
      setState(() {
        savedTrips =
            List<Map<String, dynamic>>.from(tripData['savedTrip'] ?? []);
        tripName = tripData['name'] ?? 'Unnamed Trip';
        isLoading = false;
      });

      debugPrint(
          'Loaded trip: $tripName with ${savedTrips.length} saved locations');
    } catch (e) {
      debugPrint('Error initializing data: $e');
      setState(() => isLoading = false);
    }
  }

  void _handleTripOptionTap(String name, String location, String imageLocation,
      List<String> cuisineTypes, int? priceLevel) {
    // Handle the tap event
    debugPrint('Tapped on location: $name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(text: tripName),
              const SizedBox(height: 12),
              if (isLoading)
                const Center(child: Text('loading..'))
              else if (savedTrips.isEmpty)
                const Center(child: Text('No saved trips found'))
              else
                Expanded(
                  // Wrap Scrollbar with Expanded
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      // Remove SingleChildScrollView
                      itemCount: savedTrips.length,
                      itemBuilder: (context, index) {
                        final trip = savedTrips[index];
                        return TripOption(
                          name: trip['name'] ?? '',
                          location: trip['location'] ?? '',
                          imageLocation: trip['imageLocation'] ?? '',
                          cuisineTypes:
                              List<String>.from(trip['cuisineTypes'] ?? []),
                          priceLevel: trip['priceLevel'] ?? 0,
                          onTap: _handleTripOptionTap,
                        );
                      },
                    ),
                  ),
                ),
              MainButton(
                  text: 'Done',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: () => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const CustomNavigatonBar(),
                          ),
                          (route) => false,
                        )
                      })
            ],
          ),
        ),
      ),
    );
  }
}
