import 'dart:convert';
import 'package:flutter/material.dart';
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

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({required this.groupchat_id, super.key});

  final String groupchat_id;

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _form = GlobalKey<FormState>();
  static const String _apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<AutocompletePrediction> _placePredictions = [];
  String _name = '';
  String _location = '';
  double _radius = 10.0; // Default to minimum value
  bool _isLoading = false;
  String? _error;

  String _finalName = '';
  String _finalLocation = '';
  double? _finalLatitude;
  double? _finalLongitude;

  @override
  void dispose() {
    _locationController.dispose();
    _radiusController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
        final result =
            PlaceAutocompleteResponse.parseAutocompleteResult(response);
        setState(() {
          _placePredictions = result.predictions ?? [];
        });

        if (_placePredictions.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 100));
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
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

  void _onBluePrint() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      print(
          'Latitude: $_finalLatitude, Longitude: $_finalLongitude, Radius: $_radius');

      if (_finalLatitude == null || _finalLongitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location coordinates not found. Please try selecting the location again.'),
          ),
        );
        return;
      }

      try {
        final docRef =
            await FirebaseFirestore.instance.collection('trips').add({
          'name': _finalName,
          'location': _finalLocation,
          'latitude': _finalLatitude,
          'longitude': _finalLongitude,
          'radius': _radius,
          'blueprint': [],
          'lastUpdated': Timestamp.now(),
          'groupchat_id': widget.groupchat_id,
        });

        print('Created document with ID: ${docRef.id}');

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
    if (number < 10) {
      return 'Radius must be at least 10 km';
    }
    if (number > 100) {
      return 'Radius cannot be greater than 100 km';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: SafeArea(
        child: Stack(
          children: [
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
                          text:
                              'Create your trip by filling in the necessary data below',
                          alignment: TextAlign.start,
                        ),
                        const SizedBox(height: 30),
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
                                min: 10,
                                max: 100,
                                divisions: 90, // This makes each step 1km
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
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        if (_placePredictions.isNotEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _placePredictions.length,
                            itemBuilder: (context, index) {
                              final prediction = _placePredictions[index];
                              return LocationListTile(
                                location: prediction.description ??
                                    'Unknown location',
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
