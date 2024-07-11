
import 'dart:convert';

import 'package:interapas_gen_app/acceso_datos/api/default.dart';
import 'package:interapas_gen_app/acceso_datos/api/general.dart';
import 'package:interapas_gen_app/acceso_datos/bd.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:http/http.dart' as http;
import 'package:interapas_gen_app/data/api/API_USUARIO.dart';

//Clase con todas las funciones intermediarias a 
// los diferentes tipos de datos que maneja la aplicación.
class AccesoDatos {
  //FUNCIONES APIS
  static Future<List<API_CONEXION>?> obtieneAPIs() async {
    try {
      http.Response resp = await defaultAPI.getAPIs();

      var cuerpo = json.decode(resp.body);

      List<API_CONEXION> conexiones = List<API_CONEXION>.empty(growable: true);

      for(var registro in cuerpo){
        conexiones.add(API_CONEXION.fromJsonAPI(registro as Map<String, dynamic>));
      }

      return conexiones;
    } on Exception catch(_){
      return null;
    }
  }

  static Future<API_USUARIO> obtieneAcceso(clUsuario, nbPassword) async {
    API_USUARIO resultado = API_USUARIO();
    generalAPI api = generalAPI();

    http.Response r = await api.getAcceso(clUsuario, nbPassword);

    if(r.statusCode == 200){
      Map<String, Object?> cuerpo = (json.decode(r.body) as List).first;

      resultado = API_USUARIO.fromJsonAPI(cuerpo);
    } else {
      resultado = API_USUARIO(ID_EMPLEADO: -902);
    }
    
    return resultado;
  }
  //========================================//

  //FUNCIONES BASEDATOS LOCAL
  static Future<List<API_CONEXION>> obtieneAPIsGuardadas() async {
    return await operacionesBD.obtenerConexiones();
  }

  static Future<bool> insertaNuevasConexiones(List<API_CONEXION> conexiones) async {
    bool resultado = false;

    int actuales = (await operacionesBD.obtenerConexiones()).length;
    int eliminadas = await operacionesBD.eliminarConexiones();
    resultado = eliminadas == actuales;

    if(resultado){
      resultado = await operacionesBD.insertarConexiones(conexiones);
    }

    return resultado;
  }

  static Future<bool> actualizaConexionActiva(String clave) async {
    bool resultado = false;
    API_CONEXION respuesta = API_CONEXION("", "", "", false);

    if(clave.isNotEmpty){
      respuesta = await operacionesBD.cambiarConexionActiva(clave);
    }

    if(respuesta.FG_ACTIVA){
      resultado = await OperacionesPreferencias.insertarConexionActiva(respuesta);

      resultado = true;
    }

    return resultado;
  }

  static Future<bool> iniciaSesion(API_USUARIO usuario) async {
    bool resultado = false;
    List<String>? conexionActual = OperacionesPreferencias.consultarConexionActiva();

    if(conexionActual != null){
      String claveConexion = conexionActual[0];

      if(claveConexion.isNotEmpty){

        int idUsuario = 0;
        
        idUsuario = await operacionesBD.iniciarSesion(usuario, claveConexion);

        if(idUsuario > 0) {  //Si pudo iniciar sesión en la BD local
          resultado = await OperacionesPreferencias.insertarIdUsuario(idUsuario);
        }

      }
    }

    return resultado;
  }
  
  static Future<bool> cierraSesion() async {
    bool resultado = false;
    
    resultado = await operacionesBD.cerrarSesiones();

    if(resultado){
      resultado = await OperacionesPreferencias.insertarIdUsuario(0);
    }

    return resultado;
  }
  //========================================//

}