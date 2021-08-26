import 'package:blim/src/core/models/Pelicula.dart';
import 'package:blim/src/core/models/Peliculas.dart';
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
                child: Text('Agregar pelicula'),
                onPressed: () {
                  setState(() {
                    tmpPelicula.id = generateRandomId();
                    tmpPelicula.imagen =
                        'https://vnoc.unam.mx/wp-content/uploads/2019/06/udg-300x148.jpg';
                    peliculas.agregar(tmpPelicula);
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
                      print(peliculas.peliculas.length);
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
