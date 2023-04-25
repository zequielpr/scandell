import 'package:flutter/material.dart';

import 'Colores.dart';

class Stilos {
  static ThemeData themeData = ThemeData(
      primaryColor: Colores.colorPrincipal,
      appBarTheme: _getAppBarTheme() );


 static AppBarTheme _getAppBarTheme(){
    return const AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }
}
