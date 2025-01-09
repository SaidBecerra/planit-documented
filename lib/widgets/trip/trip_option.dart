import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripOption extends StatelessWidget {
  const TripOption({
    required this.name,
    required this.location,
    required this.imageLocation,
    required this.cuisineTypes,
    required this.onTap,
    this.priceLevel = 0,
    super.key,
  });

  final String name;
  final String location;
  final String imageLocation;
  final List<String> cuisineTypes;
  final int priceLevel;
  final void Function(String name, String location, String imageLocation, List<String> cuisineTypes, int? priceLevel) onTap;

  String getPriceLevel(int level) {
    return List.filled(level, '\$').join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(name, location, imageLocation, cuisineTypes, priceLevel),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageLocation.startsWith('assets/')
                    ? Image.asset(
                        imageLocation,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageLocation,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
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
        
              // Restaurant Name
              Text(
                name,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              // Location
              Text(
                location,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
        
              // Tags Row - Cuisine Types and Price Level
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Cuisine Type Tags
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
        
                    // Price Level
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