import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scasell/rutas/Rutas.gr.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../MediaQuery.dart';
import '../../../../db/db.dart';

class ProductoController {
  DocumentSnapshot documentSnapshotNegocio;
  ProductoController({required this.documentSnapshotNegocio});

  navegarToCrearProducto({required BuildContext context, String? idProducto}) {
    var _listaProducto =
        documentSnapshotNegocio.reference.collection('productos');
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

  getListaProductos({required BuildContext context}) {
    var _listaProducto = documentSnapshotNegocio.reference
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
              return ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.image,
                  size: 30,
                ),
                title: Text(
                  data['nombre_producto'],
                  style: TextStyle(fontSize: 25),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      size: 15,
                    ),
                    Text('${data['precio_compra']}       '),
                    _comprobarPrecioVenta(
                        precioCompra: data['precio_compra'],
                        precioVenta: data['precio_venta']),
                    Text('${data['precio_venta']}       '),
                    Icon(
                      Icons.circle,
                      size: 15,
                    ),
                    Text(
                        '${data['stock']}   ${_comprobarTipo(tipo: data['tipo'])}')
                  ],
                ),
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
                    onPressed: () => navegarToCrearProducto(context: context),
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

  _comprobarPrecioVenta(
      {required double precioCompra, required double precioVenta}) {
    if (precioCompra > precioVenta) {
      return const Icon(Icons.trending_down, size: 15);
    }
    return const Icon(Icons.trending_up, size: 15);
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
