
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class MenuCensos_Screen extends StatelessWidget{
  
  const MenuCensos_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Censos"),
        actions: const [],
      ),
      body: const SafeArea(child: Center(child: Text("Contenido no disponible por el momento."))),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 30.0,),
      ),
    );

  }

}