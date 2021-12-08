class PrimaryIndex<E> {
  static const int KEY_LENGTH = 3;
  static const int VALUE_LENGTH = 20;
  static const int REGISTERINDEX_LENGTH = KEY_LENGTH + VALUE_LENGTH + 3;

  int key;
  E value;

  PrimaryIndex({this.key, this.value});

  static String deleted() => ' ' * (REGISTERINDEX_LENGTH - 1);

  static PrimaryIndex fromString(String register) {
    var fields = register.split(';');
    return PrimaryIndex(key: int.parse(fields[0]), value: fields[1].trim());
  }

  String toString() =>
      "${this.key.toString().padRight(KEY_LENGTH)};${this.value.toString().padRight(VALUE_LENGTH)}";
}
