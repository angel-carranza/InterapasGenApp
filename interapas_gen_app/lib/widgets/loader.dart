
import 'package:flutter/material.dart';

//Widget para mostrar momentaneamente durante una carga.
class Loader extends StatelessWidget {
  final String textoInformativo;  //Texto personalizable

  const Loader({super.key, this.textoInformativo = "Cargando"});
  
  @override
  Widget build(BuildContext context) {
    
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),  //Circulo animado
          const SizedBox(height: 18.0,),  //Para añadir espacio
          Text(
            textoInformativo,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,  //Tres puntos cuando el texto sea muy grande
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

  }
  
}