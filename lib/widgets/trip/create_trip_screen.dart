// Disable specific linting rules for this file
// ignore_for_file: non_constant_identifier_names, unused_field, avoid_print, deprecated_member_use

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import custom widgets and utilities
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/normal_text.dart';
import 'package:planit/widgets/title_text.dart';
import 'package:planit/widgets/input_field.dart';
import 'package:planit/widgets/trip/autocomplete_prediction.dart';
import 'package:planit/widgets/trip/blueprint_screen.dart';
import 'package:planit/widgets/trip/location_list_tile.dart';
import 'package:planit/widgets/trip/network_utility.dart';
import 'package:planit/widgets/trip/place_autocomplete_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main screen widget for creating a new trip
class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({required this.groupchat_id, super.key});

  final String groupchat_id; // ID of the group chat this trip belongs to

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _form = GlobalKey<FormState>(); // Key for form validation
  static const String _apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8'; // Google Maps API key

  // Controllers for text input and scrolling
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables for location predictions and form data
  List<AutocompletePrediction> _placePredictions = [];
  String _name = '';
  String _location = '';
  double _radius = 5.0; // Default radius in kilometers
  bool _isLoading = false;
  String? _error;

  // Final form values to be saved
  String _finalName = '';
  String _finalLocation = '';
  double? _finalLatitude;
  double? _finalLongitude;

  // Clean up controllers when widget is disposed
  @override
  void dispose() {
    _locationController.dispose();
    _radiusController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Fetches place predictions from Google Places API based on user input
  Future<void> _placeAutocomplete(String query) async {
    if (query.isEmpty) {
      setState(() {
        _placePredictions = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Construct API request URL
      final uri = Uri.https(
        'maps.googleapis.com',
        'maps/api/place/autocomplete/json',
        {
          'input': query,
          'key': _apiKey,
        },
      );

      final response = await NetworkUtility.fetchUrl(uri);

      if (response != null) {
        final result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
        setState(() {
          _placePredictions = result.predictions ?? [];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch location suggestions. Please try again.';
        _placePredictions = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetches detailed place information including coordinates
  Future<void> _getPlaceDetails(String? placeId) async {
    if (placeId == null) {
      print('PlaceId is null');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Request place details from Google Places API
      final uri = Uri.https(
        'maps.googleapis.com',
        'maps/api/place/details/json',
        {
          'place_id': placeId,
          'fields': 'geometry/location',
          'key': _apiKey,
        },
      );

      print('Fetching place details for placeId: $placeId');
      final response = await NetworkUtility.fetchUrl(uri);

      if (response != null) {
        final Map<String, dynamic> json = jsonDecode(response);
        print('Place Details Response: $json');

        // Extract coordinates from response
        if (json['result'] != null &&
            json['result']['geometry'] != null &&
            json['result']['geometry']['location'] != null) {
          final location = json['result']['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          print('Found coordinates - Lat: $lat, Lng: $lng');

          setState(() {
            _finalLatitude = lat;
            _finalLongitude = lng;
          });
        } else {
          print('Could not find location in response');
          setState(() {
            _error = 'Could not fetch location coordinates';
          });
        }
      }
    } catch (e) {
      print('Error in _getPlaceDetails: $e');
      setState(() {
        _error = 'Error fetching place details: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handles location selection from autocomplete suggestions
  void _onLocationSelected(String location, String? placeId) {
    setState(() {
      _location = location;
      _locationController.text = location;
      _placePredictions.clear();
    });
    if (placeId != null) {
      _getPlaceDetails(placeId);
    }
  }

  // Creates new trip in Firestore and navigates to BluePrint screen
  void _onBluePrint() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      print('Latitude: $_finalLatitude, Longitude: $_finalLongitude, Radius: $_radius');

      if (_finalLatitude == null || _finalLongitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location coordinates not found. Please try selecting the location again.'),
          ),
        );
        return;
      }

      try {
        // Create new trip document in Firestore
        final currentUser = FirebaseAuth.instance.currentUser;
        final docRef = await FirebaseFirestore.instance.collection('trips').add({
          'name': _finalName,
          'location': _finalLocation,
          'latitude': _finalLatitude,
          'longitude': _finalLongitude,
          'radius': _radius,
          'blueprint': [],
          'lastUpdated': Timestamp.now(),
          'groupchat_id': widget.groupchat_id,
          'created_by': currentUser!.uid,
        });

        print('Created document with ID: ${docRef.id}');

        // Update groupchat document with new trip ID
        final groupchatDoc = FirebaseFirestore.instance
            .collection('groupchats')
            .doc(widget.groupchat_id);
        final groupchatSnapshot = await groupchatDoc.get();

        if (!groupchatSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group chat not found. Please check the ID.'),
            ),
          );
          return;
        }

        await groupchatDoc.update({
          'trips': FieldValue.arrayUnion([docRef.id])
        });

        // Navigate to BluePrint screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BluePrintScreen(tripId: docRef.id),
          ),
        );
      } catch (error) {
        print('Error creating trip: $error');
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  // Form validation functions
  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? radiusValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Radius cannot be empty';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 5) {
      return 'Radius must be at least 5 km';
    }
    if (number > 100) {
      return 'Radius cannot be greater than 100 km';
    }
    return null;
  }

  // Build UI for trip creation screen
  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            Positioned.fill(
              bottom: 100,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(text: 'Let\'s create your trip!'),
                        const SizedBox(height: 6),
                        const NormalText(
                          text: 'Create your trip by filling in the necessary data below',
                          alignment: TextAlign.start,
                        ),
                        const SizedBox(height: 30),
                        // Name input field
                        InputField(
                          label: 'Name',
                          hint: 'Ex: Friday Night Trip',
                          inputType: TextInputType.name,
                          onChanged: (value) => setState(() => _name = value),
                          validator: nameValidator,
                          onSaved: (value) {
                            _finalName = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        // Radius slider
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Radius: ${_radius.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.black,
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: Colors.black,
                                overlayColor: Colors.black.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _radius,
                                min: 5,
                                max: 100,
                                divisions: 90, // Makes each step 1km
                                onChanged: (value) {
                                  setState(() {
                                    _radius = value;
                                    _radiusController.text = value.toString();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                        // Location input field with autocomplete
                        InputField(
                          label: 'Location',
                          hint: 'Search your location',
                          inputType: TextInputType.streetAddress,
                          controller: _locationController,
                          onChanged: (value) => _placeAutocomplete(value),
                          validator: nameValidator,
                          onSaved: (value) {
                            _finalLocation = value!;
                          },
                        ),
                        // Loading indicator
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        // Error message
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        // Location suggestions list
                        if (_placePredictions.isNotEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _placePredictions.length,
                            itemBuilder: (context, index) {
                              final prediction = _placePredictions[index];
                              return LocationListTile(
                                location: prediction.description ?? 'Unknown location',
                                press: () => _onLocationSelected(
                                  prediction.description ?? '',
                                  prediction.placeId,
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom button container
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: MainButton(
                  text: 'Start Creation',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onTap: _onBluePrint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}