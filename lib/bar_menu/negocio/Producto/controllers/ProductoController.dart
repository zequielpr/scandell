import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scasell/rutas/Rutas.gr.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../MediaQuery.dart';
import '../../../../db/db.dart';
import '../../../../widgets_comunes/statefulBuilder.dart';
import '../../../../widgets_comunes/widgets_states.dart';

class ProductoController {
  DocumentSnapshot _documentSnapshotNegocio;
  bool _documentDeletMode;
  bool _is_all_selected;
  BuildContext _context;
  var _setState;
  var tileBackground = Colors.transparent;
  var selectionIcon;
  var transparentIcon = const Icon(
    Icons.circle_outlined,
    size: 0,
  );
  late WidgetsStates _cardProductStates;
  HashSet<DocumentSnapshot> _list_documents_para_eliminar = HashSet();
  HashSet<DocumentSnapshot> _list_eliminated_documents = HashSet();

  get setState => _setState;

  set setState(value) {
    _setState = value;
  }

  bool get is_all_selected => _is_all_selected;

  set is_all_selected(bool value) {
    _is_all_selected = value;
  }

  bool get documentDeletMode => _documentDeletMode;

  set documentDeletMode(bool value) {
    _documentDeletMode = value;
    //Actualiza el arbol de widgets. In this case, the appBar of this section
    _setState(() {});
  }

  limpiar_list_documents_para_eliminar() {
    _list_documents_para_eliminar.clear();
    _setState(() {}); //update appBar of delete mode
    _is_all_selected = false;
    _cardProductStates.updateStates();
  }

  add_all_to_list_documents_para_eliminar() {
    //Añade todos los documento a la lista de eliminar
    _list_documents_para_eliminar.addAll(_snap_recieved);

    _is_all_selected = true;
    _cardProductStates.updateStates();
    _setState(() {});
  }

  HashSet<DocumentSnapshot> _snap_recieved = HashSet();
  Future<void> delete_document_in_list() async {
    int count = 0;
    for (var document in _list_documents_para_eliminar) {
      await document.reference.delete().whenComplete(() {
        _snap_recieved.remove(document);
        _list_eliminated_documents.add(document);
      });

      _cardProductStates.updateStates();
    }
    if (_is_all_selected){
      _documentDeletMode = false;
      _list_documents_para_eliminar.clear();
    }

    _is_all_selected = false;
    _setState(() {});
  }

  //Recuperar los documentos eliminados recientemente
  Future<void>undo() async {
    print('documentos para recup: ${_list_eliminated_documents.length}');
    Map<String, dynamic> data;
    for (var eliminated_document in _list_eliminated_documents) {
      data = eliminated_document.data()! as Map<String, dynamic>;
      await _documentSnapshotNegocio.reference.collection('productos').doc(eliminated_document.id).set(data);
    }
    _snap_recieved = _snap_recieved.union(_list_eliminated_documents) as HashSet<DocumentSnapshot<Object?>>;
    _list_eliminated_documents.clear();
    _cardProductStates.updateStates();
  }

  //Comprobar si el producto se encuentra en la lista a eliminar
  _comprobar_lista_eliminar({required DocumentSnapshot documento}) {
    //Si el modo de eliminar no está activado, el metodo finaliza su ejecución aquí.
    if (!_documentDeletMode)
      return;
    else if (_list_documents_para_eliminar.contains(documento)) {
      tileBackground = Colors.black12;
      return Icon(Icons.check_circle);
    } else {
      tileBackground = Colors.transparent;
      return Icon(Icons.circle_outlined);
    }
  }

  ProductoController(
      {required DocumentSnapshot<Object?> documentSnapshotNegocio,
      required documentDeletMode,
      required setState,
      required BuildContext context,
      required bool is_all_selected})
      : _documentSnapshotNegocio = documentSnapshotNegocio,
        _documentDeletMode = documentDeletMode,
        _setState = setState,
        _context = context,
        _is_all_selected = is_all_selected;

  navegarToCrearProducto({required BuildContext context, String? idProducto}) {
    var _listaProducto =
        _documentSnapshotNegocio.reference.collection('productos');
    context.router.push(CrearProductoRouter(
        collectionReferenceProductos: _listaProducto,
        idCodigoDeBarra: idProducto));
  }

  scanearproducto({required BuildContext context, required mounted}) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (!mounted) return;
      // si no se optiene un id, no navega a la ruta a la pantalla para crear el producto
      if (barcodeScanRes.isNotEmpty && barcodeScanRes != '-1') {
        navegarToCrearProducto(context: context, idProducto: barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    print('id producto$barcodeScanRes');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  //Activa el modo de eliminar.
  //Añade el documento pulsado a la lista para eliminar
  //Actualiza el widget pulsado
  _pulsadoLargo({required DocumentSnapshot documento, required setState}) {
    documentDeletMode = true;
    _add_doc_lista_elim(documento);
    setState(() {});
  }

  _eliminar_de_lista_el(DocumentSnapshot documentReference) {
    _list_documents_para_eliminar.remove(documentReference);
  }

  _add_doc_lista_elim(DocumentSnapshot documentReference) {
    _list_documents_para_eliminar.add(documentReference);
  }

  _pulsado_corto(
      {required DocumentSnapshot documento,
      required setState,
      required int num_elements}) {
    if (_documentDeletMode) {
      if (_list_documents_para_eliminar.contains(documento)) {
        _eliminar_de_lista_el(documento);
      } else {
        _add_doc_lista_elim(documento);
      }

      if (num_elements == _list_documents_para_eliminar.length) {
        _is_all_selected = true;
      } else {
        _is_all_selected = false;
      }

      setState(() {}); //State where the list of products is
      _setState(() {}); // State of the appBar
    } else {
      navegarToCrearProducto(context: _context, idProducto: documento.id);
    }
  }

  _getPrecioVenta(Map<String, dynamic> data, BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.shopping_basket_outlined,
          size: 15,
        ),
        SizedBox(
          width: Pantalla.getPorcentPanntalla(1, context, 'x'),
        ),
        Text('${data['precio_venta']}  € x U    '),
      ],
    );
  }

  _getProfit(Map<String, dynamic> data, BuildContext context) {
    return Row(
      children: [
        _comprobarPrecioVenta(
            precioCompra: data['precio_compra'],
            precioVenta: data['precio_venta']),
        SizedBox(
          width: Pantalla.getPorcentPanntalla(1, context, 'x'),
        ),
        Text('${data['precio_venta'] - data['precio_compra']}  € x U  ')
      ],
    );
  }

  _getStock(Map<String, dynamic> data, BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.list,
          size: 15,
        ),
        SizedBox(
          width: Pantalla.getPorcentPanntalla(1, context, 'x'),
        ),
        Text('${data['stock']}  U')
      ],
    );
  }

  var color_profit;
  _comprobarPrecioVenta(
      {required double precioCompra, required double precioVenta}) {
    if (precioCompra > precioVenta) {
      color_profit = Colors.redAccent;
      return Icon(
        Icons.trending_down,
        size: 15,
        color: color_profit,
      );
    }
    color_profit = Colors.greenAccent;
    return Icon(Icons.trending_up, size: 15, color: color_profit);
  }

  getProductos({required var mounted}) {
    var _listaProducto =
        _documentSnapshotNegocio.reference.collection('productos').get();

    return FutureBuilder<QuerySnapshot>(
      future: _listaProducto,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.data?.docs.isEmpty == true) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0)),
                      onPressed: () =>
                          scanearproducto(context: _context, mounted: mounted),
                      child: Icon(Icons.add,
                          color: Colors.black,
                          size: Pantalla.getPorcentPanntalla(
                              20.0 as double, _context, 'x'))),
                  Text('Crear producto')
                ],
              ),
            ),
          );
        }

        print('object');
        if (snapshot.connectionState == ConnectionState.done) {
          print('object');
          _snap_recieved.addAll(snapshot.data!.docs);
          return MyStatefulBuilder(
            dispose: () {
              //WidgetsStates.states_list.clear();
            },
            builder: (BuildContext context, StateSetter setState) {
              _cardProductStates = WidgetsStates(state: setState);
              return ListView(
                children: _snap_recieved.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  if (documentDeletMode) {
                    selectionIcon =
                        _comprobar_lista_eliminar(documento: document);
                  }
                  return Column(
                    children: [
                      ListTile(
                        onLongPress: () => _pulsadoLargo(
                            documento: document, setState: setState),
                        onTap: () => _pulsado_corto(
                            documento: document,
                            setState: setState,
                            num_elements: snapshot!.data!.size),
                        title: Text(
                          data['nombre_producto'],
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _getPrecioVenta(data, _context),
                            _getProfit(data, _context),
                            _getStock(data, _context)
                          ],
                        ),
                        trailing: _documentDeletMode
                            ? selectionIcon
                            : transparentIcon,
                        tileColor: _documentDeletMode
                            ? tileBackground
                            : Colors.transparent,
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  );
                }).toList(),
              );
              ;
            },
            key: null,
          );
        }

        return Text("loading");
      },
    );

    /*return StreamBuilder<QuerySnapshot>(
      stream: _listaProducto,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot!.data?.size != 0) {
          return MyStatefulBuilder(
            dispose: () {
              //WidgetsStates.states_list.clear();
            },
            builder: (BuildContext context, StateSetter setState) {
              _cardProductStates = WidgetsStates(state: setState);
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  if (documentDeletMode) {
                    selectionIcon = _comprobar_lista_eliminar(
                        documento: document.reference);
                  }

                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        onLongPress: () => _pulsadoLargo(
                            documento: document.reference, setState: setState),
                        onTap: () => _pulsado_corto(
                            documento: document.reference,
                            setState: setState,
                            num_elements: snapshot!.data!.size),
                        title: Text(
                          data['nombre_producto'],
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _getPrecioVenta(data, _context),
                            _getProfit(data, _context),
                            _getStock(data, _context)
                          ],
                        ),
                        trailing: _documentDeletMode
                            ? selectionIcon
                            : transparentIcon,
                        tileColor: _documentDeletMode
                            ? tileBackground
                            : Colors.transparent,
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  );
                }).toList(),
              );
              ;
            },
            key: null,
          );
        }

        //If there is not any product, this container is return
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () =>
                        scanearproducto(context: _context, mounted: mounted),
                    child: Icon(Icons.add,
                        color: Colors.black,
                        size: Pantalla.getPorcentPanntalla(
                            20.0 as double, ctx, 'x'))),
                Text('Crear producto')
              ],
            ),
          ),
        );
      },
    );*/
  }

  /*_comprobarTipo({required int tipo}) {
    var tipoMedida = '';
    switch (tipo) {
      case 0:
        tipoMedida = 'unidad/es';
        break;
      case 1:
        tipoMedida = 'kilo/s';
        break;
      case 2:
        tipoMedida = 'litro/s';
        break;
      default:
        break;
    }
    return tipoMedida;
  }*/
}
