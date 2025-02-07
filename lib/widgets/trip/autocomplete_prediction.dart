/// Represents a prediction for autocomplete results
class AutocompletePrediction {
  /// A text description of the place (e.g., "Central Park, New York, NY, USA").
  final String? description;
  /// Structured formatting of the prediction result, which includes the main
  /// and secondary text (e.g., "Main Text" could be the place name, and "Secondary Text" could be the location).
  final StructuredFormatting? structuredFormatting;
  /// The unique identifier for the place.
  final String? placeId;
  /// A reference used for retrieving detailed information about the place.
  final String? reference;

  // Constructor for creating an [AutocompletePrediction] object.
  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
  });

  // Factory constructor for creating an [AutocompletePrediction] object from a JSON map.
  /// This is useful when parsing data from an API response.
  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?, // Extracts the 'description' field from the JSON.
      placeId: json['place_id'] as String?, // Extracts the 'place_id' field.
      reference: json['reference'] as String?, // Extracts the 'reference' field.
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

/// Represents the structured formatting for an autocomplete prediction.
/// This typically separates the main text (example: place name) and secondary text (example: location).
class StructuredFormatting {
  /// The main part of the text (example: the place name).
  final String? mainText;
  /// The secondary part of the text (example: the location).
  final String? secondaryText;

  // Constructor for creating a [StructuredFormatting] object.
  StructuredFormatting({this.mainText, this.secondaryText});

  // Factory constructor for creating a [StructuredFormatting] object from a JSON map.
  /// This helps convert structured formatting data from an API response into a Dart object.
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,  // Extracts the 'main_text' field.
      secondaryText: json['secondary_text'] as String?, // Extracts the 'secondary_text' field.
    );
  }
}