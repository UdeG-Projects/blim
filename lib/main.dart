import 'package:call_center/src/core/models/Pelicula.dart';
import 'package:call_center/src/core/models/Peliculas.dart';
import 'package:call_center/src/core/structures/MDuration.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Peliculas peliculas = Peliculas();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'BLIM',
      home: Scaffold(
        appBar: AppBar(
          title: Text('BLIM'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Título'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Descripción'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Título'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Descripción'),
                      ),
                    ],
                  )),
                ),
                ElevatedButton(
                  child: Text('Agregar'),
                  onPressed: () {
                    Pelicula pelicula = Pelicula(
                      id: 'idunico',
                      duracion: MDuration(minutes: 1, hours: 1),
                      titulo: 'Pelicula',
                      descripcion: 'Desc',
                    );
                    peliculas.agregar(pelicula);
                  },
                ),
                SizedBox(height: 12),
                Text(
                  'Peliculas',
                  style: textTheme.subtitle2,
                ),
                Container(
                  width: 200,
                  height: 400,
                  child: ListView.builder(
                    itemCount: peliculas.peliculas.length,
                    itemBuilder: (context, i) {
                      Pelicula p = peliculas.peliculas[i];
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
                        peliculas.guardar();
                      },
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      child: Text('Guardar'),
                      onPressed: () {
                        peliculas.guardar();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
