
// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

class API_USUARIO {
  int ID_EMPLEADO;
  String CL_USUARIO;
  String NB_PASSWORD;

  API_USUARIO({
    this.ID_EMPLEADO = 0,
    this.CL_USUARIO = "",
    this.NB_PASSWORD = "",
  });

  static API_USUARIO fromJsonAPI(Map<String, Object?> json) => API_USUARIO(
    ID_EMPLEADO: json["iD_EMPLEADO"] as int,
    CL_USUARIO: json["cL_USUARIO"] as String,
    NB_PASSWORD: json["nB_PASSWORD"] as String,
  );

}