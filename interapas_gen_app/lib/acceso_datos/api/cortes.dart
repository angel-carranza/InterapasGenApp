
// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../data/api/API_CONEXION.dart';
import '../acceso_datos.dart';
import '../preferencias.dart';

class cortesAPI {
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

    try {
      final Uri urlGet = Uri.http(servidorAPI, "$urlApi/General/GetBandera");
      String token = "Bearer ${OperacionesPreferencias.consulatarToken()}";

      response = await http.get(
        urlGet,
        headers: <String, String> {
          "Authorization": token
        }
      );
    } on SocketException catch(_) {
      response = http.Response("", 900);
    }
    
    return response;
  }

  Future<String> authorize() async {
    http.Response response = http.Response("", 404);

    final Uri urlPost = Uri.http(servidorAPI, "$urlApi/Token/Authenticate");

    response = await http.post(
      urlPost,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
          "username": "InterapasPrueba",
          "password": "Interapas99",
      })
    );

    return response.body;
  }

  Future<http.Response> getCortes(int idEmpleado) async {
    http.Response response = http.Response("", 901);

    if(await comprobarConexion()){
      final Uri urlGet = Uri.http(servidorAPI, "$urlApi/Cortes/GetCortes", {"idEmpleado" : idEmpleado.toString()});

      response = await http.get(
        urlGet,
        headers: {"Authorization" : "Bearer ${OperacionesPreferencias.consulatarToken()}" }
      );

      return response;
    } else {
      response = http.Response("Hubo un error de conexión.", 902);
    }

    return response;
  }

  Future<http.Response> setCorte(Object? cuerpo) async {
    http.Response response = http.Response("", 404);

    if(await comprobarConexion()){
      final urlPost = Uri.http(servidorAPI, "$urlApi/Cortes/SetCorte");

      var cuerpoJson = jsonEncode(cuerpo);

      response = await http.post(
        urlPost,
        headers: <String, String> {
          "Authorization" : "Bearer ${OperacionesPreferencias.consulatarToken()}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: cuerpoJson,
      );
    } else {
      response = http.Response("Hubo un error de conexión.", 902);
    }

    return response;
  }
  
  Future<http.Response> getAdeudo(int idContrato, String clInternet) async {
    http.Response response = http.Response("", 901);

    if(await comprobarConexion()){
      final Uri urlGet = Uri.http(servidorAPI, "$urlApi/Cortes/GetAdeudoCorte");
      http.Request request = http.Request(
        "GET",
        urlGet,
      )..headers.addAll({
        "Content-Type" : "application/json",
        "Authorization" : "Bearer ${OperacionesPreferencias.consulatarToken()}",
      });

      request.body = jsonEncode({
        "claveCuenta" : idContrato,
        "claveInternet" : clInternet,
      });

      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } else {
      response = http.Response("Hubo un error de conexión.", 902);
    }

    return response;
  }

}