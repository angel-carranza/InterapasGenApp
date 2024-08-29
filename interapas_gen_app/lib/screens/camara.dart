
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:watermark_unique/image_format.dart' as img_format;
import 'package:watermark_unique/watermark_unique.dart';
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
                  try {
                    await _iniciarControladorFuturo;
              
                    XFile foto = await _controladorCamara.takePicture();

                    String dirGuardar = "";
                    DateTime fechaFoto = await foto.lastModified();
                    String fechaFotoStr = DateFormat("yyyy-MM-dd – kk:mm").format(fechaFoto);
                    try {
                      Directory directorio = await getApplicationDocumentsDirectory();

                      Directory dirFotos = Directory("${directorio.path}/fotos/");

                      if(!(await dirFotos.exists())){
                        dirFotos = await dirFotos.create(recursive: true);
                      }

                      WatermarkUnique waterMarkObject = WatermarkUnique();

                      final watermarkedImg = await waterMarkObject.addTextWatermark(
                        filePath: foto.path,
                        text: fechaFotoStr,
                        x: 24,
                        y: 48,
                        textSize: 32,
                        quality: 100,
                        color: Colors.white,
                        imageFormat: img_format.ImageFormat.jpeg,
                        backgroundTextColor: Colors.black.withOpacity(0.4),
                        backgroundTextPaddingTop: 36,
                        backgroundTextPaddingLeft: 24,
                        backgroundTextPaddingRight: 24,
                      );

                      dirGuardar = "${dirFotos.path}$fechaFotoStr.jpg";

                      XFile fotoMarcada = XFile(foto.path.replaceAll(".jpg", ".jpeg"));

                      await File(dirGuardar).writeAsBytes(await fotoMarcada.readAsBytes());

                      await File(fotoMarcada.path).delete();

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
                  } catch (e) {
                    if(context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Hubo un error inesperado."),
                      ));
                    }
                  }
                },
              ),
            ],
          )
        ]
      ),
    );

  }
}