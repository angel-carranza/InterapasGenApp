
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/screens/camara.dart';
import 'package:interapas_gen_app/utilities/popup.dart';

class FotoCorte extends StatelessWidget {
  final int idCorte;
  final String dirImagen;
  final callbackFunction;
  final saveFunction;

  const FotoCorte({super.key, required this.idCorte, required this.dirImagen, this.callbackFunction, this.saveFunction});

  Future<bool> _guardarFoto(String ubicacion) async{
    return await AccesoDatos.agregaFotoCorte(idCorte, ubicacion);
  }

  @override
  Widget build(BuildContext context) {
    
    if(dirImagen.isEmpty){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))
        ),
        onPressed: () async {
          await saveFunction();   //Guarda las observaciones

          if(context.mounted){
            await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Camara(guardarFoto: _guardarFoto)));
          }
          
          callbackFunction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              size: 26.0,
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.secondary
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: IconButton(
                onPressed: () async {
                  await saveFunction();

                  if(!context.mounted) return;

                  showDialog(
                    context: context
                    , builder: (BuildContext context) => AlertDialog(
                      title: const Text("Eliminar"),
                      content: const Text(
                        "¿Seguro que quieres borrar esta foto?",
                        textAlign: TextAlign.start,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            if(await AccesoDatos.eliminaFotoCorte(idCorte, dirImagen)){
                              if(context.mounted){
                                Navigator.of(context).pop();
                              }
                              callbackFunction();
                            } else {
                              if(context.mounted) {
                                mensajeSimpleOK("Hubo un error al intentar realizar la acción.", context);
                              }
                            }
                          },
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
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSecondary,
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