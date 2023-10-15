import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scasell/db/db.dart';
import 'package:scasell/rutas/Rutas.gr.dart';

import '../../../MediaQuery.dart';
import '../../../widgets_comunes/ShowModal.dart';
import '../../../widgets_comunes/my_Dialogues.dart';
import '../Producto/Producto.dart';

class NegocioController {
  String _idUsuario;
  BuildContext _context;

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  StateSetter _setterState;
  late StateSetter _lista_negocio_state;
  bool delete_mode = false;
  bool all_selected = false;
  late HashSet<DocumentSnapshot> negocios = HashSet();

  NegocioController(
    this._idUsuario, this._context, this._setterState
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
      _setterState((){});
    }
  }

  Future<void>_eliminar_negocio({required DocumentSnapshot doc_negocio, required BuildContext context_dialogue}) async{
    await doc_negocio.reference.delete().whenComplete(() => negocios.remove(doc_negocio));
    context_dialogue.router.pop();

    _lista_negocio_state((){});
    //_setterState((){});
    _context.router.pop();
  }

  getOpcionesAdminNegocio({required DocumentSnapshot doc_negocio}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return PopupMenuButton<MenuOpcionesAdminNegocio>(
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<MenuOpcionesAdminNegocio>>[
                _eliminar_option( doc_negocio: doc_negocio),
                _editar_nombre(doc_negocio:  doc_negocio)

              ]);
        });
  }

  _eliminar_option({required DocumentSnapshot doc_negocio}){
    return PopupMenuItem<MenuOpcionesAdminNegocio>(
      value: MenuOpcionesAdminNegocio.Eliminar,
      child: Row(
        children: [Icon(Icons.delete), Text('Eliminar')],
      ),
      onTap: () async => _mostrar_opcion_eliminar_negocio(doc_negocio: doc_negocio),
    );
  }
  _editar_nombre({required DocumentSnapshot doc_negocio}){
    return PopupMenuItem<MenuOpcionesAdminNegocio>(
      value: MenuOpcionesAdminNegocio.CambiaNombre,
      onTap: () => {},
      child: Row(
        children: [Icon(Icons.edit), Text('Cambiar nombre')],
      ),
    );
  }


  //Mostrar opcion para eliminar negocio.
  String _titulo = 'Eliminar negocio';
  var _mensaje = 'Al eliminar este negocio, no será posible recuperarlo';
  static late DocumentSnapshot _doc_to_elim;
  _dialogue_actions(BuildContext context) {
    return <Widget>[
      TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: Text('Cancel')),
      TextButton(
          onPressed: () => _eliminar_negocio(doc_negocio: _doc_to_elim, context_dialogue:  context), child: Text('Eliminar'))
    ];
  }

  late Dialogues dialogue_eliminar_products;
  late Widget bar_inidcator;


  _mostrar_opcion_eliminar_negocio({required DocumentSnapshot doc_negocio}) {
    _doc_to_elim = doc_negocio;
    dialogue_eliminar_products = Dialogues(
        titulo: _titulo,
        mensaje: _mensaje,
        actions: _dialogue_actions,
        context: _context);

    dialogue_eliminar_products.mostrarDialog();
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
        .push(ProductoRouter(documentoNegocio: documentNegocio, negocioController: this));
  }

  late CollectionReference _listaNegocio;
  ///Devuelve una lista con los documentos de todos los negocios contenido en la colección del usuario actual
  FutureBuilder<QuerySnapshot<Object?>> listarNegocio(
      {required ButtonStyle buttonStyle,
      required Widget vistaCrearNegocio,
      required BuildContext context}) {
    _listaNegocio = DB.listarNegocios(idUsuario: _idUsuario);

    return FutureBuilder<QuerySnapshot>(
      future: _listaNegocio.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot!.data?.size != 0) {
          negocios.clear();
          negocios.addAll(snapshot.data!.docs);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                _lista_negocio_state = setState;
                return ListView(
                  children: negocios.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return ListTile(
                      onFocusChange: (c){print('object $c');},
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
                      trailing: getOpcionesAdminNegocio(doc_negocio: document),
                    );
                  }).toList(),
                );
              }
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
                Text('Crear negocio')
              ],
            ),
          ),
        );
      },
    );
  }
}
