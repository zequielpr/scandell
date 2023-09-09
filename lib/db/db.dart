import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../MediaQuery.dart';
import '../widgets_comunes/ShowModal.dart';

class DB {
  static final FirebaseFirestore db = FakeFirebaseFirestore();

  static Future<void> setDatosDocUsuarios({required String idUsuario}) async {
    await db
        .collection('usuarios')
        .doc(idUsuario)
        .set({'full_name': 'zequiel perez', 'email': 'ejemplo@gmail.com'});
  }

  static Future<void> crearNegocio({
    required String nombre,
    required String idUsuario,
    required String direccion,
  }) async {
    await db
        .collection('usuarios')
        .doc(idUsuario)
        .collection('negocios')
        .doc()
        .set({
      'nombre': nombre,
      'direccion': direccion,
      'fecha_creacion': DateTime.now(),
      'fecha_ultimo_add_stock': DateTime.now(),
      'url_img': ''
    });
  }

  static Future<void> setImgNegocio(
      {required String img_url,
      required String idNegocio,
      required String idUsuario}) async {
    await db
        .collection('usuarios')
        .doc(idUsuario)
        .collection('negocios')
        .doc(idNegocio)
        .set({'url_img': img_url});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listarNegocios(
      {required String idUsuario}) {
    var _listaNegocio = db
        .collection('usuarios')
        .doc(idUsuario)
        .collection('negocios')
        .snapshots(includeMetadataChanges: true);
    return _listaNegocio;
  }

  static Future<void> crearProducto(
      {required CollectionReference collectionReferenceProductos,
      required Map<String, dynamic> datosProducto,
      required String? idCodigoBarra}) async {
    await collectionReferenceProductos.doc(idCodigoBarra).set(datosProducto);
  }

  static Future<void> update(
      {required DocumentReference document,
      required Map<String, dynamic> datos}) async {
    await document.update(datos);
  }

  static Future<void> delete(
      {
      required DocumentReference document}) async {
    await document.delete();
  }

  //Solo prueba
  static redData() {
    return FutureBuilder<DocumentSnapshot>(
      future: db.collection('prueba').doc('1').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Name: ${data['nombre']}");
        }

        return Text("loading");
      },
    );
  }
}
