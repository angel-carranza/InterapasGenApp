
import 'dart:convert';

import 'package:interapas_gen_app/acceso_datos/api/cortes.dart';
import 'package:interapas_gen_app/acceso_datos/api/default.dart';
import 'package:interapas_gen_app/acceso_datos/api/general.dart';
import 'package:interapas_gen_app/acceso_datos/bd.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/data/api/API_ADEUDO.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:http/http.dart' as http;
import 'package:interapas_gen_app/data/api/API_CORTE.dart';
import 'package:interapas_gen_app/data/api/API_CORTE_ENVIO.dart';
import 'package:interapas_gen_app/data/api/API_USUARIO.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';

import '../data/T_GRUPO_CORTES.dart';

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

  static Future<List<API_CORTE>?> obtieneCortes() async {
    List<API_CORTE>? resultado = List.empty(growable: true);
    cortesAPI api = cortesAPI();

    int idEmpleado = OperacionesPreferencias.consultarIdEmpleado();

    if(idEmpleado > 0){
      
      http.Response r = await api.getCortes(idEmpleado);

      if(r.statusCode == 200) {
        var cuerpo = json.decode(r.body);

        for(var registro in cuerpo) {
          resultado.add(API_CORTE.fromJsonAPI(registro));
        }
      }
      else {
        resultado = null;
      }
      
    }

    return resultado;
  }

  static Future<bool> enviaCorte(K_CORTE corte) async {
    bool resultado = false;

    try{
      cortesAPI api = cortesAPI();

      int idEmpleado = OperacionesPreferencias.consultarIdEmpleado();

      if(idEmpleado > 0) {
        API_CORTE_ENVIO corteEnvio = await API_CORTE_ENVIO.fromCorte(corte, idEmpleado);

        http.Response respuesta = await api.setCorte(corteEnvio.toJson()); 

        switch(respuesta.statusCode) {
          case 200:
            resultado = true;
          default:
            resultado = false;
        }
      }
    } on Exception catch (_) {
      resultado = false;
    }
    
    return resultado;
  }
  
  static Future<bool> actualizarAdeudo(int idContrato, int idCorte, String clInternet) async {
    bool resultado = false;
    generalAPI api = generalAPI();

    try {
      http.Response r = await api.getAdeudo(idContrato, clInternet);

      if(r.statusCode == 200){
        Map<String, Object?> cuerpo = (json.decode(r.body) as List).first;

        int idUsuario = OperacionesPreferencias.consultarIdUsuario();

        if(idUsuario > 0){
          API_ADEUDO adeudoNuevo = API_ADEUDO.fromJsonAPI(cuerpo);
          
          resultado = await operacionesBD.actualizarSaldoCorte(idUsuario, idCorte, adeudoNuevo);
        }
      } else {
        resultado = false;
      }
    } on Exception catch(_){
      resultado = false;
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
          resultado = await OperacionesPreferencias.insertarIdEmpleado(usuario.ID_EMPLEADO);
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
      resultado = await OperacionesPreferencias.insertarIdEmpleado(0);
    }

    return resultado;
  }

  static Future<List<K_CORTE>?> obtieneCortesLocales() async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0){

      return await operacionesBD.obtenerCortes(idUsuario);

    } else {
      return null;
    }
  }

  static Future<bool> insertaCortesNuevos(List<API_CORTE> nuevos) async => await operacionesBD.insertarCortes(nuevos);

  static Future<List<T_GRUPO_CORTES>?> obtieneGruposCortes(agrupaciones agrupacion) async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      return await operacionesBD.obtenerGruposCortes(agrupacion, idUsuario);
    } else {
      return null;
    }
  }

  static Future<List<K_CORTE>?> obtieneCortesGrupoLocal(agrupaciones tipo, String clave) async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      return await operacionesBD.obtenerCortesDeGrupo(idUsuario, tipo, clave);
    } else {
      return null;
    }
  }

  static Future<bool> agregaFotoCorte(int idCorte, String dirNuevaFoto) async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      return await operacionesBD.agregarFotoCorte(idUsuario, idCorte, dirNuevaFoto);
    } else{
      return false;
    }

  }

  static Future<List<String>?> obtieneFotosObservacionesCorte(int idCorte) async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0){
      return await operacionesBD.obtenerFotosObservaciones(idUsuario, idCorte);
    } else {
      return null;
    }
  }

  static Future<bool> eliminaFotoCorte(int idCorte, String dirFoto) async {
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      return await operacionesBD.eliminarFotoCorte(idUsuario, idCorte, dirFoto);
    } else{
      return false;
    }
  }

  static Future<int> guardarEnviarCorte(K_CORTE corte) async {
    int resultado = 0;
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      bool respuesta = await operacionesBD.guardarCorte(idUsuario, corte);

      if(respuesta) {
        resultado = 1;  //Sí guardó

        respuesta = await enviaCorte(corte);

        if(respuesta){
          resultado = 2;  //Sí envío

          respuesta = await operacionesBD.eliminarEnviado(idUsuario, corte);

          if(respuesta){
            resultado = 3;
          }
        }
      }
    }

    return resultado;
  }

  static Future<bool> guardarCorte(K_CORTE corte) async {
    bool resultado = false;
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0){
      return await operacionesBD.guardarCorte(idUsuario, corte);
    }

    return resultado;
  }

  static Future<int> enviarCorteGuardado(K_CORTE corte) async {
    int resultado = 0;
    int idUsuario = OperacionesPreferencias.consultarIdUsuario();

    if(idUsuario > 0) {
      bool respuesta = await enviaCorte(corte);

      if(respuesta){
        resultado = 2;  //Sí envío

        respuesta = await operacionesBD.eliminarEnviado(idUsuario, corte);

        if(respuesta){
          resultado = 3;
        }
      }
    }

    return resultado;
  }
  //========================================//

}