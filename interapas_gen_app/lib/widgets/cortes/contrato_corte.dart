
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/widgets/cortes/foto_corte.dart';
import 'package:intl/intl.dart';

class ContratoCorte extends StatelessWidget {
  final agrupaciones tipoGrupo;
  final K_CORTE corte;

  const ContratoCorte({super.key, required this.tipoGrupo, required this.corte});


  @override
  Widget build(BuildContext context) {
    String noInterior = "";
    final NumberFormat currency = NumberFormat("#,##0.00", "es_MX");
    final TextEditingController controlador = TextEditingController();

    if(corte.NO_INTERIOR != null){
      if(corte.NO_INTERIOR!.isNotEmpty){
        noInterior = "(${corte.NO_INTERIOR})";
      }
    }

    controlador.text = corte.DS_OBSERVACIONES ?? "";

  abrirInterfazCaptura() async {
    corte.DS_FOTOS ??= "";
    List<String> listaFotos = corte.DS_FOTOS!.split('@');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
        ),
        child: Builder(
          builder: (context){
            double x = MediaQuery.of(context).size.width;
            double y = MediaQuery.of(context).size.height;

            return Container(
              height: y / 1.5,
              width: x - 24.0,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${corte.NB_CALLE} ${corte.NO_EXTERIOR} $noInterior"
                  ),
                  TextField(
                    minLines: 1,
                    maxLines: 6,
                    expands: false,
                    maxLength: 900,
                    controller: controlador,
                  ),
                  Container(height: 24.0,),
                  Expanded(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: listaFotos.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => FotoCorte(
                          idCorte: corte.ID_CORTE,
                          dirImagen: listaFotos[index],
                        ),
                      ),
                    ),
                  ),
                  Container(height: 18.0,),
                  ElevatedButton(
                    onPressed: () { },
                    child: const Text("Guardar y enviar"),
                  ),
                ],
              ),
            );
          },
        ),
      )
    );
  }

    return GestureDetector(
      onTap: () async {
        await abrirInterfazCaptura();
      },
      child: Card(
        elevation: 10.0,
        shadowColor: Color.fromARGB(49, 255, 115, 115),
        shape: LinearBorder(),
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