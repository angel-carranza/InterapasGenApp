
import 'package:interapas_gen_app/services/local_storage.dart';

//Clase intermedia para realizar operaciones con las shared_preferences
class OperacionesPreferencias {

  int consultarIdUsuario() {
    int? entero = LocalStorage.preferencias.getInt("idUsuario");
    return entero ?? 0;
  }

  insertarIdUsuario(int p_idUsuario) async {
    bool resultado = await LocalStorage.preferencias.setInt('idUsuario', p_idUsuario);
    return resultado;
  }
}