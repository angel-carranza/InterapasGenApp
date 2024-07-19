
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



      listaCortes = aux;
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
                    padding: EdgeInsets.only(bottom: 60.0),
                    itemBuilder: (context, index) => ContratoCorte(tipoGrupo: widget.tipo, corte: listaCortes[index])
                  ),
                )
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