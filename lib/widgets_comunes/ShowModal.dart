import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowModal {
  Widget _cuerpo;
  ShowModal(this._cuerpo);

  getShowModla(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _cuerpo,
            ));
  }
}
