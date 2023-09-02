import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../db/db.dart';

class CrearProductoController {
  var _colleccionReferenceProductos;
  String? _idCodigoBarra;
  BuildContext _context;
  static int _campoEmty = 0;
  static int _isNonum = 0;
  var _setState;
  static double precio_compra = 0;
  static double precio_venta = 0;
  static double stock = 0;

  CrearProductoController(
      {required CollectionReference<Object?> colleccionReferenceProductos,
      required String? idCodigoBarra,
      required setState,
      required BuildContext context})
      : _colleccionReferenceProductos = colleccionReferenceProductos,
        _idCodigoBarra = idCodigoBarra,
        _setState = setState,
        _context = context;

  //Para ser utilizado en tests

  crearProducto({required Map<String, dynamic> datosProducto}) async {
    _comprobarDatos(datosProducto: datosProducto);

    if (_campoEmty == 0 && _isNonum == 0) {
      datosProducto['precio_compra'] = precio_compra;
      datosProducto['precio_venta'] = precio_venta;
      datosProducto['stock'] = stock;

      for (int i = 0; i < 500; i++) {
        await DB.crearProducto(
            collectionReferenceProductos: _colleccionReferenceProductos,
            datosProducto: datosProducto,
            idCodigoBarra: _idCodigoBarra);
        print('object $i');
      }
      _context.router.navigateBack();
    }
    print('Campo vacío: $_campoEmty \n como no numero: $_isNonum');
  }

  _comprobarDatos({required Map<String, dynamic> datosProducto}) {
    _campoEmty = 0;
    _isNonum = 0;
    _setState(() {});
    if (datosProducto['nombre_producto'].isEmpty) {
      _campoEmty = 1;
      _setState(() {});
      return;
    } else if (datosProducto['precio_compra'].isEmpty) {
      _campoEmty = 2;
      _setState(() {});
      return;
    } else if (datosProducto['precio_venta'].isEmpty) {
      _campoEmty = 3;
      _setState(() {});
      return;
    } else if (datosProducto['stock'].isEmpty) {
      _campoEmty = 4;
      _setState(() {});
      return;
    }

    try {
      precio_compra = double.parse(datosProducto['precio_compra']);
    } catch (e) {
      print('error: ${e}');
      _isNonum = 2;
      _setState(() {});
      return;
    }

    try {
      precio_venta = double.parse(datosProducto['precio_venta']);
    } catch (e) {
      _isNonum = 3;
      _setState(() {});
      return;
    }

    try {
      stock = double.parse(datosProducto['stock']);
    } catch (e) {
      _isNonum = 4;
      _setState(() {});
      return;
    }
  }

  Widget mostrarError({required int campo}) {
    switch (_campoEmty) {
      case 1:
        if (campo == _campoEmty) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un nombre',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;
      case 2:
        if (campo == _campoEmty) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un precio de compra',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;

      case 3:
        if (campo == _campoEmty) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un precio de venta',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;

      case 4:
        if (campo == _campoEmty) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un stock',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;
      default:
        break;
    }

    switch (_isNonum) {
      case 2:
        if (campo == _isNonum) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un numero',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;
      case 3:
        if (campo == _isNonum) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un numero',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;
      case 4:
        if (campo == _isNonum) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'introduce un numero',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          );
        }
        break;
      default:
        break;
    }

    return const Text('');
  }

  //Actualizar datos del producto
  actualizardatos({required Map<String, dynamic> datosProducto}) {
    _comprobarDatos(datosProducto: datosProducto);

    if (_campoEmty == 0 && _isNonum == 0) {
      datosProducto['precio_compra'] = precio_compra;
      datosProducto['precio_venta'] = precio_venta;
      datosProducto['stock'] = stock;

      DocumentReference documentProduct =
          _colleccionReferenceProductos.doc(_idCodigoBarra);
      DB
          .update(document: documentProduct, datos: datosProducto)
          .whenComplete(() => _context.router.navigateBack());
    }
    print('Campo vacío: $_campoEmty \n como no numero: $_isNonum');
  }
}
