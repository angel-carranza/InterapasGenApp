
import 'package:encrypt/encrypt.dart' as encriptado;

class Cifrado {
  final String llave;

  Cifrado({this.llave = "This 32 char key have 256 bits.."});

  String encriptarAEScbc(String texto){
    final encriptado.Key llaveCifrado = encriptado.Key.fromUtf8(llave);
    final encriptador = encriptado.Encrypter(encriptado.AES(llaveCifrado, mode: encriptado.AESMode.cbc));
    final initVector = encriptado.IV.fromUtf8(llave.substring(0, 16));

    return encriptador.encrypt(texto, iv: initVector).base64;
 }

}