
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/screens/censos/menu_censos.dart';
import 'package:interapas_gen_app/screens/cortes/menu_cortes.dart';
import 'package:interapas_gen_app/screens/login.dart';
import 'package:interapas_gen_app/screens/menu.dart';
import 'screens/inicio.dart';
import 'services/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.configurarPrefs();   //Se manda a obtener las preferencias al inicio

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Inicio_Screen(),
      routes: {   //Definición de rutas de las pantallas para usar los Navigator..Named
        '/login': (context) => const Login_Screen(),
        '/menu' : (context) => const Menu_Screen(),
        '/censos' : (context) => const MenuCensos_Screen(),
        '/cortes' : (context) => const MenuCortes_Screen(),
      },
    );
  }
}
