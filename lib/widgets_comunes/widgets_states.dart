import 'dart:collection';

import 'package:flutter/material.dart';

class WidgetsStates {
  static HashSet<StateSetter> states_list = HashSet();

  void addState(StateSetter stateSetter) {
    states_list.add(stateSetter);
  }

  set eliminarState(StateSetter stateSetter) {
    states_list.remove(stateSetter);
  }



  //Refrescar states
  updateStates() {
    for (var element in states_list) {
      element(() {});
    }
  }

  WidgetsStates();

}
