import 'package:blim/src/core/models/Perfil.dart';
import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/screens/account/constants.dart';
import 'package:blim/src/screens/account/widgets/profile_dialog.dart';
import 'package:blim/src/widgets/appbar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key key}) : super(key: key);
  static String routeName = '/account';

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  Usuario tmpUsuario = Usuario();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AppLogic appLogic;

  onSaveAccount() {
    formKey.currentState.save();
    appLogic.modificarUsuario(appLogic.usuario.id, appLogic.usuario);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Se ha actualizado la información de la cuenta.')));
  }

  restart() {
    setState(() => tmpUsuario = appLogic.usuario.clone());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    appLogic = context.read<AppLogic>();

    return Scaffold(
      appBar: DefaultAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mi cuenta',
                style: textTheme.headline5.apply(fontWeightDelta: 2),
              ),
              Container(height: 24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: textTheme.headline6.apply(fontWeightDelta: 2),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextFormField(
                              initialValue: appLogic.usuario.nombre,
                              onChanged: (v) =>
                                  setState(() => tmpUsuario.nombre = v),
                              onSaved: (v) => appLogic.usuario.nombre = v,
                              decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  label: Text('Nombre'),
                                  hintText: 'Nombre',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextFormField(
                              initialValue:
                                  appLogic.usuario.edad?.toString() ?? '',
                              onSaved: (v) =>
                                  appLogic.usuario.edad = int.tryParse(v),
                              onChanged: (v) => setState(
                                  () => tmpUsuario.edad = int.tryParse(v)),
                              decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  label: Text('Edad'),
                                  hintText: 'Edad',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextFormField(
                              initialValue: appLogic.usuario.usuario.toString(),
                              onSaved: (v) => appLogic.usuario.usuario = v,
                              onChanged: (v) =>
                                  setState(() => tmpUsuario.nombre = v),
                              decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  label: Text('Usuario'),
                                  hintText: 'Usuario',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextFormField(
                              obscureText: true,
                              onSaved: (v) => appLogic.usuario.contrasena = v,
                              initialValue:
                                  appLogic.usuario.contrasena.toString(),
                              onChanged: (v) =>
                                  setState(() => tmpUsuario.contrasena = v),
                              decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  label: Text('Contraseña'),
                                  hintText: 'Contraseña',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16)),
                            onPressed: tmpUsuario == appLogic.usuario
                                ? null
                                : onSaveAccount,
                            child: Text('Guardar cambios')),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Perfiles',
                      style: textTheme.headline6.apply(fontWeightDelta: 2),
                    ),
                    SizedBox(height: 6),
                    Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ...appLogic.perfiles.toWidgets(
                            (p) => InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(16),
                                width: 132,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 76,
                                      height: 76,
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        size: 32,
                                        color: colors[p.color].withOpacity(0.5),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              colors[p.color].withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                    SizedBox(height: 10),
                                    Text(p.apodo),
                                    Text(p.restriccion ? 'Infantil' : 'Adulto',
                                        style: textTheme.subtitle2
                                            .apply(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                Perfil tmp = await showDialog(
                                    context: context,
                                    builder: (_) => CreateProfileDialog());
                                if (tmp != null) {
                                  await appLogic.addProfile(tmp);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 76,
                                      height: 50,
                                      child: Icon(
                                        Icons.person_add_alt_1_outlined,
                                        size: 32,
                                      ),
                                    ),
                                    Text('Agregar perfil'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                    Container(height: 32),
                    Text(
                      'Facturación',
                      style: textTheme.headline6.apply(fontWeightDelta: 2),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/mastercard.jpeg'),
                          ),
                          title: Text('DICIEMBRE / MASTERCARD-1234'),
                          subtitle: Text('Plan BÁSICO mensual'),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16)),
                              onPressed: () {},
                              child: Text('Facturar')),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/visa.jpeg'),
                          ),
                          title: Text('NOVIEMBRE / VISA-1234'),
                          subtitle: Text('Plan BÁSICO mensual'),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16)),
                              onPressed: () {},
                              child: Text('Facturar')),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/visa.jpeg'),
                          ),
                          title: Text('NOVIEMBRE / VISA-1234'),
                          subtitle: Text('Plan BÁSICO mensual'),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16)),
                              onPressed: () {},
                              child: Text('Facturar')),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
