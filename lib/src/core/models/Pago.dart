import 'package:blim/src/core/models/Date.dart';

const STRING_LEN = 25;
const INT_LEN = 3;
const TOTAL_LEN = 3;

class Pago {
  static int get LENGTH => (STRING_LEN * 3) + INT_LEN;

  String id;
  int monto;
  String metodo;
  Date fecha;

  Pago({this.id, this.monto, this.metodo, this.fecha});

  Pago clone() => Pago(
        id: this.id,
        monto: this.monto,
        metodo: this.metodo,
        fecha: this.fecha,
      );

  @override
  String toString() =>
      "${id.padRight(STRING_LEN, ' ')}" +
      "${monto.toString().padRight(INT_LEN, ' ')}" +
      "${metodo.toString().padRight(STRING_LEN, ' ')}" +
      "${fecha.toString().padRight(STRING_LEN, ' ')}";

  static Pago fromString(String text) {
    Pago pago = Pago();

    pago.id = text.substring(0, STRING_LEN - 1).trimRight();
    text = text.substring(STRING_LEN);

    pago.monto = int.parse(text.substring(0, INT_LEN));
    text = text.substring(INT_LEN);

    pago.metodo = text.substring(0, STRING_LEN);
    text = text.substring(STRING_LEN);

    pago.fecha = Date.fromString(text.substring(0, STRING_LEN));

    return pago;
  }

  int get hash => (id.codeUnitAt(0) * id.codeUnitAt(id.length - 1)) % 1000;
}
