
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interapas_gen_app/widgets/boton_modulo.dart';
import 'package:interapas_gen_app/widgets/drawer_menu.dart';

class Menu_Screen extends StatelessWidget{
  
  const Menu_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(actions: const [],),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: const <TableRow>[
            TableRow(
              children: <Widget>[
                BotonModulo(rutaModulo: "/cortes", titulo: "Cortes", icono: FontAwesomeIcons.dropletSlash, colorTarjeta: Color.fromARGB(120, 255, 0, 0),),
                //BotonModulo(rutaModulo: "/censos", titulo: "Censos", icono: Icons.edit_note_rounded, colorTarjeta: Color.fromARGB(120, 0, 0, 255),),
              ],
            ),
          ],
        ),
      ),
    );
  }

}