
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/widgets/loader.dart';

class MenuCortes_Screen extends StatefulWidget{
  
  const MenuCortes_Screen({super.key});

  @override
  State<MenuCortes_Screen> createState() => _MenuCortes_ScreenState();
}

class _MenuCortes_ScreenState extends State<MenuCortes_Screen> {
  bool fgCargando = true;


  @override
  void initState() {
    super.initState();
    
    _sincronizarCortes().then((arg){ });
  }

  Future<void> _sincronizarCortes() async {
    setState(() {
      fgCargando = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      fgCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int elementos = 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cortes"),
        actions: const [],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: fgCargando?
        [ const Loader(textoInformativo: "Consultando...")]
        : [
          Center(child: Text("Contenido no disponible por el momento."))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 30.0,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fgCargando? null:
          _sincronizarCortes,
        child: fgCargando ? const Icon(Icons.sync_disabled) :
          const Icon(Icons.sync_rounded),
      ),
    );

  }
}