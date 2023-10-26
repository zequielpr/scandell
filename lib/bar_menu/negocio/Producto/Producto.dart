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
  final NegocioController negocioController;
  final DocumentSnapshot documentoNegocio;
  const Producto(
      {Key? key,
      required this.documentoNegocio,
      required this.negocioController})
      : super(key: key);

  @override
  State<Producto> createState() =>
      _ProductoState(documentoNegocio, negocioController);
}

class _ProductoState extends State<Producto> {
  DocumentSnapshot<Object?> documentSnapshotNegocio;
  final NegocioController negocioController;
  _ProductoState(this.documentSnapshotNegocio, this.negocioController);

  late String nombreNegocio = NegocioController.getNombreNegocio(
      documentSnapshotNegocio: documentSnapshotNegocio);
  late ProductoController productoController = ProductoController(
      documentSnapshotNegocio: documentSnapshotNegocio,
      documentDeletMode: false,
      setState_general: setState,
      context: context,
      is_all_selected: false);

  late List<Widget> traditionalAppBar = [
    //IconButton(onPressed: () => productoController.navegarToCrearProducto(context: context), icon: const Icon(Icons.add_box_outlined)),
    _getOpcionesCrearProducto(),
    negocioController.getOpcionesAdminNegocio(
        doc_negocio: documentSnapshotNegocio)
  ];

  final Icon _all_selected = const Icon(Icons.check_circle);
  final Icon _no_all_selected = const Icon(Icons.circle_outlined);

  _select_all_documets() {
    productoController.add_all_to_list_documents_para_eliminar();
    print('All selected?: ${productoController.is_all_selected}');
    //setState((){});
  }

  //para mostrar el mensaje en el contexto actual
  late BuildContext negocio_context = negocioController.context;
  initState() {
    negocio_context = negocioController.context;
    negocioController.context = context;
    super.initState();
  }

  didChangeDependencies() {
    negocioController.context = negocio_context;
    //print('data ${context.routeData.parent?.router.notifyAll(forceUrlRebuild: true)}');
  }

  _unselect_documents() {
    productoController.limpiar_list_documents_para_eliminar();
  }

  _desactivar_delete_mode() {
    productoController.limpiar_list_documents_para_eliminar();
    productoController.documentDeletMode = false;
    //setState((){});
  }

  _eliminar_all_doc(BuildContext dilague_context) async {
    await productoController.delete_document_in_list().whenComplete(() async {
      await dilague_context.router.pop();
      final snackBar = SnackBar(
        content: const Text('documentos eliminados'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => productoController.undo(),
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
          onPressed: () => _eliminar_all_doc(context), child: Text('Eliminar'))
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
      productoController.list_documents_para_eliminar.length > 0
          ? IconButton(
              onPressed: () => _mostrar_opcion_eliminar_all_docs(),
              icon: Icon(Icons.delete))
          : Text(''),
      IconButton(
          onPressed: () => _desactivar_delete_mode(), icon: Icon(Icons.close))
    ];
  }

  @override
  Widget build(BuildContext context) {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0

    return Scaffold(
      body: Center(
          child: CustomScrollView(
        slivers: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            productoController.setState = setState;
            return SliverAppBar(
              floating: true,
              expandedHeight: Pantalla.getPorcentPanntalla(15, context, 'y'),
              flexibleSpace: FlexibleSpaceBar(),
              title: Text(nombreNegocio),
              actions: productoController.documentDeletMode
                  ? _get_delet_mode_app_bar()
                  : traditionalAppBar,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    Pantalla.getPorcentPanntalla(10, context, 'y')),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: Pantalla.getPorcentPanntalla(3, context, 'y')),
                  child: TextField(
                    onChanged: (term) =>
                        productoController.search_product(term),
                    decoration: InputDecoration(

                        constraints:
                            const BoxConstraints.expand(width: 300, height: 40),
                        isDense: true,
                        suffixIcon: IconButton(
                          onPressed: () => productoController.scanearproducto(
                              context: context, mounted: mounted),
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
              ),
            );
          }),
          productoController.getProductos(mounted: mounted),

          /*StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text('List Item $index'),
                  );
                },
              ),
            );
          })*/

          /*  SliverFillRemaining(
            child: Container(
                margin: EdgeInsets.all(
                    Pantalla.getMarginLeftRight(context: context)),
                child: Center(
                  child: productoController.getProductos(mounted: mounted),
                )),
          )*/
        ],
      )

          /*,*/
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
