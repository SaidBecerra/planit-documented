import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;
  final apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  String getPhotoUrl(String? photoReference) {
    if (photoReference == null) return 'assets/images/pizza.jpg';
    
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=400'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }

  Future<void> fetchRestaurants() async {
    final apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';
    final location = '44.8015,10.3279'; // Parma, Italy coordinates
    final radius = '1500'; // Search radius in meters

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&type=restaurant&key=$apiKey');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        final results = (data['results'] as List).map((result) {
          // Explicitly cast each result to Map<String, dynamic>
          final restaurant = Map<String, dynamic>.from(result);
          
          // Handle photos
          String? photoReference;
          if (restaurant['photos'] != null && (restaurant['photos'] as List).isNotEmpty) {
            photoReference = (restaurant['photos'] as List).first['photo_reference'] as String?;
          }

          // Create the photo URL
          final photoUrl = photoReference != null 
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey'
              : 'assets/images/pizza.jpg';

          // Add the photo URL to the restaurant data
          restaurant['photoUrl'] = photoUrl;

          return restaurant;
        }).toList();

        setState(() {
          restaurants = results;
          isLoading = false;
        });
      } else {
        print('API Error: ${data['status']}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: 'Let\'s pick your location!'),
            const SizedBox(height: 6),
            const NormalText(
              text: 'Select a restaurant you would like to add to your trip',
              alignment: TextAlign.start,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Scrollbar(
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: restaurants.map((restaurant) {
                            return TripOption(
                              name: restaurant['name'] ?? 'Unknown Restaurant',
                              location: restaurant['vicinity'] ?? 'Unknown Location',
                              imageLocation: restaurant['photoUrl'],
                              types: List<String>.from(restaurant['types'] ?? []),
                              priceLevel: restaurant['price_level'] ?? 0,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}