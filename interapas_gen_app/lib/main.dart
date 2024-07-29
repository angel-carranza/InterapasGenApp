
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:interapas_gen_app/screens/censos/menu_censos.dart';
import 'package:interapas_gen_app/screens/cortes/menu_cortes.dart';
import 'package:interapas_gen_app/screens/login.dart';
import 'package:interapas_gen_app/screens/menu.dart';
import 'screens/inicio.dart';
import 'services/camara_provider.dart';
import 'services/local_storage.dart';

ColorScheme esquemaColorPrincipal = const ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 228, 3, 44),
  onPrimary: Color.fromARGB(255, 255, 255, 255),
  secondary: Color.fromARGB(255, 1, 47, 80),
  onSecondary: Color.fromARGB(255, 255, 255, 255),
  error: Color.fromARGB(255, 120, 0, 0),
  onError: Color.fromARGB(255, 255, 255, 255),
  surface: Color.fromARGB(255, 255, 255, 255),
  onSurface: Color.fromARGB(255, 1, 47, 80)
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final camarasDisp = await availableCameras();   //Obtiene las camaras disponibles del dispositivo, tiene que hacerse antes del runApp().

  camarasDisponibles = camarasDisp;   //Lo asigna a la variable global.


  await LocalStorage.configurarPrefs();   //Se manda a obtener las preferencias al inicio

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: const Inicio_Screen(),
      theme: ThemeData(
        fontFamily: "Montserrat",
      ).copyWith(
        colorScheme: esquemaColorPrincipal,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: esquemaColorPrincipal.primary,
          foregroundColor: esquemaColorPrincipal.onPrimary,
        )
      ),
      routes: {   //Definición de rutas de las pantallas para usar los Navigator..Named
        '/login': (context) => const Login_Screen(),
        '/menu' : (context) => const Menu_Screen(),
        '/censos' : (context) => const MenuCensos_Screen(),
        '/cortes' : (context) => const MenuCortes_Screen(),
      },
    );

  }
}
