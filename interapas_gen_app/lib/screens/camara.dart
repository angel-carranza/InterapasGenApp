
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
                icon: const Icon(
                  size: 72.0,
                  Icons.lens_sharp,
                ),
                onPressed: () async {
                  try {
                    await _iniciarControladorFuturo;
              
                    final foto = await _controladorCamara.takePicture();
              
                    bool r = await widget.guardarFoto(foto.path);

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