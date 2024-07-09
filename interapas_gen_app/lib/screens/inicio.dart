
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import '../widgets/loader.dart';

class Inicio_Screen extends StatelessWidget {
  
  const Inicio_Screen({super.key});
  
  @override
  Widget build(BuildContext context) {
    OperacionesPreferencias negocio1 = OperacionesPreferencias();
    Future.delayed(Durations.extralong4).then((erg) {

      if(negocio1.consultarIdUsuario() > 0){
        Navigator.of(context).popAndPushNamed("/menu");
      } else{
        negocio1.insertarIdUsuario(20).then( (erg) {
            Navigator.of(context).popAndPushNamed('/login');
          }
        );
      }
    });

    return const Scaffold(
      body: Loader(
        textoInformativo: "Cargando datos..."
      ),
    );
  }

}