
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/screens/config.dart';

class AccesoConfig extends StatefulWidget {
  final TextEditingController controlador;

  const AccesoConfig(this.controlador, {super.key});

  @override
  State<AccesoConfig> createState() => _AccesoConfigState();
}

class _AccesoConfigState extends State<AccesoConfig> {
  
  Future<void> _validarAcceso() async {
    if(widget.controlador.text == "Interapas99"){
      if (!context.mounted) return;
        Navigator.of(context).pop();
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Configuracion_Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 6.0, 6.0, 6.0)
      , child: Row(
        mainAxisAlignment: MainAxisAlignment.start
        , mainAxisSize: MainAxisSize.min
        , children: [
          Expanded(
            child: TextField(
              obscureText: true,
              obscuringCharacter: "•",
              controller: widget.controlador,
              decoration: const InputDecoration(
                labelText: "Clave "
                , border: OutlineInputBorder(),
              )
            ),
          )
          , const SizedBox(width: 12.0,)
          , IconButton(
            onPressed: _validarAcceso
            , iconSize: 30.0
            , icon: const Icon(Icons.arrow_forward_ios_outlined)
          )
        ],
      ),
    );
  }
}