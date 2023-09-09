import 'dart:collection';

import 'package:flutter/material.dart';

class WidgetsStates {
  StateSetter _states;

  StateSetter get states => _states;

  set states(StateSetter value) {
    _states = value;
  }

  WidgetsStates({required var state}) : _states = state; //Refrescar states
  updateStates() {
    _states(() {});
  }
}
