import 'package:blim/src/core/structures/MList.dart';

class Perfil {
  String id, apodo, usuario;
  bool principal, restriccion;
  int color;
  MList<dynamic> listas;

  Perfil(
      {this.id,
      this.apodo,
      this.usuario,
      this.principal = false,
      this.restriccion = false,
      this.color = 0,
      this.listas});

  Perfil clone() => Perfil(
        id: this.id,
        apodo: this.apodo,
        usuario: this.usuario,
        color: this.color,
        principal: this.principal,
        restriccion: this.restriccion,
        listas: this.listas,
      );

  @override
  String toString() {
    return "$id|$usuario|$apodo|$color|$restriccion|$principal|$listas";
  }

  static Perfil fromString(String text) {
    var fields = text.split("|");

    return new Perfil(
      id: fields[0],
      usuario: fields[1],
      apodo: fields[2],
      color: int.tryParse(fields[3]),
      restriccion: fields[4] == 'true' ? true : false,
      principal: fields[5] == 'true' ? true : false,
      listas: MList.fromString(fields[6], (t) => t),
    );
  }
}
