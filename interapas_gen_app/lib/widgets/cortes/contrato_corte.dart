
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:intl/intl.dart';

class ContratoCorte extends StatelessWidget {
  final agrupaciones tipoGrupo;
  final K_CORTE corte;

  const ContratoCorte({super.key, required this.tipoGrupo, required this.corte});

  @override
  Widget build(BuildContext context) {
    String noInterior = "";
    final NumberFormat currency = new NumberFormat("#,##0.00", "es_MX");

    if(corte.NO_INTERIOR != null){
      if(corte.NO_INTERIOR!.isNotEmpty){
        noInterior = "(${corte.NO_INTERIOR})";
      }
    }

    return Card(
      elevation: 10.0,
      shadowColor: Color.fromARGB(49, 255, 115, 115),
      shape: LinearBorder(),
      child: GestureDetector(
        child: ListTile(
          title: Text(
            "${corte.NB_CALLE} ${corte.NO_EXTERIOR} $noInterior",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "${corte.NB_COLONIA} ${corte.CL_CODIGO_POSTAL} \nRuta: ${corte.CL_RUTA}",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            "${currency.format(corte.MN_ADEUDO)} \n ${corte.NO_MESES_ADEUDO} Meses",
            maxLines: 2,
            textAlign: TextAlign.end,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }

}