
import 'package:interapas_gen_app/acceso_datos/base_datos.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:sqflite/sqflite.dart';

class operacionesBD {
  
  static Future<List<API_CONEXION>> obtenerConexiones() async {
    Database local = await BaseDatos.bd.database;

    final maps = await local.query(
      "S_CONEXION",
      columns: [
        "CL_API"
        , "API_PRIMARIA"
        , "DIR_PRIMARIA"
        , "API_SECUNDARIA"
        , "DIR_SECUNDARIA"
        , "FG_ACTIVA"
      ]
    );

    List<API_CONEXION> resultado = List<API_CONEXION>.empty(growable: true);

    for(var map in maps){
      resultado.add(API_CONEXION.fromJson(map));
    }

    return resultado;
  }
}