
import 'package:flutter/material.dart';

class MensajeFondo extends StatelessWidget {
  
  final String mensaje;

  const MensajeFondo({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
      child: Center(child: Text(
        mensaje,
        maxLines: 4,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

}