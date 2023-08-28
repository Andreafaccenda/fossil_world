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
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromRGBO(210, 180, 140, 1),
      ),
    ),
  );
}

Widget cardButtons(IconData iconData, String label) {
  return SizedBox(
    width: 70,
    child: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          minimumSize: Size.zero,
          backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        ),
        child: Row(
          children: [
            Icon(iconData, size: 16),
            const SizedBox(width: 2),
            Text(label)
          ],
        ),
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

const String apiKey = "Your key";

const Color primaryColor = Color(0xFF006491);
const Color textColorLightTheme = Color(0xFF0D0D0E);

const Color secondaryColor80LightTheme = Color(0xFF202225);
const Color secondaryColor60LightTheme = Color(0xFF313336);
const Color secondaryColor40LightTheme = Color(0xFF585858);
const Color secondaryColor20LightTheme = Color(0xFF787F84);
const Color secondaryColor10LightTheme = Color(0xFFEEEEEE);
const Color secondaryColor5LightTheme = Color(0xFFF8F8F8);
const defaultPadding = 16.0;
const Color primary = Color(0xFF1FCC79);
const Color Secondary = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color form = Color(0xFFFFFFFF);
Color? grey300 = Colors.grey[300];
Color? black54 = Colors.black54;

