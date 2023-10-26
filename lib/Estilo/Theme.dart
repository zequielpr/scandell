import 'package:flutter/material.dart';

import '../MediaQuery.dart';
import 'Colores.dart';

class Stilos {
  static ThemeData themeData = ThemeData(
      primaryColor: Colores.colorPrincipal,
      appBarTheme: _getAppBarTheme(),
      elevatedButtonTheme: getElevatedButtonTheme(),
      inputDecorationTheme: _get_text_field_decoration());

  static InputDecorationTheme _get_text_field_decoration() {
    return const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.all(10),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colores.colorPrincipal),
        ));
  }

  static ElevatedButtonThemeData getElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          maximumSize: MaterialStateProperty.all(Size.fromWidth(300)),
          backgroundColor: MaterialStateProperty.all(Colores.colorPrincipal),
          foregroundColor: MaterialStateProperty.all(Colors.black)),
    );
  }

  static AppBarTheme _getAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    );
  }

  static Container darSizeButton(
      {required BuildContext context, required ElevatedButton button}) {
    return Container(
      width: Pantalla.getPorcentPanntalla(100, context, 'x'),
      height: Pantalla.getPorcentPanntalla(7, context, 'y'),
      child: button,
    );
  }
}
