import 'package:flutter/material.dart';

class OurTheme {
  Color _spaceCadet = Color(0XFF2B3A67);
  Color _electricBlue = Color(0XFF496A81);
  //Color _cadetBlue = Color(0XFF66999B);
  Color _sage = Color(0XFFB3AF8F);
  Color _apricot = Color(0XFFFFC482);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: Colors.amber[50],
      primaryColor: Colors.red[300],
      focusColor: _apricot,
      secondaryHeaderColor: _spaceCadet,
      hintColor: _electricBlue,
      textTheme: TextTheme(
          headline6: TextStyle(
        color: Colors.black,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onSurface: _apricot,
          primary: Colors.red[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minimumSize: Size(150, 50),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: _electricBlue),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: _sage))),
    );
  }
}
