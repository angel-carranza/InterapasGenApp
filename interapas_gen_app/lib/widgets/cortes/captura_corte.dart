
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:interapas_gen_app/widgets/loader.dart';
import 'package:text_scroll/text_scroll.dart';

import 'foto_corte.dart';

class CapturaCorte extends StatefulWidget {
  final double x, y;
  final String noInterior;
  final K_CORTE corte;
  const CapturaCorte({super.key, required this.x, required this.y, required this.corte, required this.noInterior});

  @override
  State<CapturaCorte> createState() => _CapturaCorteState();
}

class _CapturaCorteState extends State<CapturaCorte> {
  bool fgCargando = false;
  final TextEditingController controlador = TextEditingController();


  @override
  void initState() {
    super.initState();

    _cargarFotos();
  }

  void _cargarFotos() async {
    setState(() {
      fgCargando = true;
    });

    List<String>? aux = await AccesoDatos.obtieneFotosObservacionesCorte(widget.corte.ID_CORTE);

    if(aux != null) {
      widget.corte.DS_FOTOS = aux[0];
      widget.corte.DS_OBSERVACIONES = aux[1];
    } else {
      if(context.mounted){
        mensajeSimpleOK("No se pudieron cargar los datos, intente de nuevo.", context);
      }
    }

    setState(() {
      fgCargando = false;
    });
  }
  
  Future<void> _guardarCorte() async {
    await AccesoDatos.guardarCorte(widget.corte);
  }

  @override
  Widget build(BuildContext context) {

    controlador.text = widget.corte.DS_OBSERVACIONES ?? "";

    widget.corte.DS_FOTOS ??= "";
    List<String> listaFotos = widget.corte.DS_FOTOS!.split('@');
    String vacio = "";
    if(widget.corte.DS_FOTOS == ""){
      vacio = listaFotos.removeAt(0);
    }
      
    if(listaFotos.length < 5) listaFotos.add(vacio);

    return Container(
      height: widget.y / 1.25,
      width: widget.x - 24.0,
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 24.0,
      ),
      child: fgCargando ?
      const Loader(textoInformativo: "Cargando datos")
      : Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextScroll(
            "${widget.corte.NB_CALLE} ${widget.corte.NO_EXTERIOR} ${widget.noInterior}",
            numberOfReps: 3,
            intervalSpaces: 10,
            mode: TextScrollMode.endless,
            delayBefore: Durations.extralong4 * 3,
            pauseBetween: Durations.extralong4 * 5,
            velocity: const Velocity(pixelsPerSecond: Offset(40,0)),
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Montserrat_Medium",
              color: Theme.of(context).colorScheme.secondary
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          TextField(
            minLines: 1,
            maxLines: 6,
            expands: false,
            maxLength: 900,
            controller: controlador,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),

            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                )
              ),
              labelText: "Observaciones",
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              )
            ),
            onChanged: (value) {
              widget.corte.DS_OBSERVACIONES = value;
            },
          ),
          Container(height: 24.0,),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaFotos.length,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 12.0),
              itemBuilder: (context, index) => FotoCorte(
                idCorte: widget.corte.ID_CORTE,
                dirImagen: listaFotos[index],
                saveFunction: _guardarCorte,
                callbackFunction: _cargarFotos,
              ),
            ),
          ),
          Container(height: 18.0,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () async {
              if(widget.corte.DS_FOTOS != null){
                if(widget.corte.DS_FOTOS != ""){
                  widget.corte.FG_ESTADO = 1;    //Estado de corte guardado
                  widget.corte.FE_CAPTURA = DateTime.now();

                  int respuesta = await AccesoDatos.guardarEnviarCorte(widget.corte);

                  if(respuesta > 0){
                    if(context.mounted){
                      Navigator.of(context).pop();
                    }

                    if(respuesta > 1){
                      if(context.mounted){
                        Navigator.of(context).pop();
                        mensajeSimpleOK("Enviado con éxito", context);
                      }
                    } else {
                      if(context.mounted){
                        mensajeSimpleOK("Se guardó pero no se pudo enviar, intente más tarde.", context);
                      }
                    }
                  } else {
                    if(context.mounted){
                      mensajeSimpleOK("Hubo un problema, vuelva a intentar.", context);
                    }
                  }
                }
                else {
                  mensajeSimpleOK("¡No puede enviar la información sin una foto!", context);
                }
              }
              else {
                mensajeSimpleOK("¡No puede enviar la información sin una foto!", context);
              }
            },
            child: const Text("Guardar y enviar"),
          ),
          Container(height: 18.0,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Theme.of(context).colorScheme.primary)
              )
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Cancelar y enviar"),
                  content: const Text("¿Seguro que quieres cancelar el corte? (Las fotos y observaciones capturadas se enviarán de igual forma)."),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        widget.corte.FG_ESTADO = -1;    //Estado de cancelado
                        widget.corte.FE_CAPTURA = DateTime.now();
                        int respuesta = await AccesoDatos.guardarEnviarCorte(widget.corte);

                        if(respuesta > 0){
                          if(context.mounted){
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }

                          if(respuesta > 1){

                          } else {
                            if(context.mounted){
                              mensajeSimpleOK("Se guardó pero no se pudo enviar, intente más tarde.", context);
                            }
                          }
                        } else {
                          if(context.mounted){
                            mensajeSimpleOK("Hubo un problema, vuelva a intentar.", context);
                          }
                        }
                      },
                      child: const Text("Sí"),
                    ),
                    TextButton(
                      onPressed: (){
                        if (!context.mounted) return;
                          Navigator.of(context).pop();
                      },
                      child: const Text("No")
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              "Cancelar corte",
              style: TextStyle(fontFamily: "Montserrat_Medium"),
            ),
          ),
        ],
      ),
    );

  }
}
