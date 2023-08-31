import 'package:flutter/material.dart';

import '../MediaQuery.dart';

class Dialogues {
  var _actions;
  String _titulo;
  var _mensaje;
  BuildContext _context;
  late StateSetter _stateSetter;

  get actions => _actions;

  set actions(value) {
    _actions = value;
  }

  Dialogues(
      {required String titulo,
      required var mensaje,
      required var actions,
      required BuildContext context})
      : _titulo = titulo,
        _mensaje = mensaje,
        _actions = actions,
        _context = context;

  mostrarDialog() {
    showDialog<String>(
      context: _context,
      builder: (BuildContext context_d_bld) => StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
        _stateSetter = stateSetter;
        return AlertDialog(
          titlePadding: EdgeInsets.only(
              left: Pantalla.getPorcentPanntalla(3, context, 'x'),
              top: Pantalla.getPorcentPanntalla(3, context, 'x'),
              bottom: Pantalla.getPorcentPanntalla(1, context, 'x')),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          buttonPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.only(
              top: Pantalla.getPorcentPanntalla(0, context, 'x')),
          contentPadding: EdgeInsets.only(
              left: Pantalla.getPorcentPanntalla(3, context, 'x'),
              right: Pantalla.getPorcentPanntalla(3, context, 'x')),
          title: Text(_titulo, textAlign: TextAlign.center),
          content: _mensaje.runtimeType == String
              ? Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                )
              : _mensaje,
          actions: _actions(context_d_bld),
        );
      }),
    );
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  get mensaje => _mensaje;

  set mensaje(value) {
    _mensaje = value;
  }

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  StateSetter get stateSetter => _stateSetter;

  set stateSetter(StateSetter value) {
    _stateSetter = value;
  }

  update_state() {
    _stateSetter(() {});
  }
}
