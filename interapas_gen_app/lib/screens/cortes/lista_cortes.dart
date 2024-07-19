
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/widgets/mensaje_fondo.dart';

class ListaCortes extends StatelessWidget {
  final String claveGrupo;
  final agrupaciones tipo;

  const ListaCortes({super.key, required this.claveGrupo, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          claveGrupo,
          maxLines: 1,
          overflow: TextOverflow.fade,
          ),
        actions: [],
      ),
      body: MensajeFondo(mensaje: "Contenido no disponible aún.")
    );
  }

}