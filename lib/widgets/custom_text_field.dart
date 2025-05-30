import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? icon;
  final String? Function(String?)? validator;  

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.validator,  // <-- agregado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(  // <-- cambiado TextField por TextFormField
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,  // <-- agregado
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF2E7D32)) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF4CAF50)), 
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)), 
      ),
    );
  }
}
