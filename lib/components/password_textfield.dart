import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController pswdcontroller;
  final String labeltext;
  final color;
  final validator;
  const PasswordField(
      {super.key,
      required this.pswdcontroller,
      required this.labeltext,
      this.color, this.validator});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // Track whether password is visible
  bool _isPasswordVisible = false;
  // final TextEditingController pswdcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: widget.pswdcontroller,
        validator: widget.validator,
        obscureText: !_isPasswordVisible, // Hide or show password text
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade400,
          filled: true,
          labelText: widget.labeltext,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: widget.color,
            ),
            onPressed: () {
              // Toggle the state on button press
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
