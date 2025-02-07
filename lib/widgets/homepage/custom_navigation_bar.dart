import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/NewGroupChatBottomSheet.dart';
import 'package:planit/widgets/homepage/home_screen.dart';
import 'package:planit/widgets/homepage/profile_screen.dart';

/// A custom bottom navigation bar that allows users to switch between
/// the Home and Profile screens, and to create a new group chat.
/// 
/// The navigation bar displays three elements:
/// - A Home icon that shows the HomeScreen when selected.
/// - A button labeled "New GroupChat" that opens a modal bottom sheet with chat options.
/// - A User icon that shows the ProfileScreen when selected.
class CustomNavigatonBar extends StatefulWidget {
  const CustomNavigatonBar({super.key});

  @override
  State<CustomNavigatonBar> createState() {
    return _CustomNavigationBarState();
  }
}

class _CustomNavigationBarState extends State<CustomNavigatonBar> {
  // Tracks the currently selected index of the navigation bar.
  // 0 corresponds to the HomeScreen, 1 corresponds to the ProfileScreen.
  int currentIndex = 0;

  /// Shows a modal bottom sheet with options to create a new group chat.
  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Makes the modal background transparent.
      builder: (context) => const NewGroupChatBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a dynamic title based on the selected index.
      appBar: AppBar(
        title: Text(currentIndex == 0 ? 'Home' : 'Profile'),
        leading: null,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
      ),
      // Bottom navigation bar container with a top border.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(124, 212, 212, 212),
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          // Padding at the bottom to provide extra spacing.
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container for the row of navigation icons and the new chat button.
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Home icon button.
                    IconButton(
                      icon: Image.asset(
                        'assets/images/home.png',
                        color: currentIndex == 0 ? Colors.black : Colors.grey,
                        height: 24,
                        width: 24,
                      ),
                      // Update currentIndex to 0 when pressed (show HomeScreen).
                      onPressed: () => setState(() => currentIndex = 0),
                    ),
                    // New GroupChat button with a gesture detector.
                    GestureDetector(
                      onTap: _showNewChatOptions,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Plus icon for adding a new group chat.
                            const Icon(Icons.add,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            // Text label for the new group chat button.
                            Text(
                              'New GroupChat',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // User/Profile icon button.
                    IconButton(
                      icon: Image.asset(
                        'assets/images/user.png',
                        color: currentIndex == 1 ? Colors.black : Colors.grey,
                        height: 24,
                        width: 24,
                      ),
                      // Update currentIndex to 1 when pressed (show ProfileScreen).
                      onPressed: () => setState(() => currentIndex = 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Display either the HomeScreen or the ProfileScreen based on currentIndex.
      body: currentIndex == 0 ? const HomeScreen() : const ProfileScreen(),
    );
  }
}
