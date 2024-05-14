import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  const MyTextField({
    required this.controller,
    required this.hint,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 192, 190, 190)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 192, 190, 190)),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        filled: true,
      ),
    );
  }
}
