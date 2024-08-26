
// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:io';

import 'package:interapas_gen_app/data/api/API_ADEUDO.dart';
import 'package:interapas_gen_app/services/base_datos.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:interapas_gen_app/data/api/API_USUARIO.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:sqflite/sqflite.dart';

import '../data/T_GRUPO_CORTES.dart';
import '../data/api/API_CORTE.dart';
import '../data/bd/K_CORTE.dart';

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

  static Future<int> iniciarSesion(API_USUARIO usuario, String conexion) async {
    int idUsuario = 0;    //Valor que va a retornar.
    Database local = await BaseDatos.bd.database;
    
    //Primero checa si ya existe el usuario en el telefono
    final maps = await local.query(
      "S_SESION_USUARIO",
      columns: [
        "ID_USUARIO"
      ],
      where: "ID_EMPLEADO = ? AND CL_CONEXION = ? ",
      whereArgs: [usuario.ID_EMPLEADO, conexion]
    );

    if(maps.isEmpty){ //Si no existia previamente, crea el registro.

      idUsuario = await local.insert(
        "S_SESION_USUARIO",
        {
          "ID_EMPLEADO" : usuario.ID_EMPLEADO,
          "CL_USUARIO" : usuario.CL_USUARIO,
          "CL_CONEXION" : conexion,
          "FG_ACTIVO": true,
        }
      );
      
    } else {    //Si ya existía, lo activa, para iniciar sesión.
      idUsuario = maps.first["ID_USUARIO"] as int;

      int respuesta = await local.update(
        "S_SESION_USUARIO",
        { "FG_ACTIVO": true, },
        where: "ID_USUARIO = ? AND ID_EMPLEADO = ? AND CL_CONEXION = ? ",
        whereArgs: [idUsuario, usuario.ID_EMPLEADO, conexion],
      );

      if(respuesta < 1) idUsuario = 0;
    }

    return idUsuario;
  }

  static Future<bool> cerrarSesiones() async {
    bool resultado = false;

    try {
      Database local = await BaseDatos.bd.database;

      int respuesta = await local.update(
        "S_SESION_USUARIO",
        {"FG_ACTIVO" : false},
      );

      if(respuesta > 0){
        resultado = true;
      }
    } on Exception catch(_) {
      return false;
    }

    return resultado;
  }

  static Future<List<K_CORTE>> obtenerCortes(int idUsuario) async {
    List<K_CORTE> resultado = List.empty(growable: true);
    Database local = await BaseDatos.bd.database;

    final maps = await local.query(
      "K_CORTE",
      where: "ID_USUARIO = ?",
      whereArgs: [idUsuario],
    );

    for(var map in maps){
      resultado.add(K_CORTE.fromJson(map));
    }

    return resultado;
  } 

  static Future<bool> insertarCortes(List<API_CORTE> nuevas) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;
    Batch batch = local.batch();

    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0){
      try {
        
        for(API_CORTE nuevo in nuevas){
          batch.insert(
            "K_CORTE",
            K_CORTE.fromAPItoJson(idUsuario, nuevo),
          );
        }

        batch.commit();   //Ejecuta todas las inserciones
        resultado = true;

      } on Exception catch(_){
        resultado = false;
      }
    }

    return resultado;
  }

  static Future<List<T_GRUPO_CORTES>> obtenerGruposCortes(agrupaciones tipo, int idUsuario) async {
    Database local = await BaseDatos.bd.database;

    String columnaAgrupar;

    switch(tipo){
      case agrupaciones.calle:
        columnaAgrupar = "NB_CALLE";
        break;
      case agrupaciones.colonia:
        columnaAgrupar = "NB_COLONIA";
        break;
    }

    List<T_GRUPO_CORTES> resultado = List.empty(growable: true);

    final maps = await local.rawQuery('''
      SELECT
        $columnaAgrupar AS NB_GRUPO
        , COUNT(ID_CORTE) AS CUENTA

        FROM K_CORTE

        WHERE ID_USUARIO = $idUsuario

        GROUP BY $columnaAgrupar
    ''');

    for(var map in maps){
      resultado.add(T_GRUPO_CORTES(tipo, (map["NB_GRUPO"] as String), map["CUENTA"] as int));
    }

    return resultado;
  }

  static Future<List<K_CORTE>> obtenerCortesDeGrupo(int idUsuario, agrupaciones tipo, String clave) async {
    List<K_CORTE> resultado = List.empty(growable: true);
    Database local = await BaseDatos.bd.database;

    String columnaGrupo;

    switch(tipo){
      case agrupaciones.colonia:
        columnaGrupo = "NB_COLONIA";
        break;
      case agrupaciones.calle:
        columnaGrupo = "NB_CALLE";
        break;
    }

    final maps = await local.query(
      "K_CORTE",
      where: "ID_USUARIO = ? AND $columnaGrupo = ? ",
      whereArgs: [idUsuario, clave],
    );

    for (var map in maps){
      resultado.add(K_CORTE.fromJson(map));
    }

    return resultado;
  }

  static Future<bool> agregarFotoCorte(int idUsuario, int idCorte, String dirNuevaFoto) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;

    var maps = await local.query(
      "K_CORTE",
      columns: ["DS_FOTOS"],
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    String valorAnterior = "";
    if(maps.isNotEmpty) {
      valorAnterior = (maps.first["DS_FOTOS"] as String?) ?? "";
    }

    int respuesta = await local.update(
      "K_CORTE",
      {"DS_FOTOS" : "${valorAnterior.isEmpty? "" : "$valorAnterior@"}$dirNuevaFoto"},
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    if(respuesta > 0){
      resultado = true;
    }

    return resultado;
  }

  static Future<List<String>> obtenerFotosObservaciones(int idUsuario, int idCorte) async {
    List<String> resultado = List.empty(growable: true);
    Database local = await BaseDatos.bd.database;

    var maps = await local.query(
      "K_CORTE",
      columns: [
        "DS_FOTOS",
        "DS_OBSERVACIONES"
      ],
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    if(maps.isNotEmpty){
      resultado.add((maps.first["DS_FOTOS"] as String?) ?? "");
      resultado.add((maps.first["DS_OBSERVACIONES"] as String?) ?? "");
    }
    
    return resultado;
  }

  static Future<bool> eliminarFotoCorte(int idUsuario, int idCorte, String dirFoto) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;

    var maps = await local.query(
      "K_CORTE",
      columns: ["DS_FOTOS"],
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    String valorAnterior = "";
    if(maps.isNotEmpty) {
      valorAnterior = (maps.first["DS_FOTOS"] as String?) ?? "";
    }

    valorAnterior = valorAnterior.replaceAll(dirFoto, "");
    valorAnterior = valorAnterior.replaceAll("@@", "@");
    if(valorAnterior == "@") valorAnterior = "";
    if(valorAnterior.length > 2){
      if(valorAnterior[0] == '@') valorAnterior = valorAnterior.substring(1);
      if(valorAnterior[valorAnterior.length - 1] == '@') valorAnterior = valorAnterior.substring(0, valorAnterior.length-2);
    }

    int respuesta = await local.update(
      "K_CORTE",
      {"DS_FOTOS" : valorAnterior},
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    if(respuesta > 0){
      File fotoEnCache = File(dirFoto);

      await fotoEnCache.delete();

      resultado = true;
    }

    return resultado;
  }

  static Future<bool> guardarCorte(int idUsuario, K_CORTE corte) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;
    
    int respuesta = await local.update(
      "K_CORTE",
      corte.toJson(),
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, corte.ID_CORTE]
    );

    if(respuesta > 0) {
      resultado = true;
    }

    return resultado;
  }

  static Future<bool> eliminarEnviado(int idUsuario, K_CORTE corte) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;

    int respuesta = await local.delete(
      "K_CORTE",
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, corte.ID_CORTE],
    );

    if(respuesta > 0) {
      resultado = true;
    }

    return resultado;
  }

  static Future<bool> actualizarSaldoCorte(int idUsuario, int idCorte, API_ADEUDO adeudo) async {
    bool resultado = false;
    Database local = await BaseDatos.bd.database;
    
    int respuesta = await local.update(
      "K_CORTE",
      {
        "MN_ADEUDO" : adeudo.MN_ADEUDO,
        "NO_MESES_ADEUDO" : adeudo.NO_MESES,
      },
      where: "ID_USUARIO = ? AND ID_CORTE = ? ",
      whereArgs: [idUsuario, idCorte],
    );

    if(respuesta > 0) {
      resultado = true;
    }

    return resultado;
  }

}