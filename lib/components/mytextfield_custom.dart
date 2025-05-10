import 'package:flutter/material.dart';

class MytextfieldCustom extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText; //hide text?
  final iconch;
  final FormFieldValidator<String>? validator;

  const MytextfieldCustom({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.iconch, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            errorStyle: TextStyle(color: Colors.redAccent),
            // icon: IconButton(onPressed: onPressed, icon: icon)
            labelText: labelText,
            suffixIcon: iconch,
            
          ),
        ));
  }
}
