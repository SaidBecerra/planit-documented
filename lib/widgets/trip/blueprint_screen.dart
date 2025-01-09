import 'package:flutter/material.dart';
import 'package:planit/widgets/main_button.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/timeslot.dart';
import 'package:planit/widgets/trip/trip_list_screen.dart';

enum ActivityType { food, activity }

class Activity {
  final String name;
  final IconData icon;
  final ActivityType type;
  final Color color;

  const Activity({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
  });
}

class TimeSlotData {
  int position;
  Activity activity;

  TimeSlotData({
    required this.position,
    required this.activity,
  });
}

class BluePrintScreen extends StatefulWidget {
  const BluePrintScreen({super.key});

  @override
  State<BluePrintScreen> createState() => _BluePrintScreenState();
}

class _BluePrintScreenState extends State<BluePrintScreen> {
  final List<TimeSlotData> slots = [];
  bool _isDragging = false;

  final List<Activity> timeslotTypes = [
    const Activity(
      name: 'Food',
      icon: Icons.restaurant,
      type: ActivityType.food,
      color: Colors.orange,
    ),
    const Activity(
      name: 'Activity',
      icon: Icons.local_activity,
      type: ActivityType.activity,
      color: Colors.blue,
    ),
  ];

  List<String> get timeSlots => List.generate(24, (i) {
        return '${i.toString().padLeft(2, '0')}:00';
      });

  String _getTimeRange(int index) => index < timeSlots.length - 1
      ? '${timeSlots[index]} - ${timeSlots[index + 1]}'
      : '${timeSlots[index]} - 00:00';

  void _handleDrop(int newPosition, TimeSlotData slot) {
    setState(() => slot.position = newPosition);
  }

  void _deleteSlot(TimeSlotData slot) {
    setState(() {
      slots.remove(slot);
    });
  }

  void _setDragging(bool isDragging) {
    setState(() {
      _isDragging = isDragging;
    });
  }

  Future<void> _showTimeslotPicker() async {
    final activity = await showModalBottomSheet<Activity>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Timeslot',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: timeslotTypes
                    .map((type) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () => Navigator.pop(context, type),
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                decoration: BoxDecoration(
                                  color: type.type == ActivityType.food
                                      ? const Color(0xFFE5DDDA)
                                      : const Color(0xFFE1E6F0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type.type == ActivityType.food
                                          ? Icons.restaurant_menu
                                          : Icons.local_activity,
                                      size: 32,
                                      color: type.type == ActivityType.food
                                          ? Colors.orange
                                          : Colors.blue,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      type.name,
                                      style: TextStyle(
                                        color: type.type == ActivityType.food
                                            ? Colors.orange
                                            : Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

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

    void _onTripList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const TripListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) => TimeSlotPosition(
                    index: index,
                    timeSlot: timeSlots[index],
                    occupyingSlots: slots.where((s) => s.position == index).toList(),
                    onAccept: (slot) => _handleDrop(index, slot),
                    getTimeRange: _getTimeRange,
                    onDragStarted: () => _setDragging(true),
                    onDragEnded: () => _setDragging(false),
                  ),
                ),
                if (_isDragging)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: DragTarget<TimeSlotData>(
                        onAcceptWithDetails: (details) => _deleteSlot(details.data),
                        builder: (context, candidateData, rejectedData) => Container(
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
                    onTap: () => _onTripList(context),
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

  Widget _buildDraggableTimeSlot(BuildContext context, TimeSlotData slot) {
    return Draggable<TimeSlotData>(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<TimeSlotData>(
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeSlot,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          ...occupyingSlots
              .map((slot) => _buildDraggableTimeSlot(context, slot)),
          if (candidateData.isNotEmpty)
            Container(
              width: double.infinity,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.blue,
            ),
          if (candidateData.isEmpty && occupyingSlots.isEmpty)
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}