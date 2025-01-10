import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/trip/trip_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/trip/trip_summary.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({required this.tripId, required this.index, super.key});

  final int index;
  final String tripId;

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  static const apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';
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

  // Existing variables
  List<Map<String, dynamic>> places = [];
  List<Map<String, dynamic>> blueprints = [];
  bool isLoading = true;
  String tripLocation = '';
  String tripRadius = '';
  List<String> dislikes = [];

  // New variables for infinite scrolling
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String? _nextPageToken;
  int _currentTypeIndex = 0;
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _nextPageToken != null) {
      _loadMorePlaces();
    }
  }

  Future<void> _initializeData() async {
    try {
      // Fetch trip data
      final tripDoc = await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .get();

      if (!tripDoc.exists) throw Exception('Trip not found');
      final tripData = tripDoc.data()!;

      // Extract trip details
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

      // Fetch and combine member dislikes
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

      // Initialize selected types
      final baseTypes = isFood ? _foodTypes : _activityTypes;
      _selectedTypes = baseTypes
          .where((type) => !dislikes.any(
              (dislike) => type.toLowerCase().contains(dislike.toLowerCase())))
          .toList();

      if (_selectedTypes.isEmpty) {
        throw Exception(
            'No suitable ${isFood ? 'cuisines' : 'activities'} found');
      }

      _selectedTypes.shuffle();
      await _fetchInitialPlaces(isFood);
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

  Future<void> _fetchInitialPlaces(bool isFood) async {
    try {
      final results = await _fetchPlacesByType(_selectedTypes[_currentTypeIndex], isFood);
      setState(() {
        places = results;
        _currentTypeIndex++;
      });
    } catch (e) {
      debugPrint('Error fetching initial places: $e');
      rethrow;
    }
  }

  Future<void> _loadMorePlaces() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      List<Map<String, dynamic>> newPlaces = [];
      
      // Try to get more places with next_page_token
      if (_nextPageToken != null) {
        newPlaces = await _fetchPlacesWithToken(_selectedTypes[_currentTypeIndex - 1]);
      }
      
      // If no more places with token or no token, try next type
      if (newPlaces.isEmpty && _currentTypeIndex < _selectedTypes.length) {
        final isFood = blueprints[widget.index]['activity']['type'] == 'ActivityType.food';
        newPlaces = await _fetchPlacesByType(_selectedTypes[_currentTypeIndex], isFood);
        _currentTypeIndex++;
      }

      if (mounted) {
        setState(() {
          places.addAll(newPlaces);
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading more places: $e');
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPlacesWithToken(String type) async {
    try {
      // Add delay to respect Google Places API rate limiting
      await Future.delayed(const Duration(seconds: 2));

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?pagetoken=$_nextPageToken'
          '&key=$apiKey');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] != 'OK') return [];

      // Save next page token for future requests
      _nextPageToken = data['next_page_token'];

      final results = List<Map<String, dynamic>>.from(data['results']);
      return _processPlaceResults(results, type);
    } catch (e) {
      debugPrint('Error fetching places with token: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPlacesByType(
      String type, bool isFood) async {
    try {
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

      // Save next page token for future requests
      _nextPageToken = data['next_page_token'];

      final results = List<Map<String, dynamic>>.from(data['results']);
      return _processPlaceResults(results, type);
    } catch (e) {
      debugPrint('Error fetching places by type: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _processPlaceResults(
      List<Map<String, dynamic>> results, String type) {
    return results.map((place) {
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
  }

  Future<void> _onNextPage(String name, String location, String imageLocation,
      List<String> cuisineTypes, int? priceLevel) async {
    try {
      // Get the blueprint for current index
      final currentBlueprint = blueprints[widget.index];

      // Access position from blueprint
      int position = (currentBlueprint['position'] ?? 10) as int;

      // Create the place data map
      final placeData = {
        'name': name,
        'location': location,
        'imageLocation': imageLocation,
        'cuisineTypes': cuisineTypes,
        'priceLevel': priceLevel ?? 0,
        'position': position,
      };

      // Get the trip document reference
      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(widget.tripId);

      // Fetch current savedTrip array
      final tripDoc = await tripRef.get();
      List<dynamic> currentSavedTrip = 
          List<dynamic>.from(tripDoc.data()?['savedTrip'] ?? []);

      // Add new place data at the current index
      if (currentSavedTrip.length > widget.index) {
        currentSavedTrip[widget.index] = placeData;
      } else {
        while (currentSavedTrip.length < widget.index) {
          currentSavedTrip.add(null);
        }
        currentSavedTrip.add(placeData);
      }

      // Update the document
      await tripRef.update({
        'savedTrip': currentSavedTrip,
      });

      // Navigate to next screen
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

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if (blueprints.isEmpty || widget.index >= blueprints.length) {
      return const ScaffoldLayout(
        body: Center(child: Text('Loading...')),
      );
    }

    final isFood =
        blueprints[widget.index]['activity']['type'] == 'ActivityType.food';
    final titleText =
        isFood ? 'Let\'s pick your restaurant!' : 'Let\'s pick your activity!';

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
                      controller: _scrollController,
                      itemCount: places.length + 1,
                      itemBuilder: (context, index) {
                        if (index == places.length) {
                          return _isLoadingMore
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox();
                        }

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