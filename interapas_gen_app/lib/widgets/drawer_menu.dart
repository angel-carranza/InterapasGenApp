
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerMenu extends StatelessWidget {
  
  const DrawerMenu({super.key});


  @override
  Widget build(BuildContext context) {
    String version = "";  
    
    PackageInfo.fromPlatform().then((packageInfo) {
      version = packageInfo.version;
    });

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 36.0,),
          Image.asset("lib/assets/img/logo.png"),
          DrawerHeader(
            child: Text(
              "Bienvenido \n ${OperacionesPreferencias.consultarNbEmpleado()}",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            OperacionesPreferencias.consultarConexionActiva() != null ? OperacionesPreferencias.consultarConexionActiva()!.first : "",
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontFamily: "monospace",
            ),
          ),
          Expanded(child: Container()),
          ListTile(
            title: const Text("Cerrar sesión"),
            leading: const Icon(Icons.arrow_back_rounded),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Cerrar sesión"),
                  content: const Text(
                    "No se eliminará nada de información, pero para volver a ingresar con este usuario tendrá que usar su contraseña.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if(await AccesoDatos.cierraSesion()){
                          if (context.mounted){
                            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                          }
                        } else {
                          if (context.mounted){
                            mensajeSimpleOK("Hubo un problema cerrando sesión, intente de nuevo.", context);
                          }
                        } 
                      },
                      child: const Text("Aceptar"),
                    ),
                    TextButton(
                      onPressed: () {
                        if(context.mounted){
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Cancelar"),
                    )
                  ],
                ),
              );
            }
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 6.0,
            ),
            child: Text(
              version
            ),
          ),
          const SizedBox(height: 30.0,),
        ],
      ),
    );

  }
  
}