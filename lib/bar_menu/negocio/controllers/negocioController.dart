import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scasell/db/db.dart';
import 'package:scasell/rutas/Rutas.gr.dart';

import '../../../MediaQuery.dart';
import '../../../widgets_comunes/ShowModal.dart';

class NegocioController {
  String _idUsuario;
  NegocioController(
    this._idUsuario,
  );

  get getIdUsuario => _idUsuario;
  set setIdUsuario(String idUsuario) => _idUsuario;

  static getNombreNegocio({required DocumentSnapshot documentSnapshotNegocio}) {
    Map<String, dynamic> data =
        documentSnapshotNegocio.data()! as Map<String, dynamic>;

    return data['nombre'];
  }

  Future<void> crearNegocio(
      {required String nombre,
      required String direccion,
      required comprobarDatos,
      required BuildContext context}) async {
    var resultado = _comprobarDatosNegocio(
        nombre: nombre, direccion: direccion, comprobarDatos: comprobarDatos);

    if (resultado == 0) {
      Navigator.pop(context);
      await DB.crearNegocio(
          nombre: nombre, idUsuario: _idUsuario, direccion: direccion);
    }
  }

  //Comprueba que los textfield no estén vacios
  int _comprobarDatosNegocio(
      {required String nombre,
      required String direccion,
      required comprobarDatos}) {
    int resultado = 0;

    if (nombre.isEmpty) {
      resultado = 1;
    } else if (direccion.isEmpty) {
      resultado = 2;
    }
    comprobarDatos(resultado);
    return resultado;
  }

  Future<void> _navegarHaciaListaProductos(
      {required BuildContext context,
      required DocumentSnapshot documentNegocio}) async {
    await context.router
        .push(ProductoRouter(documentoNegocio: documentNegocio));
  }

  ///Devuelve una lista con los documentos de todos los negocios contenido en la colección del usuario actual
  StreamBuilder<QuerySnapshot<Object?>> listarNegocio(
      {required ButtonStyle buttonStyle,
      required Widget vistaCrearNegocio,
      required BuildContext context}) {
    var _listaNegocio = DB.listarNegocios(idUsuario: _idUsuario);

    return StreamBuilder<QuerySnapshot>(
      stream: _listaNegocio,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot!.data?.size != 0) {
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                onTap: () {
                  _navegarHaciaListaProductos(
                    context: context,
                    documentNegocio: document,
                  );
                },
                leading: const Icon(
                  Icons.storefront,
                  size: 30,
                ),
                title: Text(
                  data['nombre'],
                  style: TextStyle(fontSize: 25),
                ),
                subtitle: Text(data['direccion']),
              );
            }).toList(),
          );
        }

        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: buttonStyle,
                    onPressed: () =>
                        ShowModal(vistaCrearNegocio).getShowModla(context),
                    child: Icon(Icons.add_business_rounded,
                        color: Colors.black,
                        size: Pantalla.getPorcentPanntalla(
                            20.0 as double, context, 'x'))),
                DB.redData()
              ],
            ),
          ),
        );
      },
    );
  }
}
