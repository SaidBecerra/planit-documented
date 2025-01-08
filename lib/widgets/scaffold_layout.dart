import 'package:flutter/material.dart';

class ScaffoldLayout extends StatelessWidget{
  const ScaffoldLayout({
    this.backgroundColor,
    this.floatingActionButton,
    required this.body,
    super.key
  });
  final Widget body;
  final Color? backgroundColor;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
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
            icon: Image.asset(
              'assets/images/left-arrow.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: body,
    );
  }
}