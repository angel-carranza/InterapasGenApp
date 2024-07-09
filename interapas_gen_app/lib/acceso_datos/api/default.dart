
// ignore_for_file: camel_case_types

//Clase con las llamadas a la APÍ de distribución de la app.
import 'package:http/http.dart' as http;

class defaultAPI {
  static const String servidorAPI = '192.168.1.243';
  static const String urlAPI = 'API_DISTRIBUCION/api/Datos';

  static Future<http.Response> getAPIs(){
    final Uri instruccionGet = Uri.http(servidorAPI, "$urlAPI/GetAPIs");

    Future<http.Response> response = http.get(instruccionGet);

    return response;
  }
}