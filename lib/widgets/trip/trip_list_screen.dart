import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({required this.tripId, required this.index, super.key});

  final int index;
  final String tripId;

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? nextPageToken;
  final apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';
  final ScrollController _scrollController = ScrollController();
  String? _baseUrl;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchRestaurants();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore &&
        nextPageToken != null) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (nextPageToken == null || _baseUrl == null) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      // Wait for a short delay as required by Places API
      await Future.delayed(const Duration(seconds: 2));
      
      final url = Uri.parse('$_baseUrl&pagetoken=$nextPageToken');
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        final results = (data['results'] as List).map((result) {
          final restaurant = Map<String, dynamic>.from(result);

          String? photoReference;
          if (restaurant['photos'] != null &&
              (restaurant['photos'] as List).isNotEmpty) {
            photoReference = (restaurant['photos'] as List)
                .first['photo_reference'] as String?;
          }

          final photoUrl = photoReference != null
              ? getPhotoUrl(photoReference)
              : 'assets/images/pizza.jpg';

          restaurant['photoUrl'] = photoUrl;
          return restaurant;
        }).toList();

        setState(() {
          restaurants.addAll(results);
          nextPageToken = data['next_page_token'];
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoadingMore = false;
          nextPageToken = null;
        });
      }
    } catch (e) {
      print('Error loading more results: $e');
      setState(() {
        isLoadingMore = false;
        nextPageToken = null;
      });
    }
  }

  String getPhotoUrl(String? photoReference) {
    if (photoReference == null) return 'assets/images/pizza.jpg';

    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=400'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }

  Future<void> fetchRestaurants() async {
    final tripDoc = FirebaseFirestore.instance
            .collection('trips')
            .doc(widget.tripId);

    final tripSnapshot = await tripDoc.get();
    
    if (!tripSnapshot.exists) {
      print('Trip document does not exist!');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip not found')),
      );
      return;
    }

    final data = tripSnapshot.data() as Map<String, dynamic>;
    
    if (data['latitude'] == null || data['longitude'] == null || 
        data['radius'] == null || data['blueprint'] == null ||
        widget.index >= data['blueprint'].length) {
      print('Missing required trip data!');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid trip data')),
      );
      return;
    }

    final location = '${data['latitude'] ?? 0.0},${data['longitude'] ?? 0.0}';
    final radius = ((data['radius'] as num).toDouble() * 1000).round().toString();
    final String type = data['blueprint'][widget.index]['activity']['type'] == 'ActivityType.food' 
        ? 'restaurant' 
        : 'activity';

    _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$location&radius=$radius&type=$type&key=$apiKey';
    
    final url = Uri.parse(_baseUrl!);
    print('Request URL: $url');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        final results = (data['results'] as List).map((result) {
          final restaurant = Map<String, dynamic>.from(result);

          String? photoReference;
          if (restaurant['photos'] != null &&
              (restaurant['photos'] as List).isNotEmpty) {
            photoReference = (restaurant['photos'] as List)
                .first['photo_reference'] as String?;
          }

          final photoUrl = photoReference != null
              ? getPhotoUrl(photoReference)
              : 'assets/images/pizza.jpg';

          restaurant['photoUrl'] = photoUrl;

          return restaurant;
        }).toList();

        setState(() {
          restaurants = results;
          nextPageToken = data['next_page_token'];
          isLoading = false;
        });
      } else {
        print('API Error: ${data['status']}');
        setState(() {
          restaurants = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading locations: ${data['status']}')),
        );
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      setState(() {
        restaurants = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading locations: $e')),
      );
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
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            ...restaurants.map((restaurant) {
                              return TripOption(
                                name: restaurant['name'] ?? 'Unknown Restaurant',
                                location: restaurant['vicinity'] ?? 'Unknown Location',
                                imageLocation: restaurant['photoUrl'],
                                types: List<String>.from(restaurant['types'] ?? []),
                                priceLevel: restaurant['price_level'] ?? 0,
                              );
                              }),
                            if (isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
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