
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/T_GRUPO_CORTES.dart';
import 'package:interapas_gen_app/screens/cortes/lista_cortes.dart';

class GrupoCortes extends StatelessWidget {
  final T_GRUPO_CORTES grupo;

  const GrupoCortes(this.grupo, {super.key,});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 0,
      ),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            left: 12.0,
            top: 3.0,
            right: 0.0,
            bottom: 6.0,
          ),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              grupo.nombreGrupo,
              style: const TextStyle(
                fontFamily: "Montserrat_Bold",
              ),
            ),
          ),
          subtitle: Text("Asignadas: ${grupo.cantidad}"),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_outward),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ListaCortes(claveGrupo: grupo.nombreGrupo, tipo: grupo.tipoGrupo,)));
            },
          ),
        ),
      ),
    );

  }

}