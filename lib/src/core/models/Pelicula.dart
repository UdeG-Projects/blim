import 'package:call_center/src/core/structures/MDuration.dart';
import 'package:call_center/src/core/models/Contenido.dart';

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

  @override
  String toString() {
    return "${this.id}|$titulo|$descripcion|$imagen|$duracion";
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
