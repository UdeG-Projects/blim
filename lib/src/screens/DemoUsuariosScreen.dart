import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/core/utils.dart';
import 'package:blim/src/providers/Usuarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoUsuarioScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoUsuarioScreen> {
  Usuarios usuarios = Usuarios();
  Usuario tmpUsuario = Usuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLIM: Usuario'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                child: Form(
                    child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nombre'),
                      onChanged: (value) {
                        setState(() {
                          tmpUsuario.nombre = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Edad'),
                      onChanged: (value) {
                        setState(() {
                          tmpUsuario.edad = int.parse(value);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Usuario'),
                      onChanged: (value) {
                        setState(() {
                          tmpUsuario.usuario = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      onChanged: (value) {
                        setState(() {
                          tmpUsuario.contrasena = value;
                        });
                      },
                    ),
                  ],
                )),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: Text('Agregar usuario'),
                onPressed: () {
                  setState(() {
                    tmpUsuario.id = generateRandomId();
                    usuarios.agregar(tmpUsuario.clone());
                  });
                },
              ),
              SizedBox(height: 12),
              Text('Usuarios'),
              Container(
                width: 200,
                height: 400,
                child: ListView.builder(
                  itemCount: usuarios.usuarios.length,
                  itemBuilder: (context, int index) {
                    Usuario u = usuarios.usuarios[index];
                    return ListTile(
                      title: Text(u.usuario),
                      subtitle: Text(u.contrasena),
                    );
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: Text('Leer'),
                    onPressed: () {
                      setState(() {
                        usuarios.leer();
                      });
                      print(usuarios.usuarios.length);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text('Guardar'),
                    onPressed: () {
                      setState(() {
                        usuarios.guardar();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
