import 'package:blim/src/core/models/Pelicula.dart';
import 'package:blim/src/core/models/Peliculas.dart';
import 'package:blim/src/core/models/Serie.dart';
import 'package:blim/src/core/structures/MDuration.dart';
import 'package:blim/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  Peliculas peliculas = Peliculas();
  String text = 'Hola mundo';
  Pelicula tmpPelicula = Pelicula();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLIM'),
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
                      decoration:
                          InputDecoration(labelText: 'Nombre de película'),
                      onChanged: (value) {
                        setState(() {
                          tmpPelicula.titulo = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Descripción'),
                      onChanged: (value) {
                        setState(() {
                          tmpPelicula.descripcion = value;
                        });
                      },
                    ),
                  ],
                )),
              ),
              ElevatedButton(
                child: Text('Agregar random'),
                onPressed: () {
                  Pelicula pelicula = Pelicula(
                    id: 'idunico',
                    duracion: MDuration(minutes: 1, hours: 1),
                    titulo: generateRandomId(),
                    imagen: 'imagen url',
                    descripcion: 'Desc',
                  );
                  setState(() {
                    peliculas.agregar(pelicula);
                  });
                },
              ),
              SizedBox(height: 12),
              Text(
                'Peliculas',
              ),
              Container(
                width: 200,
                height: 400,
                child: ListView.builder(
                  itemCount: peliculas.peliculas.length,
                  itemBuilder: (context, int index) {
                    Pelicula p = peliculas.peliculas[index];
                    return ListTile(
                      title: Text(p.titulo),
                      subtitle: Text(p.descripcion),
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
                        peliculas.leer();
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text('Guardar'),
                    onPressed: () {
                      setState(() {
                        peliculas.guardar();
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
