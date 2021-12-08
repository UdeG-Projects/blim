import 'package:blim/src/core/models/Pago.dart';

const STRING_LEN = 25;
const INT_LEN = 3;
const TOTAL_LEN = 3;

class Factura {
  String id;
  String userId;
  String rfc;
  Pago pago;

  Factura({this.id, this.userId, this.pago});

  Factura clone() => Factura(
        id: this.id,
        userId: this.userId,
        pago: this.pago,
      );

  @override
  String toString() =>
      "${id.padRight(STRING_LEN, ' ')}" +
      "${userId.padRight(STRING_LEN, ' ')}" +
      "${pago.toString().padRight(Pago.LENGTH, ' ')}";

  static Factura fromString(String text) {
    Factura factura = Factura();

    factura.id = text.substring(0, STRING_LEN - 1).trimRight();
    text = text.substring(STRING_LEN);

    factura.userId = text.substring(0, STRING_LEN);
    text = text.substring(INT_LEN);

    factura.pago = Pago.fromString(text);

    return factura;
  }
}
