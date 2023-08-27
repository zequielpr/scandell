import 'package:flutter/material.dart';

import '../MediaQuery.dart';
import 'Colores.dart';

class Stilos {
  static ThemeData themeData = ThemeData(
    primaryColor: Colores.colorPrincipal,
    appBarTheme: _getAppBarTheme(),
    elevatedButtonTheme: getElevatedButtonTheme(),
  );





  
  static ElevatedButtonThemeData getElevatedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          maximumSize: MaterialStateProperty.all(Size.fromWidth(300)),
            backgroundColor:
            MaterialStateProperty.all(Colores.colorPrincipal)));
  }

  static AppBarTheme _getAppBarTheme() {
    return const AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  static Container darSizeButton({required BuildContext context, required ElevatedButton button}){
    return Container(
      width: Pantalla.getPorcentPanntalla(100, context, 'x'),
      height: Pantalla.getPorcentPanntalla(7, context, 'y'),
      child: button,
    );
  }

}
