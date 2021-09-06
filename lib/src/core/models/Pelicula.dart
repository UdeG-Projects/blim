import 'package:blim/src/core/structures/MDuration.dart';
import 'package:blim/src/core/models/Contenido.dart';

class Pelicula extends Contenido {
  MDuration duracion = MDuration();

  Pelicula({
    String id,
    String titulo,
    String descripcion,
    String imagen,
    this.duracion,
  }) : super(
          id: id,
          titulo: titulo,
          descripcion: descripcion,
          imagen: imagen,
        );

  Pelicula clone() => Pelicula(
        id: this.id,
        titulo: this.titulo,
        descripcion: this.descripcion,
        imagen: this.imagen,
        duracion: this.duracion,
      );

  @override
  String toString() {
    return "${this.id}|$titulo|$descripcion|$imagen|${duracion ?? '0:0'}";
  }

  static Pelicula fromString(String text) {
    var fields = text.split("|");

    return new Pelicula(
      id: fields[0],
      titulo: fields[1],
      descripcion: fields[2],
      imagen: fields[3],
      duracion: MDuration.fromString(fields[4]),
    );
  }
}
