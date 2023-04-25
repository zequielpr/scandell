import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../db/db.dart';

class CrearProductoController {
  CollectionReference _colleccionReferenceProductos;
  String? _idCodigoBarra;

  CrearProductoController(
      {required CollectionReference<Object?> colleccionReferenceProductos, required String? idCodigoBarra})
      : _colleccionReferenceProductos = colleccionReferenceProductos, _idCodigoBarra = idCodigoBarra;

  crearProducto({required Map<String, dynamic> datosProducto}) {
    DB.crearProducto(
        collectionReferenceProductos: _colleccionReferenceProductos,
        datosProducto: datosProducto, idCodigoBarra: _idCodigoBarra);
  }
}
