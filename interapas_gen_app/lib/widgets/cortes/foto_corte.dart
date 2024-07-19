
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/screens/camara.dart';

class FotoCorte extends StatelessWidget {
  final int idCorte;
  final String dirImagen;

  const FotoCorte({super.key, required this.idCorte, required this.dirImagen});

  Future<bool> _guardarFoto(String ubicacion) async{
    return false;
  }

  @override
  Widget build(BuildContext context) {
    
    if(dirImagen.isEmpty){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))
        ),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Camara(guardarFoto: _guardarFoto)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_rounded,
              size: 26.0,
            ),
          ],
        ),
      );
    } else { 
      
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3.0,
            ),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 6.0,
          ),
          child: Image.file(File(dirImagen)),
        ),
        Row(
          children: [
            Expanded(child: Container()),
            Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: IconButton(
                onPressed: () async {

                  showDialog(
                    context: context
                    , builder: (BuildContext context) =>AlertDialog(
                      title: const Text("Eliminar"),
                      content: const Text(
                        "¿Seguro que quieres borrar esta foto?",
                        textAlign: TextAlign.start,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () { },
                          child: const Text("Sí"),
                        ),
                        TextButton(
                          onPressed: (){
                            if (!context.mounted) return;
                              Navigator.of(context).pop();
                          },
                          child: const Text("Cancelar")
                        ),
                      ],
                    )
                  );  //Para recargar la interfaz de las fotos.
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                ),
              ),
            ),
          ],
        )
      ],
    );
    }

  }

}