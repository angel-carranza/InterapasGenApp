
import 'package:flutter/material.dart';

class BotonModulo extends StatelessWidget {
  final String rutaModulo;
  final String titulo;
  final Color colorTarjeta;
  final IconData icono;

  const BotonModulo({super.key, this.colorTarjeta = Colors.black, this.icono = Icons.apps_rounded, required this.rutaModulo, required this.titulo});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: colorTarjeta,
        child: SizedBox(
          height: 90.0,
          child: Column(
            children: [
              Container(height: 12.0,),
              IconButton(
                icon: Icon(
                  icono,
                  size: 36.0,
                ),
                onPressed: () => Navigator.of(context).pushNamed(rutaModulo),
              ),
              Text(
                titulo,
              ),
            ],
          ),
        ),
      ),
    );

  }

}