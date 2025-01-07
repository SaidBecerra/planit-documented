import 'package:flutter/material.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      bottomNavigationBar: const CustomNavigatonBar(currentIndex: 0),
      body: const Center(
        child: Text('hello'),
      ),
    );
  }
}
