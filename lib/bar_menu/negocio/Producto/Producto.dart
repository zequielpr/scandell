import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scasell/MediaQuery.dart';

import '../../../Estilo/Colores.dart';
import '../../../widgets_comunes/my_Dialogues.dart';
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
  late ProductoController productoController = ProductoController(
      documentSnapshotNegocio: documentSnapshotNegocio,
      documentDeletMode: false,
      setState: setState,
      context: context,
      is_all_selected: false);

  late List<Widget> traditionalAppBar = [
    //IconButton(onPressed: () => productoController.navegarToCrearProducto(context: context), icon: const Icon(Icons.add_box_outlined)),
    _getOpcionesCrearProducto(),
    _getOpcionesAdminNegocio()
  ];

  final Icon _all_selected = const Icon(Icons.check_circle);
  final Icon _no_all_selected = const Icon(Icons.circle_outlined);

  _select_all_documets() {
    productoController.add_all_to_list_documents_para_eliminar();
    print('All selected?: ${productoController.is_all_selected}');
    //setState((){});
  }

  _unselect_documents() {
    productoController.limpiar_list_documents_para_eliminar();
  }

  _desactivar_delete_mode() {
    productoController.limpiar_list_documents_para_eliminar();
    productoController.documentDeletMode = false;
    //setState((){});
  }

_eliminar_all_doc(){

    productoController.delete_document_in_list();
  }

  String _titulo = '';
  var _mensaje = 'Eliminar documentos';
  _dialogue_actions(BuildContext context) {
    return <Widget>[
      TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: Text('Cancel')),
      TextButton(
          onPressed: () =>  _eliminar_all_doc(),
          child: Text('Eliminar'))
    ];
  }

  //Cancela el avance de eliminación
  _dialogue_action_cancelar(BuildContext context) {
    return <Widget>[
      TextButton(onPressed: () {}, child: Text('Cancel')),
    ];
  }

  late Dialogues dialogue_eliminar_products;
  late Widget bar_inidcator;

  _crear_elimination_advance_bar(BuildContext context) {
    bar_inidcator = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearPercentIndicator(
          width: Pantalla.getPorcentPanntalla(70, context, 'x'),
          lineHeight: 3,
          percent: 0.1,
          backgroundColor: Colors.grey,
          progressColor: Colores.colorPrincipal,
        )
      ],
    );

    dialogue_eliminar_products = Dialogues(
        titulo: _titulo,
        mensaje: bar_inidcator,
        actions: _dialogue_action_cancelar,
        context: context);
  }

  _mostrar_opcion_eliminar_all_docs() {
    dialogue_eliminar_products = Dialogues(
        titulo: _titulo,
        mensaje: _mensaje,
        actions: _dialogue_actions,
        context: context);

    dialogue_eliminar_products.mostrarDialog();
  }

  //Bar to indicate the elimination advance

  _get_delet_mode_app_bar() {
    return [
      IconButton(
        onPressed: () => productoController.is_all_selected
            ? _unselect_documents()
            : _select_all_documets(),
        icon: productoController.is_all_selected == true
            ? _all_selected
            : _no_all_selected,
        tooltip: 'Todos',
      ),
      IconButton(
          onPressed: () => _mostrar_opcion_eliminar_all_docs(),
          icon: Icon(Icons.delete)),
      IconButton(
          onPressed: () => _desactivar_delete_mode(), icon: Icon(Icons.close))
    ];
  }

  @override
  Widget build(BuildContext context) {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(Pantalla.getPorcentPanntalla(7, context, 'y')),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          productoController.setState = setState;
          return AppBar(
            actions: productoController.documentDeletMode
                ? _get_delet_mode_app_bar()
                : traditionalAppBar,
            title: Text(nombreNegocio),
          );
        }),
      ),
      body: Center(
        child: Container(
            margin:
                EdgeInsets.all(Pantalla.getMarginLeftRight(context: context)),
            child: Center(
              child: productoController.getProductos(mounted: mounted),
            )),
      ),
    );
  }

  _getOpcionesCrearProducto() {
    return IconButton(
        onPressed: () => productoController.scanearproducto(
            context: context, mounted: mounted),
        icon: Icon(Icons.add));

    /*return  StatefulBuilder(
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
        });*/
  }

  _getOpcionesAdminNegocio() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return PopupMenuButton<MenuOpcionesAdminNegocio>(
          // Callback that sets the selected popup menu item.
          onSelected: (MenuOpcionesAdminNegocio item) {
            setState(() {
              _selectedMenu = item.name;
            });
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<MenuOpcionesAdminNegocio>>[
                PopupMenuItem<MenuOpcionesAdminNegocio>(
                  value: MenuOpcionesAdminNegocio.CambiaNombre,
                  onTap: () async => {},
                  child: Row(
                    children: [Icon(Icons.edit), Text('Cambiar nombre')],
                  ),
                ),
                PopupMenuItem<MenuOpcionesAdminNegocio>(
                  value: MenuOpcionesAdminNegocio.Eliminar,
                  child: Row(
                    children: [Icon(Icons.delete), Text('Eliminar')],
                  ),
                  onTap: () async => {},
                )
              ]);
    });
  }
}

String _selectedMenu = '';

enum MenuOpcionesCrearProducto { scanear, addManualmente }

enum MenuOpcionesAdminNegocio { CambiaNombre, Eliminar }
