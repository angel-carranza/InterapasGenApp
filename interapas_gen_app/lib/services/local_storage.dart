
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences preferencias;   //Variable a la que se llama para consultarla

  static Future<void> configurarPrefs() async{
    preferencias = await SharedPreferences.getInstance();
  }
}