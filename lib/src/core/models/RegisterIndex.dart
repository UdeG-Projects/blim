class RegisterIndex<E> {
  static const int KEY_LENGTH = 3;
  static const int VALUE_LENGTH = 5;
  static const int REGISTERINDEX_LENGTH = KEY_LENGTH + VALUE_LENGTH + 2;

  int key;
  E value;

  RegisterIndex({this.key, this.value});

  static RegisterIndex fromString(String register) {
    var fields = register.split(';');
    return RegisterIndex(key: int.parse(fields[0]), value: fields[1].trim());
  }

  String toIndexString() =>
      "${this.key.toString().padRight(KEY_LENGTH)};${this.value.toString().padRight(VALUE_LENGTH)}";
}
