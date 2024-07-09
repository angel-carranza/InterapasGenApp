
import 'dart:convert';

import 'package:interapas_gen_app/acceso_datos/api/default.dart';
import 'package:interapas_gen_app/acceso_datos/bd.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:http/http.dart' as http;

//Clase con todas las funciones intermediarias a 
// los diferentes tipos de datos que maneja la aplicación.
class AccesoDatos {
  
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

  static Future<List<API_CONEXION>> obtieneAPIsGuardadas() async {
    return await operacionesBD.obtenerConexiones();
  }
  
}