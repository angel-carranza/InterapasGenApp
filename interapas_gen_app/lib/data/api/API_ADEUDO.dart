
// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

class API_ADEUDO {
  int ID_CONTRATO;
  double MN_ADEUDO;
  int NO_MESES;

  API_ADEUDO(
    this.ID_CONTRATO,
    this.MN_ADEUDO,
    this.NO_MESES
  );

  static API_ADEUDO fromJsonAPI(Map<String, Object?> json) => API_ADEUDO(
    json["iD_CONTRATO"] as int,
    json["mN_ADEUDO_ACTUAL"] as double,
    json["meseS_ADEUDO"] as int,
  );

}
