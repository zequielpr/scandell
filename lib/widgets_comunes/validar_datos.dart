class ValidarDatos{
  static bool validarNombre(String nombre){
    return RegExp(r"^[A-Za-z\u00C0-\u017F]{3,30}(?:[\s][A-Za-z\u00C0-\u017F]+)*([\s]?)$").hasMatch(nombre);
  }
}