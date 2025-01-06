import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpSquare  extends StatelessWidget{
  const OtpSquare({
    super.key,
    required this.inputFormatters,
  });
  final List<TextInputFormatter>? inputFormatters;

@override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.25  ,
      width: MediaQuery.of(context).size.width * 0.14,
      child: TextFormField(
      decoration: InputDecoration(
        hintText: "0",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding:
          EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters,
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