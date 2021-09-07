import 'package:flutter/material.dart';

class OurTheme {
  Color _spaceCadet = Color(0XFF2B3A67);
  Color _electricBlue = Color(0XFF496A81);
  //Color _cadetBlue = Color(0XFF66999B);
  Color _sage = Color(0XFFB3AF8F);
  Color _apricot = Color(0XFFFFC482);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: _electricBlue,
      primaryColor: _sage,
      accentColor: _apricot,
      secondaryHeaderColor: _spaceCadet,
      hintColor: _electricBlue,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: _sage,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minimumSize: Size(150, 50),
        ),
      ),
    );
  }
}
