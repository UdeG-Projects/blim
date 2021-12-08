class Contenido {
  String id;
  String titulo;
  String descripcion;
  String imagen;
  String tipo;

  Contenido({
    this.id,
    this.titulo,
    this.descripcion,
    this.imagen,
    this.tipo,
  });

  Contenido clone() => Contenido(
        id: this.id,
        titulo: this.titulo,
        descripcion: this.descripcion,
        imagen: this.imagen,
        tipo: this.tipo,
      );

  @override
  String toString() {
    return "$id|$titulo|$descripcion|$imagen|$tipo";
  }

  static Contenido fromString(String text) {
    var fields = text.split("|");

    return new Contenido(
      id: fields[0],
      titulo: fields[1],
      descripcion: fields[2],
      imagen: fields[3],
      tipo: fields[4],
    );
  }
}
