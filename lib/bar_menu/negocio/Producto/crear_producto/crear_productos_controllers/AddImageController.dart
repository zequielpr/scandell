import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageController {
  BuildContext _context;
  var _mostrarImagen;
  final ImagePicker picker = ImagePicker();

  AddImageController({required BuildContext context, required var mostrarImagen}) : _context = context, _mostrarImagen = mostrarImagen;

  pickImage() {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Selecciona una imagen', textAlign: TextAlign.center,),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('Desde la galería'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('Desde la cámara'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    var image = await picker.pickImage(source: media);


    _mostrarImagen(image);
  }
}
