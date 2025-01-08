import 'package:flutter/material.dart';
import 'package:planit/widgets/scaffold_layout.dart';

class BluePrintScreen extends StatefulWidget {
  const BluePrintScreen({super.key});

  @override
  State<BluePrintScreen> createState() {
    return _BluePrintScreenState();
  }
}

class _BluePrintScreenState extends State<BluePrintScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldLayout(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    ));
  }
}
