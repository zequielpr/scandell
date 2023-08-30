import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scasell/rutas/Rutas.gr.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../MediaQuery.dart';
import '../../../../db/db.dart';
import '../../../../widgets_comunes/widgets_states.dart';

class ProductoController {
  DocumentSnapshot _documentSnapshotNegocio;
  bool _documentDeletMode;
  BuildContext _context;
  var _setState;

  get setState => _setState;

  set setState(value) {
    _setState = value;
  }

  bool get documentDeletMode => _documentDeletMode;

  set documentDeletMode(bool value) {
    _documentDeletMode = value;
    //_procesar_delete_mode(delet_mode_active: value);
    _setState(() {});
  }

  var tileBackground = Colors.transparent;
  var selectionIcon = const Icon(
    Icons.circle_outlined,
    color: Colors.transparent,
  );

  limpiar_list_documents_para_eliminar() {
    _list_documents_para_eliminar.clear();
    cardProductState.updateStates();
  }

  add_all_to_list_documents_para_eliminar() {
    var documents_list =
        _documentSnapshotNegocio.reference.collection('productos');
    documents_list
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                _list_documents_para_eliminar.add(element.reference);
              })
            })
        .whenComplete(() {cardProductState.updateStates();
    });
  }

  WidgetsStates cardProductState = WidgetsStates();

  HashSet<DocumentReference> _list_documents_para_eliminar = HashSet();
  //Comprobar si el producto se encuentra en la lista a eliminar
  _comprobar_lista_eliminar({required DocumentReference documento}) {
    //Si el modo de eliminar no está activado, el metodo finaliza su ejecución aquí.
    if (!_documentDeletMode) return;

    if (_list_documents_para_eliminar.contains(documento)) {
      tileBackground = Colors.black12;
      print('Holaaa');
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
      required BuildContext context})
      : _documentSnapshotNegocio = documentSnapshotNegocio,
        _documentDeletMode = documentDeletMode,
        _setState = setState,
        _context = context;

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
  _pulsadoLargo({required DocumentReference documento, required setState}) {
    documentDeletMode = true;
    _add_doc_lista_elim(documento);
    setState(() {});
  }

  _eliminar_de_lista_el(DocumentReference documentReference) {
    _list_documents_para_eliminar.remove(documentReference);
  }

  _add_doc_lista_elim(DocumentReference documentReference) {
    _list_documents_para_eliminar.add(documentReference);
  }

  _pulsado_corto({required DocumentReference documento, required setState}) {
    if (_documentDeletMode) {
      if (_list_documents_para_eliminar.contains(documento)) {
        _eliminar_de_lista_el(documento);
      } else {
        _add_doc_lista_elim(documento);
      }
      setState(() {});
    } else {
      navegarToCrearProducto(context: _context, idProducto: documento.id);
    }
  }

  getListaProductos({required var mounted}) {
    var _listaProducto = _documentSnapshotNegocio.reference
        .collection('productos')
        .snapshots(includeMetadataChanges: true);

    return StreamBuilder<QuerySnapshot>(
      stream: _listaProducto,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return Column(
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        cardProductState.addState(setState);
                        if(!mounted)print('no montado');
                    return ListTile(
                      onLongPress: () => _pulsadoLargo(
                          documento: document.reference, setState: setState),
                      onTap: () => _pulsado_corto(
                          documento: document.reference, setState: setState),
                      title: Text(
                        data['nombre_producto'],
                        style: TextStyle(fontSize: 25),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getPrecioVenta(data, context),
                          _getProfit(data, context),
                          _getStock(data, context)
                        ],
                      ),
                      trailing: _documentDeletMode
                          ? _comprobar_lista_eliminar(
                              documento: document.reference)
                          : const Icon(
                              Icons.add,
                              size: 0,
                            ),
                      tileColor: _documentDeletMode
                          ? tileBackground
                          : Colors.transparent,
                    );
                  }),
                  const Divider(
                    thickness: 1,
                  )
                ],
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
    );
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

  _comprobarTipo({required int tipo}) {
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
  }
}
