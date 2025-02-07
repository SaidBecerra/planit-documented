import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planit/widgets/groupchat/view_members.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/create_trip_screen.dart';
import 'package:planit/widgets/trip/trip_details.dart';

/// A screen that displays details of a group chat and allows users to create trips and view existing trips.
///
/// This screen fetches the trips associated with a group chat and displays them. It also provides a button to
/// create new trips and a button to view group members.
class GroupchatScreen extends StatefulWidget {
  /// The unique identifier for the group chat.
  final String groupchatID;

  /// Creates a [GroupchatScreen] widget.
  const GroupchatScreen({required this.groupchatID, super.key});

  @override
  State<GroupchatScreen> createState() {
    return GroupchatScreenState();
  }
}

class GroupchatScreenState extends State<GroupchatScreen> {
  // Stores the list of trips related to this group chat.
  List<Map<String, dynamic>> trips = [];
  
  // Flag indicating whether the data is still loading.
  bool isLoading = true;

  // Cache to store creator names for the trips to avoid repeated fetching.
  Map<String, String> creatorNames = {};

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  /// Fetches the name of the user who created the trip.
  ///
  /// This function checks the cache first. If the name is not cached, it fetches it from Firestore.
  Future<String> _getCreatorName(String userId) async {
    // If creator name is already cached, return it.
    if (creatorNames.containsKey(userId)) {
      return creatorNames[userId]!;
    }

    try {
      // Fetch the user document from Firestore.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Extract the username, or default to 'Unknown User' if it doesn't exist.
      final userName = userDoc.data()?['username'] ?? 'Unknown User';
      
      // Cache the name for future use.
      creatorNames[userId] = userName;
      return userName;
    } catch (e) {
      debugPrint('Error fetching user name: $e');
      return 'Unknown User';
    }
  }

  /// Loads the trips related to this group chat.
  Future<void> _loadTrips() async {
    try {
      setState(() => isLoading = true);

      // Fetch the group chat document from Firestore.
      final groupchatDoc = await FirebaseFirestore.instance
          .collection('groupchats')
          .doc(widget.groupchatID)
          .get();

      // If the group chat doesn't exist, log the error and stop loading.
      if (!groupchatDoc.exists) {
        debugPrint('Groupchat document not found');
        setState(() => isLoading = false);
        return;
      }

      // Extract the list of trip IDs associated with this group chat.
      final tripIds = List<String>.from(groupchatDoc.data()?['trips'] ?? []);

      // If there are no trips, update the state and exit.
      if (tripIds.isEmpty) {
        setState(() {
          trips = [];
          isLoading = false;
        });
        return;
      }

      // Fetch all trip documents from Firestore.
      final tripsSnapshots = await Future.wait(
        tripIds.map((tripId) =>
            FirebaseFirestore.instance.collection('trips').doc(tripId).get()),
      );

      // Process the trip documents and add the creator name for each trip.
      final loadedTrips = tripsSnapshots
          .where((doc) => doc.exists)
          .map((doc) => {
                ...doc.data()!,
                'id': doc.id,
              })
          .toList();

      // Add creator names to the trips.
      for (var trip in loadedTrips) {
        if (trip['created_by'] != null) {
          trip['creator_name'] = await _getCreatorName(trip['created_by']);
        }
      }

      // Update the state with the loaded trips and set isLoading to false.
      setState(() {
        trips = loadedTrips;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading trips: $e');
      setState(() => isLoading = false);
    }
  }

  // Navigates to the [CreateTripScreen] to create a new trip.
  void _onCreateTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CreateTripScreen(groupchat_id: widget.groupchatID),
      ),
    ).then((_) => _loadTrips()); // Reload trips after creating a new trip.
  }

  // Navigates to the [TripDetails] screen for the selected trip.
  void _onTripTap(String tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => TripDetails(tripId: tripId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      actions: [
        const Spacer(),
        // Button to view members of the group chat.
        SizedBox(
          child: Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(110, 158, 158, 158),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        ViewMembersScreen(groupchatID: widget.groupchatID),
                  ),
                );
              },
              icon: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : trips.isEmpty
                      ? const Center(
                          child:
                              Text('No trips yet. Create one to get started!'))
                      : Scrollbar(
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            itemCount: trips.length,
                            padding: const EdgeInsets.only(right: 12),
                            itemBuilder: (context, index) {
                              final trip = trips[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trip['name'] ?? 'Unnamed Trip',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Created by ${trip['creator_name'] ?? 'Unknown User'}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Button to view details of the trip.
                                      ElevatedButton(
                                        onPressed: () => _onTripTap(trip['id']),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('View Details'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: MainButton(
                text: 'Create Trip',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () => _onCreateTrip(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
