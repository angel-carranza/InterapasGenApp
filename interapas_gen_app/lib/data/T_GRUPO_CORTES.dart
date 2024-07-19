
// ignore_for_file: file_names, camel_case_types

import 'package:interapas_gen_app/data/enumerados.dart';

//Clase que se usará para crear entidades visuales sobre agrupaciones de los cortes disponibles.
class T_GRUPO_CORTES {
  agrupaciones tipoGrupo;
  String nombreGrupo;
  int cantidad;
  String? datoAdicional1;   //Para el Código Postal

  T_GRUPO_CORTES(
    this.tipoGrupo,
    this.nombreGrupo,
    this.cantidad,
    {
      this.datoAdicional1,
    }
  );
}