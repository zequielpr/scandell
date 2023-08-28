import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:scasell/MediaQuery.dart';

import '../../../../Estilo/Colores.dart';
import '../../../../Estilo/Theme.dart';
import 'crear_productos_controllers/AddImageController.dart';
import 'crear_productos_controllers/CrearProductoController.dart';
import 'package:image_picker/image_picker.dart';

class CrearProducto extends StatefulWidget {
  final CollectionReference collectionReferenceProductos;
  final String? idCodigoDeBarra;
  const CrearProducto(
      {Key? key,
      required this.collectionReferenceProductos,
      required this.idCodigoDeBarra})
      : super(key: key);

  @override
  State<CrearProducto> createState() => _CrearProductoState(
      idCodigoDeBarra: idCodigoDeBarra,
      collectionReferenceProductos: collectionReferenceProductos);
}

class _CrearProductoState extends State<CrearProducto> {
  final CollectionReference<Object?> collectionReferenceProductos;
  final String? idCodigoDeBarra;
  _CrearProductoState(
      {required this.idCodigoDeBarra,
      required this.collectionReferenceProductos});

  late CrearProductoController crearProductoController =
      CrearProductoController(
          colleccionReferenceProductos: collectionReferenceProductos,
          idCodigoBarra: idCodigoDeBarra,
          setState: setState,
          context: context);

  var nombreController = TextEditingController();

  var precioCompraController = TextEditingController();
  var precioVentaController = TextEditingController();
  var medidaController = TextEditingController();
  String tipoMedida = 'Unidad';
  var espacioEntreFields = 2.0;

  late AddImageController imagePicker =
      AddImageController(context: context, mostrarImagen: mostrarImagen);

  XFile? image;
  mostrarImagen(var image) {
    print('holaaaa${image!.path}');
    setState(() {
      this.image = image;
    });
  }

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
                  //_getSeleccionTipo(),
                  //_getAddImg(),
                  getTextFields(),
                  _getBotonGuardar(),
                  _getSizeBox()
                ],
              ),
            ),
          ),
        ));
  }

  _getSizeBox() {
    return SizedBox(
      height: Pantalla.getPorcentPanntalla(5, context, 'y'),
    );
  }

  //onTap: () => imagePicker.pickImage(),

  _getAddImg() {
    return Column(
      children: [
        FittedBox(
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(EdgeInsets.all(4)),
                visualDensity: VisualDensity.comfortable,
                maximumSize: MaterialStateProperty.all(Size.fromWidth(300)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            onPressed: () => imagePicker.pickImage(),
            child: image != null
                ? Container(
                    constraints: BoxConstraints.tight(Size(
                        Pantalla.getPorcentPanntalla(30, context, 'x'),
                        Pantalla.getPorcentPanntalla(20, context, 'y'))),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Colores.colorPrincipal,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      elevation: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.file(
                          //to show image, you type like this.
                          File(image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50, color: Colors.black54,
                  ),
          ),
        ),
      ],
    );
  }

  Widget getTextFields() {
    return Column(
      children: [
        SizedBox(
          height: Pantalla.getPorcentPanntalla(4, context, 'y'),
        ),
        TextField(
          maxLength: 35,
          controller: nombreController,
          decoration: const InputDecoration(
              label: Text('Nombre'),
              hintText: 'Escribe el nombre del producto aquí'),
        ),
        crearProductoController.mostrarError(campo: 1),
        SizedBox(
          height:
              Pantalla.getPorcentPanntalla(espacioEntreFields, context, 'y'),
        ),
        TextField(
          maxLength: 6,
          keyboardType: TextInputType.number,
          controller: precioCompraController,
          decoration: InputDecoration(
              label: Text('Precio de compra'),
              hintText: 'Escribe el precio de compra  aquí'),
          onSubmitted: (String value) {},
        ),
        crearProductoController.mostrarError(campo: 2),
        SizedBox(
          height:
              Pantalla.getPorcentPanntalla(espacioEntreFields, context, 'y'),
        ),
        TextField(
          maxLength: 6,
          keyboardType: TextInputType.number,
          controller: precioVentaController,
          decoration: const InputDecoration(
              label: Text('Precio de venta'),
              hintText: 'Escribe el precio de venta aquí'),
          onSubmitted: (String value) {},
        ),
        crearProductoController.mostrarError(campo: 3),
        SizedBox(
          height:
              Pantalla.getPorcentPanntalla(espacioEntreFields, context, 'y'),
        ),
        TextField(
          maxLength: 6,
          keyboardType: TextInputType.number,
          controller: medidaController,
          decoration: InputDecoration(
            label: Text('Unidad/es'),
          ),
          onSubmitted: (String value) {},
        ),
        crearProductoController.mostrarError(campo: 4),
        SizedBox(
          height:
              Pantalla.getPorcentPanntalla(espacioEntreFields, context, 'y'),
        ),
      ],
    );
  }

  _getBotonGuardar() {
    var button = ElevatedButton(
        onPressed: () {
          datosProducto = {
            'nombre_producto': nombreController.text,
            'precio_compra': precioCompraController.text,
            'precio_venta': precioVentaController.text,
            'stock': medidaController.text,
            'tipo': _currentSelection,
          };
          crearProductoController.crearProducto(datosProducto: datosProducto);
        },
        child: Text('Guardar'));

    return Stilos.darSizeButton(context: context, button: button);
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
