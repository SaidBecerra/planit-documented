import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';
import 'package:google_fonts/google_fonts.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({required this.tripId, super.key});

  final String tripId;

  @override
  State<TripDetails> createState() {
    return _TripDetailsState();
  }
}

class _TripDetailsState extends State<TripDetails> {
  List<Map<String, dynamic>> savedTrips = [];
  String tripName = '';
  bool isLoading = true;

  String _getTimeRange(int position) {
    int startHour = position;
    int endHour = (position + 1) % 24;
    
    // Format the time strings
    String startTime = '${startHour.toString().padLeft(2, '0')}:00';
    String endTime = '${endHour.toString().padLeft(2, '0')}:00';
    
    return '$startTime - $endTime';
  }

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
        savedTrips = List<Map<String, dynamic>>.from(tripData['savedTrip'] ?? []);
        tripName = tripData['name'] ?? 'Unnamed Trip';
        isLoading = false;
      });

      debugPrint('Loaded trip: $tripName with ${savedTrips.length} saved locations');
    } catch (e) {
      debugPrint('Error initializing data: $e');
      setState(() => isLoading = false);
    }
  }

  void _handleTripOptionTap(String name, String location, String imageLocation,
      List<String> cuisineTypes, int? priceLevel) {
    debugPrint('Tapped on location: $name');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
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
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      itemCount: savedTrips.length,
                      itemBuilder: (context, index) {
                        final trip = savedTrips[index];
                        final timeRange = _getTimeRange(trip['position'] ?? 0);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                              child: Text(
                                timeRange,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TripOption(
                              name: trip['name'] ?? '',
                              location: trip['location'] ?? '',
                              imageLocation: trip['imageLocation'] ?? '',
                              cuisineTypes: List<String>.from(trip['cuisineTypes'] ?? []),
                              priceLevel: trip['priceLevel'] ?? 0,
                              onTap: _handleTripOptionTap,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}