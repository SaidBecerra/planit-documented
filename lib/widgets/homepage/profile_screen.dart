import 'package:flutter/material.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      bottomNavigationBar: const CustomNavigatonBar(currentIndex: 1),
      body: const Center(
        child: Text('hello'),
      ),
    );
  }
}
