import 'package:flutter/material.dart';

class DislikesScreen extends StatefulWidget {
  const DislikesScreen({super.key});

  @override
  State<DislikesScreen> createState() {
    return _DislikesScreenState();
  }
}

class _DislikesScreenState extends State<DislikesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(110, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/left-arrow.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Text('hello'),
    );
  }
}
