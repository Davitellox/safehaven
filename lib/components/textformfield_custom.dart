import 'package:flutter/material.dart';

class TextformfieldCustom extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText; //hide text?
  final iconch;
  final prefix_icon;
  final validator;
  final keyboardtype;
  final iconcolor;
  final padding_double;
  const TextformfieldCustom({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.iconch,
    required this.validator,
    this.keyboardtype,
    this.iconcolor, required this.padding_double, this.prefix_icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(horizontal: padding_double),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardtype,
          validator: validator,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade400,
              filled: true,
              // icon: IconButton(onPressed: onPressed, icon: icon)
              labelText: labelText,
              suffixIcon: iconch,
              prefixIcon: prefix_icon,
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12)),
        ));
  }
}
