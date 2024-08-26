
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../services/camara_provider.dart';

class Camara extends StatefulWidget {
  final Future<bool> Function(String ubi) guardarFoto;


  const Camara({super.key, required this.guardarFoto});

  @override
  State<Camara> createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {
  late CameraController _controladorCamara;
  late Future<void> _iniciarControladorFuturo;


  @override
  void initState() {
    super.initState();

    _controladorCamara = CameraController(
      camarasDisponibles.first, ResolutionPreset.high,
    );

    _iniciarControladorFuturo = _controladorCamara.initialize();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.loose,
        children: [
          FutureBuilder<void>(
            future: _iniciarControladorFuturo,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return CameraPreview(_controladorCamara);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Container()),
              IconButton(
                icon: Icon(
                  size: 66.0,
                  Icons.lens_sharp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
//                  try {
                    await _iniciarControladorFuturo;
              
                    XFile foto = await _controladorCamara.takePicture();

                    String dirGuardar = "";
                    DateTime fechaFoto = await foto.lastModified();
                    try {
                      Directory directorio = await getApplicationDocumentsDirectory();

                      Directory dirFotos = Directory("${directorio.path}/fotos/");

                      if(!(await dirFotos.exists())){
                        dirFotos = await dirFotos.create(recursive: true);
                      }

                      final watermarkedImg = await ImageWatermark.addTextWatermark(
                        imgBytes: await foto.readAsBytes(),
                        watermarkText: DateFormat("yyyy-MM-dd – kk:mm").format(fechaFoto),
                        dstX: 6,
                        dstY: 6,
                      );

                      dirGuardar = "${dirFotos.path}${fechaFoto.toString()}.jpg";

                      await File(dirGuardar).writeAsBytes(watermarkedImg);

                    } on MissingPlatformDirectoryException catch(e) {
                      dirGuardar = foto.path;
                    }

                    bool r = await widget.guardarFoto(dirGuardar);
              
                    if(context.mounted && r){
                      Navigator.of(context).pop();
                    } else{
                      if(context.mounted && !r){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Hubo un error al guardar la foto."),
                        ));
                      }
                    }
//                  } catch (e) {
  //                  if(context.mounted){
    //                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //                  content: Text("Hubo un error inesperado."),
        //              ));
          //          }
            //      }
                },
              ),
            ],
          )
        ]
      ),
    );

  }
}