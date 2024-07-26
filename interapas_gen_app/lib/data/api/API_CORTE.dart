
// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

class API_CORTE {
  int ID_CORTE_APP;
  int ID_CONTRATO;
  String? CL_RUTA;
  String CL_INTERNET;
  String NB_MUNICIPIO;
  String NB_COLONIA;
  String NB_CALLE;
  String NO_EXTERIOR;
  String? NO_INTERIOR;
  String CL_CODIGO_POSTAL;
  double MN_ADEUDO_ACTUAL;
  int MESES_ADEUDO;
  
  API_CORTE(
    this.ID_CORTE_APP,
    this.ID_CONTRATO,
    this.CL_RUTA,
    this.CL_INTERNET,
    this.NB_MUNICIPIO,
    this.NB_COLONIA,
    this.NB_CALLE,
    this.NO_EXTERIOR,
    this.NO_INTERIOR,
    this.CL_CODIGO_POSTAL,
    this.MN_ADEUDO_ACTUAL,
    this.MESES_ADEUDO,
  );

  static API_CORTE fromJsonAPI(Map<String, Object?> json) => API_CORTE(
    json["iD_CORTE_APP"] as int,
    json["iD_CONTRATO"] as int,
    json["cL_RUTA"] as String,
    json["cL_ACCESO_INTERNET"] as String,
    json["nB_MUNICIPIO"] as String,
    json["nB_COLONIA"] as String,
    json["nB_CALLE"] as String,
    json["nO_EXTERIOR"] as String,
    json["nO_INTERIOR"] as String,
    json["cL_CODIGO_POSTAL"] as String,
    json["mN_ADEUDO_ACTUAL"] as double,
    json["meseS_ADEUDO"] as int,
  );

}