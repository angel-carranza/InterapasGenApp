
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
      body: Center(
        child: Text("Bienvenido, este será el menú principal"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 30.0,),
      ),
    );
  }

}