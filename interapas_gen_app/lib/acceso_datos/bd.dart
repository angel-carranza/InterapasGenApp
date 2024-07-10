
// ignore_for_file: camel_case_types

import 'dart:convert';

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

  static Future<int> eliminarConexiones() async {
    Database local = await BaseDatos.bd.database;

    int resultado = await local.delete("S_CONEXION");

    return resultado;
  }

  static Future<bool> insertarConexiones(List<API_CONEXION> nuevas) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;
    Batch batch = local.batch();

    try{

      for(API_CONEXION conexion in nuevas){
        batch.insert(
          "S_CONEXION",
          conexion.toJson()
        );
      }

      batch.commit();   //Ejecuta todas las inserciones
      resultado = true;

    } on Exception catch(_){
      resultado = false;
    }

    return resultado;
  }

  static Future<API_CONEXION> cambiarConexionActiva(String claveConexion) async {
    API_CONEXION resultado = API_CONEXION("", "", "", false);

    try{
      Database local = await BaseDatos.bd.database;

      int respuesta = await local.update(
        "S_CONEXION",
        json.decode("{\"FG_ACTIVA\": 0}"),
        where: "FG_ACTIVA = 1"
      );

      if(respuesta > 0){
        respuesta = await local.update(
          "S_CONEXION",
          json.decode("{\"FG_ACTIVA\": 1}"),
          where: "CL_API = ?",
          whereArgs: [claveConexion]
        );
      
        final maps = await local.query(
          "S_CONEXION",
          columns: [
            "CL_API"
            , "API_PRIMARIA"
            , "DIR_PRIMARIA"
            , "API_SECUNDARIA"
            , "DIR_SECUNDARIA"
            , "FG_ACTIVA"
          ],
          where: " FG_ACTIVA = 1",
        );
    
        List<API_CONEXION> listaAux = List<API_CONEXION>.empty(growable: true);

        for(var map in maps){
          listaAux.add(API_CONEXION.fromJson(map));
        }
      
        if(listaAux.isNotEmpty) {
          resultado = listaAux.first;
        }
      }

      return resultado;

    } on Exception catch(_) {
      return API_CONEXION("", "", "", false);
    }
  }
}