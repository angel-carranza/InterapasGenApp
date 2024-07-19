

// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:interapas_gen_app/widgets/conexion_disponible.dart';
import 'package:interapas_gen_app/widgets/loader.dart';

import '../utilities/popup.dart';

class Configuracion_Screen extends StatefulWidget {
  const Configuracion_Screen({super.key});

  @override
  State<Configuracion_Screen> createState() => _Configuracion_ScreenState();
}

class _Configuracion_ScreenState extends State<Configuracion_Screen> {
  bool fgCargando = true;   //Para mostrar una pantalla de carga, lo mostrará al inicio.

  List<API_CONEXION> conexiones = List.empty(growable: true);

  Widget contenido = const Center(child: Loader(textoInformativo: "Cargando interfaz.",));


  Future<void> _cargaInicial() async {   //Carga inicial cuando se ejecuta la pantalla
    conexiones = await AccesoDatos.obtieneAPIsGuardadas();   //Obtiene las conexiones guardadas.

    setState(() {   //Para mandar recargar ya después de las consultas.
      fgCargando = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _cargaInicial();
  }

  @override
  Widget build(BuildContext context) {

    if(!fgCargando){
      contenido = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Text(
              "Conexiones",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: conexiones.length,
              itemBuilder: (context, index) => ConexionDisponible(conexiones[index], _cargaInicial)
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextButton(
              onPressed: () async {
                List<API_CONEXION>? listaNueva = await AccesoDatos.obtieneAPIs();

                if(listaNueva != null){
                  if(listaNueva.isNotEmpty){

                    if(await AccesoDatos.insertaNuevasConexiones(listaNueva)){
                      if(context.mounted) {
                        _cargaInicial();
                        mensajeSimpleOK("Se actualizó correctamente.", context);
                      }
                    } else {
                      mensajeSimpleOK("No se pudieron actualizar las conexiones, intente más tarde...", context);
                    }
                  } else {
                    mensajeSimpleOK("No se encontraron conexiones...", context);
                  }
                } else {
                  mensajeSimpleOK("No se encontraron conexiones...", context);
                }
              
              },
              child: const Text("Actualizar direcciones"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(actions: const []),
      body: SafeArea(child: contenido),
    );
  }
}