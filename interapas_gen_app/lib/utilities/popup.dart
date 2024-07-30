
import 'package:flutter/material.dart';

Future<void> mensajeSimpleOK(String textoMostrar, BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          textoMostrar,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Montserrat_Medium",
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: const Text('Ok'),
          )
        ],
      );
    }
  );
}