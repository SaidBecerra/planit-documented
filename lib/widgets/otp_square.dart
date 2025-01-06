import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpSquare extends StatelessWidget {
  const OtpSquare({
    super.key,
    required this.inputFormatters,
  });
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.15;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(138, 158, 158, 158),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFA294F9), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
