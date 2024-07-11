
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class MenuCortes_Screen extends StatelessWidget{
  
  const MenuCortes_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cortes"),
        actions: const [],
      ),
      body: const Center(child: Text("Contenido no disponible por el momento.")),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 30.0,),
      ),
    );

  }

}