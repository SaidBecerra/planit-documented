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

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  static const String _apiKey = 'AIzaSyCPT_9MfN37x1XCG-mzbBQTgPgxqgPsmD8';
  
  final TextEditingController _locationController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<AutocompletePrediction> _placePredictions = [];
  String _name = '';
  String _location = '';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _locationController.dispose();
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
        final result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
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

  void _onLocationSelected(String location) {
    setState(() {
      _location = location;
      _locationController.text = location;  // Update the text field
      _placePredictions.clear();  // Clear the predictions
    });
  }

  void _onBluePrint(BuildContext context) {
    if (_name.isEmpty || _location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const BluePrintScreen(),
      ),
    );
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
                      InputField(
                        label: 'Name',
                        hint: 'Ex: Friday Night Trip',
                        inputType: TextInputType.name,
                        onChanged: (value) => setState(() => _name = value),
                      ),
                      const SizedBox(height: 30),
                      InputField(
                        label: 'Location',
                        hint: 'Search your location',
                        inputType: TextInputType.streetAddress,
                        controller: _locationController,  // Add the controller here
                        onChanged: (value) => _placeAutocomplete(value),
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
                              location: prediction.description ?? 'Unknown location',
                              press: () => _onLocationSelected(prediction.description ?? ''),
                            );
                          },
                        ),
                      const SizedBox(height: 100),
                    ],
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
                  onTap: () => _onBluePrint(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}