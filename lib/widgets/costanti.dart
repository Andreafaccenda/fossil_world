import 'package:flutter/material.dart';

InputDecoration formDecoration(String labelText,IconData iconData) {
  return InputDecoration(
    errorStyle: const TextStyle(fontSize: 10),
    prefixIcon: Icon(
      iconData,
      color: Color.fromRGBO(210, 180, 140, 1),
    ),
    errorMaxLines: 3,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromRGBO(210, 180, 140, 1),
      ),
    ),
  );
}
const TextStyle style16Orange = TextStyle(
  color: Colors.orange,
  fontSize: 16,);

const TextStyle style16White = TextStyle(
  color: Colors.white,
  fontSize: 16,);

const TextStyle style16Black = TextStyle(
  color: Colors.black,
  fontSize: 16,);
