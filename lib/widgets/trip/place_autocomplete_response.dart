import 'dart:convert';
import 'package:planit/widgets/trip/autocomplete_prediction.dart';

/// Represents the response from a Places Autocomplete API request.
class PlaceAutocompleteResponse {
  /// The status of the response, indicating success or failure.
  final String? status;
  /// A list of autocomplete predictions returned from the API.
  final List<AutocompletePrediction>? predictions;

  // Constructor for creating a [PlaceAutocompleteResponse] instance.
  ///
  // [status] represents the response status.
  // [predictions] contains a list of [AutocompletePrediction] objects.
  PlaceAutocompleteResponse({
    this.status,
    this.predictions,
  });

  // Factory method to create an instance of [PlaceAutocompleteResponse]
  /// from a JSON object.
  ///
  // Parses the given [json] and returns an instance of the class.
  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? (json['predictions'] as List)
              .map<AutocompletePrediction>(
                  (json) => AutocompletePrediction.fromJson(json))
              .toList() // Converts each prediction into an AutocompletePrediction object.
          : null,
    );
  }


  /// Parses the raw API response string and returns a
  // [PlaceAutocompleteResponse] instance.
  ///
  // [responseBody] is the raw JSON string from the API response.
  static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody) {
  // Decode the response string into a map of key-value pairs.
  final parsed = json.decode(responseBody).cast<String, dynamic>();

  // Convert the parsed map into a PlaceAutocompleteResponse object.
  return PlaceAutocompleteResponse.fromJson(parsed);
} 
}