
// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:interapas_gen_app/data/api/API_CORTE.dart';

class K_CORTE {
  int ID_CORTE;
  int ID_USUARIO;
  int ID_CORTE_APP;
  int ID_CONTRATO;
  String? CL_RUTA;
  String? NB_MUNICIPIO;
  String NB_COLONIA;
  String NB_CALLE;
  String NO_EXTERIOR;
  String? NO_INTERIOR;
  String? CL_CODIGO_POSTAL;
  double MN_ADEUDO;
  int NO_MESES_ADEUDO;
  String? DS_FOTOS;
  String? DS_OBSERVACIONES;
  int FG_ESTADO;

  K_CORTE(
    this.ID_CORTE,
    this.ID_USUARIO,
    this.ID_CORTE_APP,
    this.ID_CONTRATO,
    this.CL_RUTA,
    this.NB_MUNICIPIO,
    this.NB_COLONIA,
    this.NB_CALLE,
    this.NO_EXTERIOR,
    this.NO_INTERIOR,
    this.CL_CODIGO_POSTAL,
    this.MN_ADEUDO,
    this.NO_MESES_ADEUDO,
    this.DS_FOTOS,
    this.DS_OBSERVACIONES,
    this.FG_ESTADO,
  );

  static K_CORTE fromJson(Map<String, Object?> json) => K_CORTE(
    json["ID_CORTE"] as int,
    json["ID_USUARIO"] as int,
    json["ID_CORTE_APP"] as int,
    json["ID_CONTRATO"] as int,
    json["CL_RUTA"] as String?,
    json["NB_MUNICIPIO"] as String?,
    json["NB_COLONIA"] as String,
    json["NB_CALLE"] as String,
    json["NO_EXTERIOR"] as String,
    json["NO_INTERIOR"] as String?,
    json["CL_CODIGO_POSTAL"] as String?,
    json["MN_ADEUDO"] as double,
    json["NO_MESES_ADEUDO"] as int,
    json["DS_FOTOS"] as String?,
    json["DS_OBSERVACIONES"] as String?,
    json["FG_ESTADO"] as int,

  );

  static Map<String, Object?> fromAPItoJson(int idUsuario, API_CORTE corte) => {
    "ID_USUARIO" : idUsuario,
    "ID_CORTE_APP" : corte.ID_CORTE_APP,
    "ID_CONTRATO" : corte.ID_CONTRATO,
    "CL_RUTA" : corte.CL_RUTA,
    "NB_MUNICIPIO" : corte.NB_MUNICIPIO,
    "NB_COLONIA" : corte.NB_COLONIA,
    "NB_CALLE" : corte.NB_CALLE,
    "NO_EXTERIOR" : corte.NO_EXTERIOR,
    "NO_INTERIOR" : corte.NO_INTERIOR,
    "CL_CODIGO_POSTAL" : corte.CL_CODIGO_POSTAL,
    "MN_ADEUDO" : corte.MN_ADEUDO_ACTUAL,
    "NO_MESES_ADEUDO" : corte.MESES_ADEUDO,
  };
}