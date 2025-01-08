import 'package:flutter/material.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/trip/timeslot.dart';

class BluePrintScreen extends StatefulWidget {
  const BluePrintScreen({super.key});

  @override
  State<BluePrintScreen> createState() => _BluePrintScreenState();
}

class _BluePrintScreenState extends State<BluePrintScreen> {
  // Store multiple slots with their positions
  final List<int> timeSlotPositions = [0]; // Start with one slot at position 0

  List<String> get timeSlots {
    return List.generate(15, (i) {
      int hour = i + 8;
      String period = hour < 12 ? 'am' : 'pm';
      hour = hour > 12 ? hour - 12 : hour;
      return '${hour.toString().padLeft(2, '0')}:00$period';
    });
  }

  String getTimeRange(int index) {
    if (index >= timeSlots.length - 1) return '';
    return '${timeSlots[index]} - ${timeSlots[index + 1]}';
  }

  Widget _buildDraggableTimeSlot(int index, int slotId) {
    return Draggable<Map<String, int>>(
      data: {'slotId': slotId, 'position': index},
      feedback: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          color: Colors.transparent,
          child: TimeSlot(
            text: 'Basic Mathematics',
            time: getTimeRange(index),
          ),
        ),
      ),
      childWhenDragging: const SizedBox(
        height: 100,
      ),
      child: TimeSlot(
        text: 'Basic Mathematics',
        time: getTimeRange(index),
      ),
    );
  }

  void _addNewTimeSlot() {
    setState(() {
      // Find the first available time slot that's not occupied
      for (int i = 0; i < timeSlots.length; i++) {
        if (!timeSlotPositions.contains(i)) {
          timeSlotPositions.add(i);
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTimeSlot,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          return DragTarget<Map<String, int>>(
            onAcceptWithDetails: (details) {
              setState(() {
                int slotId = details.data['slotId']!;
                int oldIndex = timeSlotPositions[slotId];
                // Update the position of the dragged slot
                timeSlotPositions[slotId] = index;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeSlots[index],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...timeSlotPositions.asMap().entries
                    .where((entry) => entry.value == index)
                    .map((entry) => _buildDraggableTimeSlot(index, entry.key)),
                  if (candidateData.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.blue,
                    ),
                  if (candidateData.isEmpty && !timeSlotPositions.contains(index))
                    const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }
}