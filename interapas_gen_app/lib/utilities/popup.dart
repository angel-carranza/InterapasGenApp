
import 'package:flutter/material.dart';

Future<void> mensajeSimpleOK(String textoMostrar, BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(textoMostrar),
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