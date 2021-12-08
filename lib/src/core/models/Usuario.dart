import 'package:blim/src/providers/Encryption.dart';

const STRING_LEN = 25;
const INT_LEN = 4;
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
      "${(id ?? '').padRight(STRING_LEN, ' ')}" +
      "${Encryption.caesar((nombre ?? '').padRight(STRING_LEN, ' '))}" +
      "${Encryption.caesar((edad?.toString() ?? '').padRight(INT_LEN, ' '))}" +
      "${Encryption.caesar((usuario ?? '').padRight(STRING_LEN, ' '))}" +
      "${Encryption.caesar((contrasena ?? '').padRight(STRING_LEN, ' '))}";

  static Usuario fromString(String text) {
    String id = text.substring(0, STRING_LEN - 1).trimRight(),
        nombre = text.substring(STRING_LEN, (STRING_LEN * 2) - 1).trimRight(),
        edad = text?.substring((STRING_LEN * 2), (STRING_LEN * 2) + INT_LEN) ??
            null,
        usuario = text
            .substring(
                text.length - (STRING_LEN * 2), text.length - STRING_LEN - 1)
            .trimRight();
    String pass = text.substring(text.length - STRING_LEN).trimRight();

    return Usuario(
      id: id,
      nombre: Encryption.caesar(nombre, isEncrypt: true),
      edad: int.tryParse(Encryption.caesar(edad, isEncrypt: true)),
      usuario: Encryption.caesar(usuario, isEncrypt: true),
      contrasena: Encryption.caesar(pass, isEncrypt: true),
    );
  }

  operator ==(other) {
    if (!(other is Usuario)) return false;

    Usuario u = other as Usuario;

    return u.id == this.id &&
        u.nombre == this.nombre &&
        u.usuario == this.usuario &&
        this.edad == u.edad &&
        this.contrasena == u.contrasena;
  }
}
