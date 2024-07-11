
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:interapas_gen_app/acceso_datos/acceso_datos.dart';
import 'package:interapas_gen_app/data/api/API_USUARIO.dart';
import 'package:interapas_gen_app/utilities/cifrado.dart';
import 'package:interapas_gen_app/utilities/formateo.dart';
import 'package:interapas_gen_app/utilities/popup.dart';
import 'package:interapas_gen_app/widgets/acceso_config.dart';
import 'package:interapas_gen_app/widgets/loader.dart';

class Login_Screen extends StatefulWidget {
  
  
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  bool fgCargando = false;
  bool fgMostrarContrasena = false;   //Controla si se ve o no la contraseña al escribirla en el campo.
  String _usuarioIngresado = "";  //Variables para mandar a
  String _passwordIngresado = ""; // validar lo ingresado.
  IconData iconoMostrar = Icons.visibility_off;   //La primera vez se pone ese icono para empatar que estara ocultando la contraseña.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();    //Ayuda a controlar el envio del formulario.
  final TextEditingController ctrlPassword = TextEditingController();   //Para controlar el textbox de contraseña y limpiarlo al dar ingresar.


  _accesoConfig() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        children: [
          AccesoConfig(TextEditingController(text: ""))
        ],
      )
    );
  }

  _ingresar() {    //Función que inicia sesión con los campos introducidos
    if(_formKey.currentState!.validate()){  //Si paso los validator de todos los campos del formulario.
      _formKey.currentState!.save();

      setState(() {
        fgCargando = true;
      });

      _validarUsuario();
    }
  }

  _validarUsuario() async {
    Cifrado cif = Cifrado();
    API_USUARIO usuarioAguasys = await AccesoDatos.obtieneAcceso(_usuarioIngresado, cif.encriptarAEScbc(_passwordIngresado));

    if(usuarioAguasys.ID_EMPLEADO > 0){   //Si se obtuvo una respuesta de un usario desde la API...

      if(usuarioAguasys.NB_PASSWORD == "1"){    //Si la contraseña fue correcta.
        if(await AccesoDatos.iniciaSesion(usuarioAguasys)){
          if(context.mounted){
            Navigator.of(context).pushNamedAndRemoveUntil('/menu', (Route<dynamic> route) => false);
          }
        } else {
          if(context.mounted){
            mensajeSimpleOK("Hubo un error intentando acceder en el dispositivo.", context);          
          }
        }
      }
      else {
        if(context.mounted){
          mensajeSimpleOK("La contraseña no es correcta, verifiquela por favor.", context);
        }
      }

    }
    else{
      String mensajeError = "";
      switch(usuarioAguasys.ID_EMPLEADO){
        case -902:
          mensajeError = "Hubo un error de conexión, verifique e intente de nuevo.";
          break;
        default:
          mensajeError = "Ocurrió un error inesperado. Intente de nuevo por favor.";
      }

      if(context.mounted) {
        mensajeSimpleOK(mensajeError, context);
      }
    }

    setState(() {
      fgCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget botonLogin = TextButton( //Declaración de boton con definición predeterminada mostrando error, por si acaso.
      onPressed: null,
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 150, 0, 0))),
      child: const Text("##Error##"));

    if(fgCargando){
      botonLogin = TextButton(
        onPressed: () { },
        child: const Loader()
      );
    } else {
      botonLogin = TextButton(
        onPressed: _ingresar,
        child: const Text("Ingresar")
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 12.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _accesoConfig,
                      icon: const Icon(
                        Icons.rss_feed_rounded,
                        size: 30.0,
                      )
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/img/logo.png'),
                    const SizedBox(height: 36.0,),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Usuario"),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty || value.trim().length <= 1) {  //Valida que haya escrito algo.
                          return "Este campo es requerido.";
                        }
                        return null;  //Todo bien con el valor introducido en este campo.
                      },
                      onSaved: (value) {    //Cuando el formulario hace el evento de guardar los valores de los campos.
                        _usuarioIngresado = value!;
                      },
                      inputFormatters: [MayusculasFormatter()],   //Usa una clase y su método para siempre hacer mayuscula lo introducido en este campo.
                    ),
                    const SizedBox(height: 12,),
                    TextFormField(
                      obscureText: !fgMostrarContrasena,
                      obscuringCharacter: '*',
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: ctrlPassword,
                      decoration: InputDecoration(
                        label: const Text("Contraseña"),
                        suffixIcon: GestureDetector(  //Icono dentro del campo
                          child: Icon(iconoMostrar),
                          onTap: () {
                            setState(() {
                              fgMostrarContrasena = !fgMostrarContrasena;
                              if(fgMostrarContrasena) {
                                iconoMostrar = Icons.visibility; 
                              } else {
                                iconoMostrar = Icons.visibility_off;
                              }
                            });
                          },
                        )
                      ),
                      validator: (value) {if(value == null || value.isEmpty || value.trim().length <= 1) {  //Valida que haya escrito algo.
                          return "Este campo es requerido.";
                        }
                        return null;  //Todo bien con el valor introducido en este campo.
                      },
                      onSaved: (value) {     //Cuando el formulario hace el evento de guardar los valores de los campos.
                        _passwordIngresado = value!;
                        ctrlPassword.clear();   //Siempre borra la contraseña al intentar ingresar, en caso de que no pueda acceder.
                      },
                    ),
                    const SizedBox(height: 30.0,),
                    botonLogin,
                  ],
                ),
                const Spacer(),
                Container(),
              ],
            )
          ),
        ),
      ),
    );
  }
}