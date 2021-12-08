import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/structures/MList.dart';

class ListaReproduccion {
  String id, nombre, perfil;
  MList<dynamic> contenidos;

  ListaReproduccion({
    this.id,
    this.nombre,
    this.perfil,
    this.contenidos,
  });

  ListaReproduccion clone() => ListaReproduccion(
        id: this.id,
        nombre: this.nombre,
        perfil: this.perfil,
        contenidos: this.contenidos,
      );

  @override
  String toString() => "$id|$nombre|$perfil|${contenidos.toString()}";

  static ListaReproduccion fromString(String text) {
    var fields = text.split("|");

    return new ListaReproduccion(
      id: fields[0],
      nombre: fields[1],
      perfil: fields[2],
      contenidos: MList.fromString(fields[3], Contenido.fromString),
    );
  }
}
