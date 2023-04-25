import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controllers/negocioController.dart';
import 'controllers/ProductoController.dart';

class Producto extends StatefulWidget {
  final DocumentSnapshot documentoNegocio;
  const Producto({Key? key, required this.documentoNegocio}) : super(key: key);

  @override
  State<Producto> createState() => _ProductoState(documentoNegocio);
}

class _ProductoState extends State<Producto> {
  DocumentSnapshot<Object?> documentSnapshotNegocio;
  _ProductoState(this.documentSnapshotNegocio);

  late String nombreNegocio = NegocioController.getNombreNegocio(
      documentSnapshotNegocio: documentSnapshotNegocio);
  late ProductoController productoController =
      ProductoController(documentSnapshotNegocio: documentSnapshotNegocio);

  @override
  Widget build(BuildContext context) {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0

    return Scaffold(
      appBar: AppBar(
        actions: [
          //IconButton(onPressed: () => productoController.navegarToCrearProducto(context: context), icon: const Icon(Icons.add_box_outlined)),
          _getOpcionesCrearProducto(),
          _getOpcionesAdminNegocio()
        ],
        title: Text(nombreNegocio),
      ),
      body: Center(
        child: Container(
            child: Center(
          child: productoController.getListaProductos(context: context),
        )),
      ),
    );
  }


  _getOpcionesCrearProducto(){
    return  StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return PopupMenuButton<MenuOpcionesCrearProducto>(
            child: Icon(Icons.add_box_outlined),
            // Callback that sets the selected popup menu item.
              onSelected: (MenuOpcionesCrearProducto item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOpcionesCrearProducto>>[
                PopupMenuItem<MenuOpcionesCrearProducto>(
                  value: MenuOpcionesCrearProducto.scanear,
                  onTap: () async => productoController.scanearproducto(context: context, mounted: mounted),
                  child: Row(children: [Icon(Icons.camera_alt_outlined),Text('scanear')],),
                ),
                PopupMenuItem<MenuOpcionesCrearProducto>(
                  value: MenuOpcionesCrearProducto.addManualmente,
                  child: Row(children: [Icon(Icons.add_box_outlined),Text('Añadir manualmente')],),
                  onTap: () => productoController.navegarToCrearProducto(context: context),
                )
              ]);
        });
  }


  _getOpcionesAdminNegocio(){
    return  StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return PopupMenuButton<MenuOpcionesAdminNegocio>(
              // Callback that sets the selected popup menu item.
              onSelected: (MenuOpcionesAdminNegocio item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOpcionesAdminNegocio>>[
                PopupMenuItem<MenuOpcionesAdminNegocio>(
                  value:MenuOpcionesAdminNegocio.CambiaNombre,
                  onTap: () async => {},
                  child: Row(children: [Icon(Icons.edit),Text('Cambiar nombre')],),
                ),
                PopupMenuItem<MenuOpcionesAdminNegocio>(
                  value:MenuOpcionesAdminNegocio.Eliminar,
                  child: Row(children: [Icon(Icons.delete),Text('Eliminar')],),
                  onTap: () async => {},
                )
              ]);
        });
  }


}
String _selectedMenu = '';

enum MenuOpcionesCrearProducto { scanear, addManualmente}
enum MenuOpcionesAdminNegocio { CambiaNombre, Eliminar }
