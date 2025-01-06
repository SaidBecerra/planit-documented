import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        destinations: [
          NavigationDestination(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  color: currentIndex == 0
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Color.fromARGB(255, 89, 88, 88),
                  size: 35,
                ),
                SizedBox(width: 8),
                Text('', style: GoogleFonts.lato(fontSize: 16)),
              ],
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Groupchat',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline_outlined,
                  color: currentIndex == 2
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Color.fromARGB(255, 89, 88, 88),
                  size: 35,
                ),
                SizedBox(width: 8),
                Text('', style: GoogleFonts.lato(fontSize: 16)),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
