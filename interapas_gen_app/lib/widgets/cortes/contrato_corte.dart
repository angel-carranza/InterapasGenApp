
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/widgets/cortes/captura_corte.dart';
import 'package:interapas_gen_app/widgets/cortes/foto_corte.dart';
import 'package:intl/intl.dart';

class ContratoCorte extends StatefulWidget {
  final agrupaciones tipoGrupo;
  final K_CORTE corte;

  const ContratoCorte({super.key, required this.tipoGrupo, required this.corte});

  @override
  State<ContratoCorte> createState() => _ContratoCorteState();
}

class _ContratoCorteState extends State<ContratoCorte> {
  
  @override
  Widget build(BuildContext context) {
    String noInterior = "";
    final NumberFormat currency = NumberFormat("#,##0.00", "es_MX");

    if(widget.corte.NO_INTERIOR != null){
      if(widget.corte.NO_INTERIOR!.isNotEmpty){
        noInterior = "(${widget.corte.NO_INTERIOR})";
      }
    }

    abrirInterfazCaptura() async {

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
          child: Builder(
            builder: (context){
              double x = MediaQuery.of(context).size.width;
              double y = MediaQuery.of(context).size.height;

              return CapturaCorte(x: x, y: y, corte: widget.corte, noInterior: noInterior,);
            },
          ),
        )
      );
    }

    Color fondo = Colors.white;
    switch(widget.corte.FG_ESTADO){
      case 1:
        fondo = Colors.lightBlue;
        break;
      case 2:
        fondo = Colors.pink;
        break;
    }

    return GestureDetector(
      onTap: () async {
        await abrirInterfazCaptura();
      },
      child: Card(
        color: fondo,
        elevation: 10.0,
        shadowColor: const Color.fromARGB(49, 255, 115, 115),
        shape: const LinearBorder(),
        child: ListTile(
          title: Text(
            "${widget.corte.NB_CALLE} ${widget.corte.NO_EXTERIOR} $noInterior",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "${widget.corte.NB_COLONIA} ${widget.corte.CL_CODIGO_POSTAL} \nRuta: ${widget.corte.CL_RUTA}",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            "${currency.format(widget.corte.MN_ADEUDO)} \n ${widget.corte.NO_MESES_ADEUDO} Meses",
            maxLines: 2,
            textAlign: TextAlign.end,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }
}