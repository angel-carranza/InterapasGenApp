
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:interapas_gen_app/widgets/cortes/contrato_corte.dart';
import 'package:interapas_gen_app/widgets/loader.dart';
import 'package:interapas_gen_app/widgets/mensaje_fondo.dart';

class ListaCortes extends StatefulWidget {
  final String claveGrupo;
  final agrupaciones tipo;

  const ListaCortes({super.key, required this.claveGrupo, required this.tipo});

  @override
  State<ListaCortes> createState() => _ListaCortesState();
}

class _ListaCortesState extends State<ListaCortes> {
  bool fgCargando = true;
  List<K_CORTE> listaCortes = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    _cargarContratos();
  }

  _cargarContratos() async {
    setState(() {
      fgCargando = true;
    });

    List<K_CORTE>? aux = await AccesoDatos.obtieneCortesGrupoLocal(widget.tipo, widget.claveGrupo);

    if(aux != null){

      for(K_CORTE corte in aux){
        await AccesoDatos.actualizarAdeudo(corte.ID_CONTRATO, corte.ID_CORTE, corte.CL_INTERNET);
      }

      aux = await AccesoDatos.obtieneCortesGrupoLocal(widget.tipo, widget.claveGrupo);    //Vuelve a consultar para actualizar los montos.

      if(aux != null){
        listaCortes = aux;
      }

    } else {
      if(context.mounted){
        mensajeSimpleOK("Hubo un error al cargar los datos, intente de nuevo por favor.", context);
      }
    }

    setState(() {
      fgCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int numeroCortes = listaCortes.length;
    int numeroGuardados = listaCortes.where((w) => w.FG_ESTADO != 0).toList().length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.claveGrupo,
          maxLines: 1,
          overflow: TextOverflow.fade,
          ),
        actions: const [],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: fgCargando ?
            <Widget>[
              Expanded(child: Container()),
              const Loader(textoInformativo: "Cargando datos..."),
              Expanded(child: Container()),
            ]
            : (numeroCortes > 0 ?
              [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numeroCortes,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 60.0),
                    itemBuilder: (context, index) => ContratoCorte(tipoGrupo: widget.tipo, corte: listaCortes[index])
                  ),
                ),
                Container(height: 12.0,),
                (numeroGuardados > 0) ? 
                ElevatedButton(
                  onPressed: () async {
                    List<K_CORTE> listaGuardados = listaCortes.where((w) => w.FG_ESTADO != 0).toList();

                    for(K_CORTE corte in listaGuardados){
                      await AccesoDatos.enviarCorteGuardado(corte);
                    }

                    _cargarContratos();
                  },
                  child: const Text("Enviar capturados"),
                )
                : Container(height: 0.0,),
                Container(height: 24.0,)
              ]
              : [
                Expanded(child: Container()),
                const MensajeFondo(mensaje: "No se encontrarón registros para capturar."),
                Expanded(child: Container()),
              ]
            ),
        ),
      )
    );
  }
}