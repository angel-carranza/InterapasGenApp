
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
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 8.0
      ),
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Expanded(child: Container()),
              IconButton(
                icon: Icon(
                  icono,
                  size: 42.0,
                ),
                onPressed: () => Navigator.of(context).pushNamed(rutaModulo),
              ),
              Text(
                titulo,
              ),
              Expanded(child: Container())
            ],
          ),
        ),
      ),
    );

  }

}