
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/widgets/drawer_menu.dart';

class Menu_Screen extends StatelessWidget{
  
  const Menu_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(actions: [],),
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Table(
          columnWidths: <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90.0,
                    child: TextButton(
                      child: Text("Censos"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/censos");
                      },
                    ),
                    color: Color.fromARGB(60, 0, 0, 200),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90.0,
                    child: TextButton(
                      child: Text("Cortes"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/cortes");
                      },
                    ),
                    color: Color.fromARGB(60, 200, 0, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}