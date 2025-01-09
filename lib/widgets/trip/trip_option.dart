import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripOption extends StatelessWidget {
  const TripOption({
    required this.name,
    required this.location,
    required this.imageLocation,
    this.types = const <String>[],
    this.priceLevel = 0,
    super.key,
  });

  final String name;
  final String location;
  final String imageLocation;
  final List<String> types;
  final int priceLevel;

  String getPriceLevel(int level) {
    return List.filled(level, '\$').join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

            // Tags Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Restaurant Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Type Tags
                  ...types.take(3).map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            type.split('_').map((word) => 
                              word[0].toUpperCase() + word.substring(1).toLowerCase()
                            ).join(' '),
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
                      child: Text(getPriceLevel(priceLevel)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}