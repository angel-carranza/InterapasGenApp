
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import '../widgets/loader.dart';

class Inicio_Screen extends StatelessWidget {
  
  const Inicio_Screen({super.key});
  
  @override
  Widget build(BuildContext context) {
    Future.delayed(Durations.extralong4).then((erg) {

      if(OperacionesPreferencias.consultarIdUsuario() > 0) {   //Aqui valida si hay sesión iniciada.
        Navigator.of(context).popAndPushNamed("/menu");
      } else {
        if(OperacionesPreferencias.consultarConexionActiva() == null){  //Aqui checa si ya tienes direcciones guardadas.
          AccesoDatos.obtieneAPIs().then((lista) {    //Intentará obtener las direcciones de las API a usar.
            if(lista != null){
              if(lista.isNotEmpty){
                AccesoDatos.insertaNuevasConexiones(lista).then((res) => {
                  if(res){
                    AccesoDatos.actualizaConexionActiva(lista.where((w) => w.FG_ACTIVA).first.CLAVE).then( (erg){ } )
                  }
                });
              }
            }
          });
        }
        
        Navigator.of(context).popAndPushNamed('/login');
      }
    });

    return const Scaffold(
      body: Loader(
        textoInformativo: "Cargando datos..."
      ),
    );
  }

}