// Import required Flutter packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget that displays a single trip option (restaurant or activity) as a card
class TripOption extends StatelessWidget {
  // Constructor with required and optional parameters
  const TripOption({
    required this.name,
    required this.location,
    required this.imageLocation,
    required this.cuisineTypes,
    required this.onTap,
    this.priceLevel = 0,  // Default price level is 0
    super.key,
  });

  // Properties to store trip option details
  final String name;                // Name of the place
  final String location;           // Address/location of the place
  final String imageLocation;      // URL or asset path for the image
  final List<String> cuisineTypes; // List of cuisine or activity types
  final int priceLevel;           // Price level (0-4)
  // Callback function when option is selected
  final void Function(String name, String location, String imageLocation, List<String> cuisineTypes, int? priceLevel) onTap;

  // Helper method to convert price level number to dollar signs
  String getPriceLevel(int level) {
    return List.filled(level, '\$').join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        // Handle tap event with provided callback
        onTap: () => onTap(name, location, imageLocation, cuisineTypes, priceLevel),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // Card styling
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with error and loading handling
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageLocation.startsWith('assets/')
                    // Show local asset image
                    ? Image.asset(
                        imageLocation,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    // Show network image with loading and error states
                    : Image.network(
                        imageLocation,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          // Show loading indicator while image loads
                          return Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Show fallback icon if image fails to load
                          return Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
        
              // Place name with custom font
              Text(
                name,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              // Location text with custom font
              Text(
                location,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
        
              // Horizontal scrollable row for tags
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Generate cuisine/activity type tags
                    ...cuisineTypes.map((cuisine) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              cuisine,
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )),
        
                    // Show price level tag if price > 0
                    if (priceLevel > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          getPriceLevel(priceLevel),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}