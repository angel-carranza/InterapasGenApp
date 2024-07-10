
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/data/api/API_CONEXION.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:interapas_gen_app/widgets/loader.dart';

class ConexionDisponible extends StatefulWidget {
  final API_CONEXION registro;
  final Future<void> Function() cargaInicial;

  const ConexionDisponible(this.registro, this.cargaInicial, {super.key});

  @override
  State<ConexionDisponible> createState() => _ConexionDisponibleState();
}

class _ConexionDisponibleState extends State<ConexionDisponible> {
  bool fgCargando = false;

  Future<bool> _cambiarConexionActual(String clave) async {
    return await AccesoDatos.actualizaConexionActiva(clave);
  }

  @override
  Widget build(BuildContext context) {

    Widget contenido = CheckboxListTile(
        checkboxShape: const CircleBorder(),
        title: Text(
          widget.registro.CLAVE,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${widget.registro.API_PRINCIPAL_IP} - ${widget.registro.API_SECUNDARIA_IP}"
        ),
        value: widget.registro.FG_ACTIVA,
        onChanged: (bool? value) async {    //este value es el nuevo.
          if(value == true){
            setState(() {
              fgCargando = true;
            });

            if(!await _cambiarConexionActual(widget.registro.CLAVE)){
              if(context.mounted) {
                mensajeSimpleOK("Ocurrió un error interno, intenté de nuevo por favor.", context);
              }
            }
            
            await Future.delayed(Durations.extralong4);

            widget.cargaInicial();

            setState(() {
              fgCargando = false;
            });
          }
        },
      );
    
    return Card(
      child: !fgCargando ? contenido:
        const Loader(),
    );
  }
}
