
// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';

class generalAPI {
  String urlApi = "";
  String servidorAPI = "";

  Future<bool> comprobarConexion() async {
    //Checa si ya hay una conexión activa.
    List<String>? conexionActual = OperacionesPreferencias.consultarConexionActiva();

    if(conexionActual == null || conexionActual.first.isEmpty){
      List<API_CONEXION> locales = await AccesoDatos.obtieneAPIsGuardadas();

      if(locales.isEmpty){
        return false;
      }

      String claveConexionActiva = locales.where((w) => w.FG_ACTIVA).first.CLAVE;

      await AccesoDatos.actualizaConexionActiva(claveConexionActiva);

      conexionActual = OperacionesPreferencias.consultarConexionActiva();

      if(conexionActual == null) return false;
    }

    urlApi = conexionActual[1];
    servidorAPI = conexionActual[2];

    bool fgReintentar = true;
    int i = 0;

    while(fgReintentar && i < 3){    
      fgReintentar = false;
      i++;
      
      http.Response response = await getBandera();

      if(response.statusCode == 401){   //Si la respuesta es que el token no esta autorizado
        await OperacionesPreferencias.insertarToken(await authorize());
        fgReintentar = true;
      } else {
        if(response.statusCode != 200){
          urlApi = conexionActual[3];
          servidorAPI = conexionActual[4];

          http.Response response = await getBandera();

          if(response.statusCode == 401){   //Si la respuesta es que el token no esta autorizado
            await OperacionesPreferencias.insertarToken(await authorize());
            fgReintentar = true;
          } else {
            if(response.statusCode != 200){
              return false;
            }
            return true;
          }
        } else {
          return true;
        }

      }

    }


    return false;
  }

  Future<http.Response> getBandera() async {
    http.Response response = http.Response("", 900);
    final Uri urlGet = Uri.http(servidorAPI, "$urlApi/General/GetBandera");
    String token = "Bearer ${OperacionesPreferencias.consulatarToken()}";

    try {
      response = await http.get(
        urlGet,
        headers: <String, String> {
          "Authorization": token
        }
      ).timeout(const Duration(seconds: 5));
    } on Exception catch(_){
      response = http.Response("", 901);
    }

    return response;
  }

  Future<String> authorize() async {
    http.Response response = http.Response("", 404);

    final Uri urlPost = Uri.http(servidorAPI, "$urlApi/Token/Authenticate");

    try {
      response = await http.post(
        urlPost,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
            "username": "InterapasPrueba",
            "password": "Interapas99",
        })
      ).timeout(const Duration(seconds: 5));
    } on Exception catch(_){
      return "3RR0R";
    }

    return response.body;
  }

  Future<http.Response> getAcceso(String p_clUsuario, String p_nbPassword) async {
    http.Response response = http.Response("", 900);

    if(await comprobarConexion()){

      final Uri urlGet = Uri.http(servidorAPI, "$urlApi/General/GetAcceso");
      http.Request request = http.Request(
        "GET",
        urlGet,
      )..headers.addAll({
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${OperacionesPreferencias.consulatarToken()}",
      });

      request.body = jsonEncode({
        "username" : p_clUsuario,
        "password" : p_nbPassword,
      });

      try{
        var streamedResponse = await request.send().timeout(const Duration(seconds: 10));
        response = await http.Response.fromStream(streamedResponse);
      } on Exception catch(_) {
        response = http.Response("", 901);
      }
    } else {
      response = http.Response("Hubo un error de conexión.", 902);
    }

    return response;
  }


}