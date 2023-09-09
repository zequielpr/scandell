import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:scasell/MediaQuery.dart';

import '../../../../Estilo/Colores.dart';
import '../../../../Estilo/Theme.dart';
import '../../../../widgets_comunes/my_Dialogues.dart';
import '../controllers/ProductoController.dart';
import 'crear_productos_controllers/AddImageController.dart';
import 'crear_productos_controllers/CrearProductoController.dart';
import 'package:image_picker/image_picker.dart';

class CrearProducto extends StatefulWidget {
  final CollectionReference collectionReferenceProductos;
  final String? idCodigoDeBarra;
  final ProductoController productoController;
  const CrearProducto(
      {Key? key,
      required this.collectionReferenceProductos,
      required this.idCodigoDeBarra,
      required this.productoController})
      : super(key: key);

  @override
  State<CrearProducto> createState() => _CrearProductoState(
      idCodigoDeBarra: idCodigoDeBarra,
      collectionReferenceProductos: collectionReferenceProductos,
      productoController: productoController);
}

class _CrearProductoState extends State<CrearProducto> {
  final CollectionReference<Object?> collectionReferenceProductos;
  final String? idCodigoDeBarra;
  final ProductoController productoController;

  _CrearProductoState({
    required this.idCodigoDeBarra,
    required this.collectionReferenceProductos,
    required this.productoController,
  });

  late CrearProductoController crearProductoController =
      CrearProductoController(
          colleccionReferenceProductos: collectionReferenceProductos,
          idCodigoBarra: idCodigoDeBarra,
          setState: setState,
          context: context,
          productoController: productoController);

  var nombreController = TextEditingController();

  var precioCompraController = TextEditingController();
  var precioVentaController = TextEditingController();
  var stockController = TextEditingController();
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
  bool _updateProduct = false;

  initState() {
    _datos_to_textControllers();
  }

  late Dialogues dialogue_eliminar_products;

  _mostrar_opcion_eliminar_all_docs() {
    dialogue_eliminar_products = Dialogues(
        titulo: _titulo,
        mensaje: _mensaje,
        actions: _dialogue_actions,
        context: context);

    dialogue_eliminar_products.mostrarDialog();
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
          onPressed: () => _eliminar_doc(context), child: Text('Eliminar'))
    ];
  }

  _eliminar_doc(BuildContext dilague_context) async {
    await crearProductoController.eliminar_doc().whenComplete(() async {
      await dilague_context.router.pop();
      await context.router.pop();
      final snackBar = SnackBar(
        content: const Text('documentos eliminados'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => crearProductoController.undo(),
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _pop_up_undo_bar() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crear producto'),
          actions: [
            _updateProduct
                ? IconButton(
                    onPressed: () => _mostrar_opcion_eliminar_all_docs(),
                    icon: Icon(Icons.delete))
                : Text('')
          ],
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
                    size: 50,
                    color: Colors.black54,
                  ),
          ),
        ),
      ],
    );
  }

  _datos_to_textControllers() {
    var prodcutDocument = collectionReferenceProductos.doc(idCodigoDeBarra);

    prodcutDocument.get().then((DocumentSnapshot documentSnapshot) => {
          if (documentSnapshot.exists)
            {
              setState(() {}),
              _updateProduct = true,
              nombreController.text =
                  documentSnapshot['nombre_producto'].toString(),
              precioCompraController.text =
                  documentSnapshot['precio_compra'].toString(),
              precioVentaController.text =
                  documentSnapshot['precio_venta'].toString(),
              stockController.text = documentSnapshot['stock'].toString(),

              //
            }
        });
  }

  getTextFields() {
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
          controller: stockController,
          decoration: InputDecoration(
            label: Text('Unidad/es'),
          ),
          onSubmitted: (String value) {},
        ),
        crearProductoController.mostrarError(campo: 4),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(
              espacioEntreFields + 3, context, 'y'),
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
            'stock': stockController.text,
            'tipo': _currentSelection,
          };

          if (_updateProduct) {
            crearProductoController.actualizardatos(
                datosProducto: datosProducto);
          } else {
            crearProductoController.crearProducto(datosProducto: datosProducto);
          }
        },
        child: Text(_updateProduct ? 'Actualizar' : 'Guardar'));

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
