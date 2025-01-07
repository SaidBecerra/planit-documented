import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit/widgets/NewGroupChatBottomSheet.dart';
import 'package:planit/widgets/homepage/home_screen.dart';
import 'package:planit/widgets/homepage/profile_screen.dart';

class CustomNavigatonBar extends StatefulWidget {
  const CustomNavigatonBar({required this.currentIndex, super.key});

  final int currentIndex;

  @override
  State<CustomNavigatonBar> createState() {
    return _CustomNavigationBarState();
  }
}

class _CustomNavigationBarState extends State<CustomNavigatonBar> {
  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const NewGroupChatBottomSheet(),
    );
  }

  void _onHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _onProfile(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const ProfileScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/home.png',
                      color:
                          widget.currentIndex == 0 ? Colors.black : Colors.grey,
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () => setState(() => _onHome(context)),
                  ),
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
                          const Icon(Icons.add, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
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
                  IconButton(
                    icon: Image.asset(
                      'assets/images/user.png',
                      color:
                          widget.currentIndex == 1 ? Colors.black : Colors.grey,
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () => setState(() => _onProfile(context)),
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
