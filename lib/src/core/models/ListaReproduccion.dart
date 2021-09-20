import 'package:blim/src/core/models/Pelicula.dart';
import 'package:blim/src/core/structures/MDuration.dart';
import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/structures/MList.dart';

class ListaReproduccion {
  String id, nombre;
  MList<Contenido> contenidos;

  ListaReproduccion({
    this.id,
    this.nombre,
    this.contenidos,
  });

  ListaReproduccion clone() => ListaReproduccion(
        id: this.id,
        nombre: this.nombre,
        contenidos: this.contenidos,
      );

  @override
  String toString() => "$id|$nombre|${contenidos.toString()}";

  static ListaReproduccion fromString(String text) {
    var fields = text.split("|");

    return new ListaReproduccion(
      id: fields[0],
      nombre: fields[1],
      contenidos: MList.fromString(fields[2], Pelicula.fromString),
    );
  }
}
