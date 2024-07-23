
// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:intl/intl.dart';

class API_CORTE_ENVIO {
  int ID_CORTE_APP;
  int ID_CONTRATO;
  int ID_EMPLEADO;
  int FG_ESTADO;
  String DS_OBSERVACIONES;
  String DS_FECHA_CAPTURA;
  List<String> DS_FOTOS;

  API_CORTE_ENVIO(
    this.ID_CORTE_APP,
    this.ID_CONTRATO,
    this.ID_EMPLEADO,
    this.FG_ESTADO,
    this.DS_OBSERVACIONES,
    this.DS_FECHA_CAPTURA,
    this.DS_FOTOS
  );

  static Future<API_CORTE_ENVIO> fromCorte(K_CORTE corte, int idEmpleado) async {
    List<String> fotos = List.empty(growable: true);

    if(corte.DS_FOTOS != null){
      if(corte.DS_FOTOS!.isNotEmpty){
        for(String direccion in corte.DS_FOTOS!.split('@')){
          fotos.add(base64Encode(await File(direccion).readAsBytes()));
        }
      }
    }
    
    return API_CORTE_ENVIO(
      corte.ID_CORTE_APP,
      corte.ID_CONTRATO,
      idEmpleado,
      corte.FG_ESTADO,
      corte.DS_OBSERVACIONES ?? "",
      DateFormat("yyyy-MM-dd hh:mm:ss").format(corte.FE_CAPTURA ?? DateTime.now() ),
      fotos,
    );
  }

  Map<String, Object?> toJson() => {
    "ID_CORTE_APP": ID_CORTE_APP,
    "ID_CONTRATO": ID_CONTRATO,
    "ID_EMPLEADO": ID_EMPLEADO,
    "FG_ESTADO": FG_ESTADO,
    "DS_OBSERVACIONES" : DS_OBSERVACIONES,
    "DS_FECHA_CAPTURA" : DS_FECHA_CAPTURA,
    "DS_FOTOS" : DS_FOTOS,
  };
}