
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
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

  @override
  void initState() {
    super.initState();

    _cargarContratos();
  }

  _cargarContratos() async {
    setState(() {
      fgCargando = true;
    });

    await Future.delayed(Durations.extralong4*2);

    setState(() {
      fgCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            : [
              Expanded(child: Container()),
              MensajeFondo(mensaje: "Ya cargó, pero por ahora no nada!"),
              Expanded(child: Container()),
            ]
          ,
        ),
      )
    );
  }
}