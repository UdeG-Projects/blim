import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/core/models/Pelicula.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/providers/ListasReproduccion.dart';
import 'package:blim/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoListasReproduccionScreen extends StatefulWidget {
  @override
  _DemoListasReproduccionScreenState createState() =>
      _DemoListasReproduccionScreenState();
}

class _DemoListasReproduccionScreenState
    extends State<DemoListasReproduccionScreen> {
  ListasReproduccion listasReproduccion = ListasReproduccion();
  ListaReproduccion tmpLista = ListaReproduccion();

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
                          tmpLista.nombre = value;
                        });
                      },
                    ),
                  ],
                )),
              ),
              ElevatedButton(
                child: Text('Agregar pelicula'),
                onPressed: () {
                  tmpLista.contenidos = MList<Contenido>();
                  tmpLista.contenidos.add(Pelicula(
                      id: generateRandomId(),
                      descripcion: 'Descripción1',
                      titulo: 'Titulo1'));
                  tmpLista.contenidos.add(Pelicula(
                      id: generateRandomId(),
                      descripcion: 'Descripción2',
                      titulo: 'Titulo2'));
                  tmpLista.contenidos.add(Pelicula(
                      id: generateRandomId(),
                      descripcion: 'Descripción3',
                      titulo: 'Titulo3'));
                  listasReproduccion.guardar(tmpLista);
                },
              ),
              ElevatedButton(
                child: Text('Eliminar pelicula'),
                onPressed: () {
                  listasReproduccion.eliminar("NLpNS");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
