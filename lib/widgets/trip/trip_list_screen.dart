// Import necessary packages for UI, HTTP requests, and Firebase functionality
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/trip/trip_summary.dart';

// Main widget for displaying a list of trip options (restaurants or activities)
class TripListScreen extends StatefulWidget {
  const TripListScreen({required this.tripId, required this.index, super.key});

  final int index;          // Current index in the trip blueprint
  final String tripId;      // Unique identifier for the trip

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  // Google Places API key for fetching location data
  static const apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';

  // Predefined list of food cuisine types
  static const _foodTypes = [
    'Asian',
    'Mexican',
    'Italian',
    'American',
    'Indian',
    'Mediterranean',
    'French',
    'Greek',
    'Thai',
    'Japanese',
    'Chinese',
    'Korean',
    'Vietnamese',
    'Turkish',
    'Spanish',
    'Middle Eastern',
    'Brazilian',
    'Caribbean',
    'Vegetarian/Vegan',
    'Seafood',
    'BBQ',
  ];

  // Predefined list of activity types
  static const _activityTypes = [
    'Hiking',
    'Swimming',
    'Cycling',
    'Running',
    'Yoga',
    'Photography',
    'Painting',
    'Reading',
    'Gaming',
    'Cooking',
    'Gardening',
    'Dancing',
    'Meditation',
    'Surfing',
    'Rock Climbing',
    'Tennis',
    'Basketball',
    'Camping',
    'Traveling',
    'Music',
    'Writing',
  ];

  // State variables
  List<Map<String, dynamic>> places = [];     // List of places fetched from API
  List<Map<String, dynamic>> blueprints = []; // Trip blueprint data
  bool isLoading = true;                      // Loading state indicator
  String tripLocation = '';                   // Trip location coordinates
  String tripRadius = '';                     // Search radius for places
  List<String> dislikes = [];                // Combined dislikes from all group members

  @override
  void initState() {
    super.initState();
    _initializeData();  // Initialize data when widget is created
  }

  // Fetch and initialize all necessary data for the trip
  Future<void> _initializeData() async {
    try {
      // Fetch trip data from Firestore
      final tripDoc = await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .get();

      if (!tripDoc.exists) throw Exception('Trip not found');
      final tripData = tripDoc.data()!;

      // Extract trip details from document
      tripLocation = '${tripData['latitude']},${tripData['longitude']}';
      tripRadius = (tripData['radius'] * 1000).round().toString();
      blueprints = List<Map<String, dynamic>>.from(tripData['blueprint'] ?? []);

      if (blueprints.isEmpty || widget.index >= blueprints.length) {
        throw Exception('Invalid blueprint data');
      }

      // Get group chat members
      final chatId = tripData['groupchat_id'] as String?;
      if (chatId == null) throw Exception('No groupchat found');

      final groupDoc = await FirebaseFirestore.instance
          .collection('groupchats')
          .doc(chatId)
          .get();

      if (!groupDoc.exists) throw Exception('Groupchat not found');
      final memberIds = List<String>.from(groupDoc.data()!['members'] ?? []);

      // Fetch and combine dislikes from all group members
      final memberDocs = await Future.wait(memberIds.map((id) =>
          FirebaseFirestore.instance.collection('users').doc(id).get()));

      final isFood =
          blueprints[widget.index]['activity']['type'] == 'ActivityType.food';
      final dislikeField = isFood ? 'foodDislikes' : 'activityDislikes';

      dislikes = memberDocs
          .where((doc) => doc.exists)
          .expand((doc) => List<String>.from(doc.data()?[dislikeField] ?? []))
          .toSet()
          .toList();

      // Fetch relevant places based on type (food or activity)
      await _fetchPlaces(isFood);
    } catch (e) {
      debugPrint('Error initializing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fetch places from Google Places API based on type
  Future<void> _fetchPlaces(bool isFood) async {
    try {
      // Filter available types based on group dislikes
      final baseTypes = isFood ? _foodTypes : _activityTypes;
      final availableTypes = baseTypes
          .where((type) => !dislikes.any(
              (dislike) => type.toLowerCase().contains(dislike.toLowerCase())))
          .toList();

      if (availableTypes.isEmpty) {
        throw Exception(
            'No suitable ${isFood ? 'cuisines' : 'activities'} found');
      }

      // Randomly select a subset of types
      availableTypes.shuffle();
      final selectedTypes = availableTypes.take(8).toList();

      // Fetch places for each selected type
      final results = await Future.wait(
          selectedTypes.map((type) => _fetchPlacesByType(type, isFood)));

      setState(() {
        places = results.expand((list) => list).toList()..shuffle();
      });
    } catch (e) {
      debugPrint('Error fetching places: $e');
      rethrow;
    }
  }

  // Fetch places from Google Places API for a specific type
  Future<List<Map<String, dynamic>>> _fetchPlacesByType(
      String type, bool isFood) async {
    try {
      // Construct API URL with parameters
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$tripLocation'
          '&radius=$tripRadius'
          '&type=${isFood ? 'restaurant' : 'establishment'}'
          '&keyword=$type'
          '&key=$apiKey');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] != 'OK') return [];

      // Process and format place results
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.take(3).map((place) {
        String? photoUrl;
        if (place['photos'] != null) {
          final photoRef = place['photos'][0]['photo_reference'];
          photoUrl = 'https://maps.googleapis.com/maps/api/place/photo'
              '?maxwidth=400'
              '&photo_reference=$photoRef'
              '&key=$apiKey';
        }

        return {
          'name': place['name'],
          'vicinity': place['vicinity'],
          'photoUrl': photoUrl ?? 'assets/images/pizza.jpg',
          'type': type,
          'price_level': place['price_level'] ?? 0,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching places by type: $e');
      return [];
    }
  }

  // Handle selection of a place and navigation to next screen
  Future<void> _onNextPage(String name, String location, String imageLocation,
      List<String> cuisineTypes, int? priceLevel) async {
    try {
      // Get current blueprint and position
      final currentBlueprint = blueprints[widget.index];
      debugPrint('All blueprints: $blueprints');
      debugPrint('Current index: ${widget.index}');
      debugPrint('Current blueprint: $currentBlueprint');

      // Get position from blueprint or use default
      int position;
      try {
        position = (currentBlueprint['position'] ?? 10) as int;
        debugPrint('Position value: $position');
      } catch (e) {
        debugPrint('Error getting position: $e');
        position = 10;
      }

      // Create place data for saving
      final placeData = {
        'name': name,
        'location': location,
        'imageLocation': imageLocation,
        'cuisineTypes': cuisineTypes,
        'priceLevel': priceLevel ?? 0,
        'position': position,
      };

      // Get reference to trip document
      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(widget.tripId);

      // Fetch and update saved trip array
      final tripDoc = await tripRef.get();
      List<dynamic> currentSavedTrip = [];

      if (tripDoc.exists) {
        currentSavedTrip =
            List<dynamic>.from(tripDoc.data()?['savedTrip'] ?? []);
      }

      // Update or add new place data
      if (currentSavedTrip.length > widget.index) {
        currentSavedTrip[widget.index] = placeData;
      } else {
        while (currentSavedTrip.length < widget.index) {
          currentSavedTrip.add(null);
        }
        currentSavedTrip.add(placeData);
      }

      // Save updated trip data
      await tripRef.update({
        'savedTrip': currentSavedTrip,
      });

      // Navigate to next screen or summary
      if (widget.index >= blueprints.length - 1) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (ctx) => TripSummary(tripId: widget.tripId),
            ),
            (route) => false,
          );
        }

        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) =>
                TripListScreen(tripId: widget.tripId, index: widget.index + 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving trip data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving selection: $e')));
      }
    }
  }

  // Helper function to capitalize first letter of text
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if data isn't ready
    if (blueprints.isEmpty || widget.index >= blueprints.length) {
      return const ScaffoldLayout(
        body: Center(child: Text('Loading...')),
      );
    }

    // Determine if current selection is for food or activity
    final isFood =
        blueprints[widget.index]['activity']['type'] == 'ActivityType.food';
    final titleText =
        isFood ? 'Let\'s pick your restaurant!' : 'Let\'s pick your activity!';

    // Build main screen layout
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: titleText),
            const SizedBox(height: 30),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        return TripOption(
                          name: place['name'] ?? 'Unknown Place',
                          location: place['vicinity'] ?? 'Unknown Location',
                          imageLocation:
                              place['photoUrl'] ?? 'assets/images/pizza.jpg',
                          cuisineTypes: [
                            _capitalizeFirst(place['type'] ?? 'Unknown')
                          ],
                          priceLevel: place['price_level'] ?? 0,
                          onTap: _onNextPage,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}