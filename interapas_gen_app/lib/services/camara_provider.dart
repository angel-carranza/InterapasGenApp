
/* Se pensaba implementar un provider para acceder a las camaras desde pantallas muy distantes de la función 
    main(), porque ahí se tienen que consultar, pero con una simple variable en este archivo es accesible.*/

import 'package:camera/camera.dart';

List<CameraDescription> camarasDisponibles = List.empty();    //Lista que contendrá las camaras a lo largo de la ejecución del programa.
