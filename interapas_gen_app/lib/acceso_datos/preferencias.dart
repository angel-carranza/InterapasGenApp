
// ignore_for_file: non_constant_identifier_names

import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:interapas_gen_app/services/local_storage.dart';

//Clase intermedia para realizar operaciones con las shared_preferences
class OperacionesPreferencias {

  static int consultarIdUsuario() {
    int? entero = LocalStorage.preferencias.getInt("idUsuario");
    return entero ?? 0;
  }

  static Future<bool> insertarIdUsuario(int p_idUsuario) async {
    bool resultado = await LocalStorage.preferencias.setInt('idUsuario', p_idUsuario);
    return resultado;
  }

  static List<String>? consultarConexionActiva() => LocalStorage.preferencias.getStringList('conexionActiva');

  static Future<bool> insertarConexionActiva(API_CONEXION conexion) async {
    bool resultado = await LocalStorage.preferencias.setStringList(
      'conexionActiva',
      [
        conexion.CLAVE,
        conexion.API_PRINCIPAL_DIR,
        conexion.API_PRINCIPAL_IP,
        conexion.API_SECUNDARIA_DIR ?? "",
        conexion.API_SECUNDARIA_IP ?? "",
      ] 
    );
    
    return resultado;
  }
  
  static String? consulatarToken() => LocalStorage.preferencias.getString('tokenAPI');

  static Future<bool> insertarToken(String token) async {
    bool resultado = await LocalStorage.preferencias.setString('tokenAPI', token);
    return resultado;
  }

  static int consultarIdEmpleado() {
    int? entero = LocalStorage.preferencias.getInt("idEmpleado");
    return entero ?? 0;
  }

  static Future<bool> insertarIdEmpleado(int p_idEmpleado) async {
    bool resultado = await LocalStorage.preferencias.setInt("idEmpleado", p_idEmpleado);
    return resultado;
  }

  static String consultarNbEmpleado() {
    String? entero = LocalStorage.preferencias.getString("nbEmpleado");
    return entero ?? "";
  }

  static Future<bool> insertarNbEmpleado(String p_nbEmpleado) async {
    bool resultado = await LocalStorage.preferencias.setString("nbEmpleado", p_nbEmpleado);
    return resultado;
  }

}