// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/timeslot.dart';
import 'package:planit/widgets/trip/trip_list_screen.dart';

// Defines the possible types of activities that can be scheduled
enum ActivityType { food, activity }

// Represents an individual activity with its properties
class Activity {
  final String name;
  final ActivityType type;

  const Activity({
    required this.name,
    required this.type,
  });

  // Converts Activity object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toString(),
    };
  }

  // Creates an Activity object from a Firestore map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      name: map['name'],
      type: ActivityType.values.firstWhere((e) => e.toString() == map['type'],
          orElse: () => ActivityType.activity),
    );
  }

  // Gets the appropriate icon based on activity type
  IconData get icon =>
      type == ActivityType.food ? Icons.restaurant : Icons.local_activity;

  // Gets the appropriate color based on activity type
  Color get color => type == ActivityType.food ? Colors.orange : Colors.blue;
}

// Represents a scheduled activity with its position in the timeline
class TimeSlotData {
  int position;
  Activity activity;

  TimeSlotData({
    required this.position,
    required this.activity,
  });

  // Converts TimeSlotData object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'activity': activity.toMap(),
    };
  }

  // Creates a TimeSlotData object from a Firestore map
  factory TimeSlotData.fromMap(Map<String, dynamic> map) {
    return TimeSlotData(
      position: map['position'],
      activity: Activity.fromMap(map['activity']),
    );
  }
}

// Main screen widget for creating and editing trip blueprints
class BluePrintScreen extends StatefulWidget {
  const BluePrintScreen({
    required this.tripId,
    super.key,
  });

  final String tripId;

  @override
  State<BluePrintScreen> createState() => _BluePrintScreenState();
}

class _BluePrintScreenState extends State<BluePrintScreen> {
  final List<TimeSlotData> slots = []; // Stores all scheduled time slots
  bool _isDragging = false; // Tracks if a time slot is being dragged

  // Predefined activity types available for selection
  final List<Activity> timeslotTypes = [
    const Activity(
      name: 'Food',
      type: ActivityType.food,
    ),
    const Activity(
      name: 'Activity',
      type: ActivityType.activity,
    ),
  ];

  // Generates a list of time slots for 24 hours
  List<String> get timeSlots => List.generate(24, (i) {
        return '${i.toString().padLeft(2, '0')}:00';
      });

  // Gets the time range string for a given index
  String _getTimeRange(int index) => index < timeSlots.length - 1
      ? '${timeSlots[index]} - ${timeSlots[index + 1]}'
      : '${timeSlots[index]} - 00:00';

  // Updates the position of a dragged time slot
  void _handleDrop(int newPosition, TimeSlotData slot) {
    setState(() => slot.position = newPosition);
  }

  // Removes a time slot from the schedule
  void _deleteSlot(TimeSlotData slot) {
    setState(() => slots.remove(slot));
  }

  // Updates the dragging state
  void _setDragging(bool isDragging) {
    setState(() => _isDragging = isDragging);
  }

  // Shows bottom sheet for selecting activity type
  Future<void> _showTimeslotPicker() async {
    final activity = await showModalBottomSheet<Activity>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Timeslot',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: timeslotTypes
                    .map((type) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () => Navigator.pop(context, type),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  children: [
                                    Icon(type.icon,
                                        size: 32, color: type.color),
                                    const SizedBox(height: 8),
                                    Text(type.name),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );

    // Add new time slot if activity was selected
    if (activity != null) {
      setState(() {
        final availablePosition = List.generate(timeSlots.length, (i) => i)
            .firstWhere((i) => !slots.any((slot) => slot.position == i));
        slots.add(TimeSlotData(
          position: availablePosition,
          activity: activity,
        ));
      });
    }
  }

  // Saves blueprint to Firestore and navigates to trip list screen
  Future<void> _onTripList() async {
    try {
      if (slots.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('trips')
            .doc(widget.tripId)
            .update({
          'blueprint': slots.map((slot) => slot.toMap()).toList(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TripListScreen(
                    tripId: widget.tripId,
                    index: 0,
                  )),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving blueprint: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Column(
        children: [
          // Main time slot list with drag and drop functionality
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) => TimeSlotPosition(
                    index: index,
                    timeSlot: timeSlots[index],
                    occupyingSlots:
                        slots.where((s) => s.position == index).toList(),
                    onAccept: (slot) => _handleDrop(index, slot),
                    getTimeRange: _getTimeRange,
                    onDragStarted: () => _setDragging(true),
                    onDragEnded: () => _setDragging(false),
                  ),
                ),
                // Delete target that appears when dragging
                if (_isDragging)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: DragTarget<TimeSlotData>(
                        onAcceptWithDetails: (details) =>
                            _deleteSlot(details.data),
                        builder: (context, candidateData, rejectedData) =>
                            Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: candidateData.isEmpty
                                ? Colors.grey.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: candidateData.isEmpty ? 30 : 35,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Bottom buttons for adding slots and navigation
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: MainButton(
                    text: 'Add Time Slot',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: _showTimeslotPicker,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MainButton(
                    text: 'Next',
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    onTap: _onTripList,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying and handling drag/drop of individual time slots
class TimeSlotPosition extends StatelessWidget {
  final int index;
  final String timeSlot;
  final List<TimeSlotData> occupyingSlots;
  final Function(TimeSlotData) onAccept;
  final String Function(int) getTimeRange;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  const TimeSlotPosition({
    super.key,
    required this.index,
    required this.timeSlot,
    required this.occupyingSlots,
    required this.onAccept,
    required this.getTimeRange,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<TimeSlotData>(
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time slot label
          Text(
            timeSlot,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Draggable time slots
          ...occupyingSlots.map((slot) => Draggable<TimeSlotData>(
                data: slot,
                onDragStarted: onDragStarted,
                onDragEnd: (_) => onDragEnded(),
                onDraggableCanceled: (_, __) => onDragEnded(),
                feedback: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Material(
                    color: Colors.transparent,
                    child: TimeSlot(
                      text: slot.activity.name,
                      time: getTimeRange(index),
                      icon: slot.activity.icon,
                      color: slot.activity.color,
                    ),
                  ),
                ),
                childWhenDragging: const SizedBox(height: 100),
                child: TimeSlot(
                  text: slot.activity.name,
                  time: getTimeRange(index),
                  icon: slot.activity.icon,
                  color: slot.activity.color,
                ),
              )),
          // Drop indicator
          if (candidateData.isNotEmpty)
            Container(
              width: double.infinity,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.blue,
            ),
          // Spacing for empty slots
          if (candidateData.isEmpty && occupyingSlots.isEmpty)
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}