import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  TextInputAction textInputAction = TextInputAction.next,
  bool obscureText = false,
  bool isPasswordField = false,
  String? helperText,
  TextStyle? helperStyle,
  VoidCallback? onVisibilityToggle
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    textInputAction: textInputAction,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        suffixIcon: isPasswordField ? IconButton(
            icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility
            ),
            onPressed: onVisibilityToggle
        ) : null,
        helperText: helperText,
        helperStyle: helperStyle
    ),
  );
}