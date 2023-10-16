import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scasell/Estilo/Colores.dart';
import 'package:scasell/MediaQuery.dart';
import 'package:scasell/widgets_comunes/ShowModal.dart';

import '../../db/db.dart';
import 'Producto/Producto.dart';
import 'controllers/negocioController.dart';

class Negocio extends StatefulWidget {
  const Negocio({Key? key}) : super(key: key);

  @override
  State<Negocio> createState() => _NegocioState();
}

class _NegocioState extends State<Negocio> {
  AppLocalizations? valores;
  var nombreController = TextEditingController();
  var direccionController = TextEditingController();
  int error = 0;
  var styleTextoError = const TextStyle(color: Colors.red);
  var setStateShowModal;
  late NegocioController negocioController = NegocioController('id', context, setState);
  ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      elevation: MaterialStateProperty.all(0));



  @override
  Widget build(BuildContext context) {
    negocioController.context = context;
    valores = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () =>
                    ShowModal(vistaCrearNegocio).getShowModla(context),
                icon: const Icon(
                  Icons.add_business_rounded,
                  color: Colors.black,
                ))
          ],
          title: Text(valores?.menu_negocio as String),
        ),
        body: negocioController.listarNegocio(buttonStyle: buttonStyle, vistaCrearNegocio:  vistaCrearNegocio, context: context));
  }





  late Widget vistaCrearNegocio =
  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    setStateShowModal = setState;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_getTitle('Crear negocio'), getTextFields(), _getButton(context)],
    );
  });

  void comprobarDatos(int error) {
    setStateShowModal(() {
      this.error = error;
    });
  }

  Widget mostrarErrorNomre() {
    if (error == 1) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'introduce un nombre',
          style: styleTextoError,
          textAlign: TextAlign.left,
        ),
      );
    }
    return Text('');
  }

  Widget mostrarErrorDireccion() {
    if (error == 2) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'introduce una dirección',
          style: styleTextoError,
          textAlign: TextAlign.left,
        ),
      );
    }
    return const Text('');
  }

  Widget _getTitle(String title) {
    return Column(
      children: [
        SizedBox(
          height: Pantalla.getPorcentPanntalla(1, context, 'y'),
        ),
        Card(
          elevation: 0,
          color: Colores.colorPrincipal,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 100,
            height: 10,
          ),
        ),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(1, context, 'y'),
        ),
        Text(title)
      ],
    );
  }

  Widget getTextFields() {
    return Column(
      children: [
        TextField(
          maxLength: 30,
          controller: nombreController,
          decoration: const InputDecoration(
              label: Text('Nombre'),
              hintText: 'Escribe el nombre de negocio  aquí'),
        ),
        mostrarErrorNomre(),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(3, context, 'y'),
        ),
        TextField(
          maxLength: 30,
          controller: direccionController,
          decoration: const InputDecoration(
              label: Text('Dirección'),
              hintText: 'Escribe la dirección de negocio  aquí'),
          onSubmitted: (String value) {},
        ),
        mostrarErrorDireccion(),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(5, context, 'y'),
        ),
      ],
    );
  }

  Widget _getButton(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => negocioController.crearNegocio(
                nombre: nombreController.text,
                direccion: direccionController.text,
                comprobarDatos: comprobarDatos, context: context),
            child: const Text('Guardar')),
        SizedBox(
          height: Pantalla.getPorcentPanntalla(2, context, 'y'),
        )
      ],
    );
  }
}
