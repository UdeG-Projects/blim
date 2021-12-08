import 'package:blim/src/core/models/Perfil.dart';
import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/providers/Usuarios.dart';
import 'package:blim/src/screens/account/widgets/profile_dialog.dart';
import 'package:blim/src/screens/home/screen.dart';
import 'package:blim/src/widgets/appbar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);
  static String routeName = '/login';

  var formKey = GlobalKey<FormState>();
  Usuario tmpUsuario = Usuario();
  AppLogic appLogic;

  @override
  Widget build(BuildContext context) {
    appLogic = context.read<AppLogic>();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: DefaultAppBar(),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              minWidth: screenSize.width, maxHeight: screenSize.height),
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://blim.com/assets/img/account/registration/background.jpg'))),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFF0F3F7),
              ),
              margin: EdgeInsets.symmetric(vertical: 30),
              constraints: BoxConstraints(maxWidth: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Entra y disfruta blim tv',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 30),
                          ),
                          Text(
                              'Televisión en vivo, series, películas, novelas, programas favoritos y más.',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 12),
                          Text('Tu cuenta',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Es necesario tu correo' : null,
                            onSaved: (v) => tmpUsuario.usuario = v,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                label: Text('Tu correo electrónico')),
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            validator: (value) => value.isEmpty
                                ? 'Es necesaria tu contraseña'
                                : null,
                            onSaved: (v) => tmpUsuario.contrasena = v,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                label: Text('Tu contraseña')),
                          ),
                          SizedBox(height: 28),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(16)),
                                    onPressed: () => onRegister(context),
                                    child: Text('Crear cuenta')),
                                SizedBox(width: 18),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(16)),
                                    onPressed: () => onLogin(context),
                                    child: Text('Iniciar sesión')),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(color: Colors.black, height: 3),
                  // SizedBox(height: 12),
                  // Padding(
                  //   padding: const EdgeInsets.all(40),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text(
                  //         'Selecciona tu plan',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w900, fontSize: 30),
                  //       ),
                  //       SizedBox(height: 8),
                  //       Text(
                  //           'Sin contratos a plazos forzosos, citas de instalación o penalizaciones. ¡Cámbiate al plan gratuito en cualquier momento!',
                  //           style: TextStyle(fontSize: 20)),
                  //       SizedBox(height: 16),
                  //       Image.asset('assets/images/planes.png')
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Usuarios usuarios = Usuarios();
  void onLogin(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      Usuario _user = usuarios.buscar((u) =>
          u.usuario == tmpUsuario.usuario &&
          u.contrasena == tmpUsuario.contrasena);
      if (_user != null) {
        await appLogic.login(_user);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Usuario no encontrado o contraseña incorrecta.')));
      }
    }
  }

  void onRegister(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      // try {
      var _user = await usuarios.agregar(tmpUsuario);
      Perfil tmpPerfil;
      do {
        tmpPerfil = await showDialog(
          context: context,
          builder: (_) => CreateProfileDialog(barrierDimisible: false),
        );
      } while (tmpPerfil == null);
      tmpPerfil.principal = true;
      await appLogic.addProfile(tmpPerfil, _user.id);

      await appLogic.login(_user);

      Navigator.of(context).pop();
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Ha ocurrido un error al registrarte.')));
      // }
    }
  }
}
