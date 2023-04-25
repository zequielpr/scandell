import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:scasell/MediaQuery.dart';

import '../../../../Estilo/Colores.dart';
import 'crear_productos_controllers/CrearProductoController.dart';

class CrearProducto extends StatefulWidget {
  final CollectionReference collectionReferenceProductos;
  final String ?idCodigoDeBarra;
  const CrearProducto({Key? key, required this.collectionReferenceProductos, required this.idCodigoDeBarra})
      : super(key: key);

  @override
  State<CrearProducto> createState() => _CrearProductoState( idCodigoDeBarra: idCodigoDeBarra,
      collectionReferenceProductos: collectionReferenceProductos);
}

class _CrearProductoState extends State<CrearProducto> {
  final CollectionReference<Object?> collectionReferenceProductos;
  final String? idCodigoDeBarra;
  _CrearProductoState( { required this.idCodigoDeBarra, required this.collectionReferenceProductos});


  late CrearProductoController crearProductoController = CrearProductoController(colleccionReferenceProductos: collectionReferenceProductos, idCodigoBarra: idCodigoDeBarra);

  var nombreController = TextEditingController();

  var precioCompraController = TextEditingController();
  var precioVentaController = TextEditingController();
  var medidaController = TextEditingController();
  String tipoMedida = 'Unidad';

  Map<String, dynamic> datosProducto = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crear producto'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                left: Pantalla.getMarginLeftRight(context: context),
                right: Pantalla.getMarginLeftRight(context: context)),
            child: Center(
              child: Column(
                children: [
                  _getSeleccionTipo(),
                  _getAddImg(),
                  getTextFields(),
                  _getBotonGuardar()
                ],
              ),
            ),
          ),
        ));
  }

  _getAddImg() {
    return Column(
      children: [
        SizedBox(
          height: Pantalla.getPorcentPanntalla(10, context, 'y'),
        ),
        Transform.scale(
          scale: 5,
          child: InkWell(
            onTap: () {
              print('object');
            },
            child: const Icon(
              Icons.add_photo_alternate_outlined,
            ),
          ),
        )
      ],
    );
  }

  Widget getTextFields() {
    return Column(
      children: [
        SizedBox(
          height: Pantalla.getPorcentPanntalla(8, context, 'y'),
        ),
        TextField(
          controller: nombreController,
          decoration: const InputDecoration(
              label: Text('Nombre'),
              hintText: 'Escribe el nombre del producto aquí  aquí'),
        ),
        //mostrarErrorNomre(),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(3, context, 'y'),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: precioCompraController,
          decoration: InputDecoration(
              label: Text('Precio de compra por $tipoMedida'),
              hintText: 'Escribe el precio de compra  aquí'),
          onSubmitted: (String value) {},
        ),
        //mostrarErrorDireccion(),

        SizedBox(
          height: Pantalla.getPorcentPanntalla(3, context, 'y'),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: precioVentaController,
          decoration: InputDecoration(
              label: Text('Precio de venta por $tipoMedida'),
              hintText: 'Escribe el precio de venta aquí'),
          onSubmitted: (String value) {},
        ),
        //mostrarErrorDireccion(),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(3, context, 'y'),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: medidaController,
          decoration: InputDecoration(
            label: Text('$tipoMedida/s'),
          ),
          onSubmitted: (String value) {},
        ),
        //mostrarErrorDireccion(),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
        ),
      ],
    );
  }

  _getBotonGuardar() {
    return ElevatedButton(
        onPressed: () {
          datosProducto = {
            'nombre_producto': nombreController.text ,
            'precio_compra': double.parse(precioCompraController.text),
            'precio_venta':  double.parse(precioVentaController.text),
            'stock':  double.parse(medidaController.text),
            'tipo': _currentSelection,
          };

          crearProductoController.crearProducto(datosProducto: datosProducto);

        },
        child: Text('Guardar'));
  }

  int _currentSelection = 0;
  late final Map<int, Widget> _children = {
    0: Padding(
      padding: EdgeInsets.only(
          left: Pantalla.getPorcentPanntalla(4, context, 'x'),
          right: Pantalla.getPorcentPanntalla(4, context, 'x')),
      child: Text('Unidad'),
    ),
    1: const Text('Kilo'),
    2: const Text('Litro'),
  };
  _getSeleccionTipo() {
    return MaterialSegmentedControl(
      children: _children,
      selectionIndex: _currentSelection,
      borderColor: Colors.grey,
      selectedColor: Colores.colorPrincipal,
      unselectedColor: Colors.white,
      selectedTextStyle: TextStyle(color: Colors.white),
      unselectedTextStyle: TextStyle(color: Colores.colorPrincipal),
      borderWidth: 0.8,
      borderRadius: 10.0,
      disabledChildren: [
        3,
      ],
      onSegmentTapped: (index) {
        setState(() {
          _currentSelection = index;

          print('index$index');
          switch (index) {
            case 0:
              tipoMedida = 'unidad';
              break;
            case 1:
              tipoMedida = 'kilo';
              break;
            case 2:
              tipoMedida = 'litro';
              break;
            default:
              break;
          }
          print(tipoMedida);
        });
      },
    );
  }
}
