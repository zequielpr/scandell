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

  getListaProductos({required BuildContext context, required var mounted}) {
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
              return Column(
                children: [
                  ListTile(
                    onTap: () => navegarToCrearProducto(context: context, idProducto: document.id),
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
                  ),
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
                        scanearproducto(context: context, mounted: mounted),
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
        SizedBox(width: Pantalla.getPorcentPanntalla(1, context, 'x'),),
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
        SizedBox(width: Pantalla.getPorcentPanntalla(1, context, 'x'),),
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
        SizedBox(width: Pantalla.getPorcentPanntalla(1, context, 'x'),),
        Text('${data['stock']}  U')
      ],
    );
  }


  var color_profit;
  _comprobarPrecioVenta(
      {required double precioCompra, required double precioVenta}) {

    if (precioCompra > precioVenta) {
      color_profit = Colors.redAccent;
      return  Icon(Icons.trending_down, size: 15, color:  color_profit,);
    }
    color_profit = Colors.greenAccent;
    return Icon(Icons.trending_up, size: 15, color:  color_profit);
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
