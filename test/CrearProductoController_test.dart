import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scasell/bar_menu/negocio/Producto/crear_producto/crear_productos_controllers/CrearProductoController.dart';
import 'package:scasell/db/db.dart';

void main() {
  test('Counter value should be incremented', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    CollectionReference collectionReferenceProductos = FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc('id')
        .collection('negocios')
        .doc('Djpz8JrEcOzNiZ0toVGB')
        .collection('productos');

    var datosProductos = {
      'nombre_producto': 'nombre',
      'precio_compra': '200',
      'precio_venta': '300',
      'stock': '300',
    };

    DB.crearProducto(
        collectionReferenceProductos: collectionReferenceProductos,
        datosProducto: datosProductos, idCodigoBarra: '');
    for (int i = 0; i < 1000; i++) {

    }
  });
}
