
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/acceso_datos/preferencias.dart';
import 'package:interapas_gen_app/data/api/API_CORTE.dart';
import 'package:interapas_gen_app/data/bd/K_CORTE.dart';
import 'package:interapas_gen_app/data/enumerados.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:interapas_gen_app/widgets/cortes/grupo_cortes.dart';
import 'package:interapas_gen_app/widgets/loader.dart';
import 'package:interapas_gen_app/widgets/mensaje_fondo.dart';

import '../../data/T_GRUPO_CORTES.dart';

class MenuCortes_Screen extends StatefulWidget{
  
  const MenuCortes_Screen({super.key});

  @override
  State<MenuCortes_Screen> createState() => _MenuCortes_ScreenState();
}

class _MenuCortes_ScreenState extends State<MenuCortes_Screen> {
  bool fgCargando = true;
  agrupaciones agrupadoActual = agrupaciones.colonia;
  List<T_GRUPO_CORTES> grupos = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    
    _sincronizarCortes().then((arg){ });
  }

  Future<void> _sincronizarCortes() async {
    setState(() {
      fgCargando = true;
    });

    List<API_CORTE>? consultaApi = await AccesoDatos.obtieneCortes();

    if(consultaApi != null){
      if(consultaApi.isNotEmpty){   //Si encontró asignaciones pendientes

        List<K_CORTE>? consultaLocales = await AccesoDatos.obtieneCortesLocales();

        if(consultaLocales != null){
          
          List<API_CORTE> nuevasAsignaciones = List.empty(growable: true);

          for (API_CORTE corte in consultaApi) {
            
            List<K_CORTE> asignacion = consultaLocales.where((w) 
              => w.ID_USUARIO == OperacionesPreferencias.consultarIdUsuario() && w.ID_CORTE_APP == corte.ID_CORTE_APP).toList();

            if(asignacion.isEmpty){
              nuevasAsignaciones.add(corte);
            }
            //Si la encuentra, entonces no hace nada, porque ya la tiene descargada
          }

          bool respuesta = await AccesoDatos.insertaCortesNuevos(nuevasAsignaciones);

          if(!respuesta){
            if(context.mounted){
              mensajeSimpleOK("Hubo un problema intentando guardar la información.", context);
            }
          }

        } else{
          if(context.mounted){
            mensajeSimpleOK("¡Hubo un problema con los datos guardados!", context);
          }
        }
      }
    } else {
      if(context.mounted){
        mensajeSimpleOK("No se pudieron obtener nuevas asignaciones", context);
      }
    }
    
    var aux = await AccesoDatos.obtieneGruposCortes(agrupadoActual);

    if(aux != null){
      grupos = aux;
    } else {
      if(context.mounted){
        mensajeSimpleOK("Hubo un error encontrando las asignaciones. Intenté sincronizar.", context);
      }
    }

    setState(() {
      fgCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Boton para cambiar agrupación
    Widget btnAgrupaciones = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
      child: SegmentedButton<agrupaciones>(
        multiSelectionEnabled: false,
        emptySelectionAllowed: false,
        segments: <ButtonSegment<agrupaciones>>[
          ButtonSegment(
            value: agrupaciones.colonia,
            label: const Text("Colonias"),
            icon: const Icon(Icons.location_city_rounded),
            enabled: !fgCargando && grupos.isNotEmpty,   //Se desactiva mientras carga para evitar dobles llamadas
          ),
          ButtonSegment(
            value: agrupaciones.calle,
            label: const Text("Calles"),
            icon: const Icon(Icons.other_houses_outlined),
            enabled: !fgCargando && grupos.isNotEmpty,   //Se desactiva mientras carga para evitar dobles llamadas
          ),
        ],
        selected: <agrupaciones>{agrupadoActual},
        onSelectionChanged: (Set<agrupaciones> seleccionNueva) {  //Al actualizar
          setState(() {
            agrupadoActual = seleccionNueva.first;
          });
      
          _sincronizarCortes();
      
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cortes"),
        actions: const [],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: fgCargando?
          <Widget>[  //Mientras está cargando
            btnAgrupaciones,
            Expanded(child: Container()),
            const Loader(textoInformativo: "Consultando..."),
            Expanded(child: Container()),
          ]  
            : ( (grupos.isEmpty) ? <Widget>[
              btnAgrupaciones,
              Expanded(child: Container()),
              const MensajeFondo(mensaje: "No se encontraron asignaciones, intenta usar el botón para sincronizar."),
              Expanded(child: Container()),
            ]
              : <Widget>[
                btnAgrupaciones,
                Expanded(
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: grupos.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: kFloatingActionButtonMargin + 56.0,
                  ),
                  itemBuilder: (context, index) => GrupoCortes(grupos[index])
                  ),
                ),
              ]
            ),
        ),
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