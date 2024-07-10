
// ignore_for_file: non_constant_identifier_names, camel_case_types

class API_CONEXION {
  String CLAVE;
  String API_PRINCIPAL_IP;
  String API_PRINCIPAL_DIR;
  String? API_SECUNDARIA_IP;
  String? API_SECUNDARIA_DIR;
  bool FG_ACTIVA;

  API_CONEXION(
    this.CLAVE,
    this.API_PRINCIPAL_IP,
    this.API_PRINCIPAL_DIR,
    this.FG_ACTIVA,
    {
      this.API_SECUNDARIA_IP,
      this.API_SECUNDARIA_DIR,
    }
  );

  static API_CONEXION fromJsonAPI(Map<String, Object?> json) => API_CONEXION(
    json["clave"] as String,
    json["api_principal_ip"] as String,
    json["api_principal_dir"] as String,
    json["fg_activa"] as bool,
    API_SECUNDARIA_IP: json["api_secundaria_ip"] == null ? "" : json["api_secundaria_ip"] as String,
    API_SECUNDARIA_DIR: json["api_secundaria_dir"] == null ? "" : json["api_secundaria_dir"] as String,
  );

  static API_CONEXION fromJson(Map<String, Object?> json) => API_CONEXION(
    json["CL_API"] as String,
    json["API_PRIMARIA"] as String,
    json["DIR_PRIMARIA"] as String,
    json["FG_ACTIVA"] == 1,
    API_SECUNDARIA_IP: json["API_SECUNDARIA"] == null ? "" : json["API_SECUNDARIA"] as String,
    API_SECUNDARIA_DIR: json["DIR_SECUNDARIA"] == null ? "" : json["DIR_SECUNDARIA"] as String,
  );

    Map<String, Object?> toJson() => {
    "CL_API" : CLAVE,
    "API_PRIMARIA" : API_PRINCIPAL_IP,
    "DIR_PRIMARIA" : API_PRINCIPAL_DIR,
    "API_SECUNDARIA" : API_SECUNDARIA_IP,
    "DIR_SECUNDARIA" : API_SECUNDARIA_DIR,
    "FG_ACTIVA": FG_ACTIVA
  };
}