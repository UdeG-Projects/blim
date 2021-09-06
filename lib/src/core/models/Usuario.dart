const STRING_LEN = 25;
const INT_LEN = 3;
const TOTAL_LEN = 3;

class Usuario {
  String id;
  String nombre;
  int edad;
  String usuario;
  String contrasena;

  Usuario({
    this.id,
    this.nombre,
    this.edad,
    this.usuario,
    this.contrasena,
  });

  Usuario clone() => Usuario(
        id: this.id,
        nombre: this.nombre,
        edad: this.edad,
        usuario: this.usuario,
        contrasena: this.contrasena,
      );

  @override
  String toString() =>
      "${id.padRight(STRING_LEN, ' ')}" +
      "${nombre.padRight(STRING_LEN, ' ')}" +
      "${edad.toString().padRight(INT_LEN, ' ')}" +
      "${usuario.padRight(STRING_LEN, ' ')}" +
      "${contrasena.padRight(STRING_LEN, ' ')}";

  static Usuario fromString(String text) {
    return new Usuario(
      id: text.substring(0, STRING_LEN - 1).trimRight(),
      nombre: text.substring(STRING_LEN, (STRING_LEN * 2) - 1),
      edad: int.parse(
          text.substring((STRING_LEN * 2), (STRING_LEN * 2) + INT_LEN)),
      usuario: text.substring(
          text.length - (STRING_LEN * 2), text.length - STRING_LEN - 1),
      contrasena: text.substring(text.length - STRING_LEN),
    );
  }
}
