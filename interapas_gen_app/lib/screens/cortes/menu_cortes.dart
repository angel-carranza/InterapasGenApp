
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/widgets/loader.dart';

class MenuCortes_Screen extends StatefulWidget{
  
  const MenuCortes_Screen({super.key});

  @override
  State<MenuCortes_Screen> createState() => _MenuCortes_ScreenState();
}

class _MenuCortes_ScreenState extends State<MenuCortes_Screen> {
  bool fgCargando = true;
  agrupaciones agrupadoActual = agrupaciones.colonias;

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

    //Boton para cambiar agrupación
    Widget btnAgrupaciones = SegmentedButton<agrupaciones>(
      multiSelectionEnabled: false,
      emptySelectionAllowed: false,
      segments: <ButtonSegment<agrupaciones>>[
        ButtonSegment(
          value: agrupaciones.colonias,
          label: const Text("Colonias"),
          icon: const Icon(Icons.location_city_rounded),
          enabled: !fgCargando,   //Se desactiva mientras carga para evitar dobles llamadas
        ),
        ButtonSegment(
          value: agrupaciones.calles,
          label: const Text("Calles"),
          icon: const Icon(Icons.other_houses_outlined),
          enabled: !fgCargando,   //Se desactiva mientras carga para evitar dobles llamadas
        ),
      ],
      selected: <agrupaciones>{agrupadoActual},
      onSelectionChanged: (Set<agrupaciones> seleccionNueva) {  //Al actualizar
        setState(() {
          agrupadoActual = seleccionNueva.first;
        });

        _sincronizarCortes();

      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cortes"),
        actions: const [],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: fgCargando?
        <Widget>[  //Mientras está cargando
          btnAgrupaciones,
          Expanded(child: Container()),
          const Loader(textoInformativo: "Consultando..."),
          Expanded(child: Container()),
        ]  
          : ( (elementos < 1) ? <Widget>[const Center(child: Text("Contenido no disponible por el momento.")) ]
            : <Widget>[
              btnAgrupaciones,
              Expanded(child: Container()),
            ]
          )
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