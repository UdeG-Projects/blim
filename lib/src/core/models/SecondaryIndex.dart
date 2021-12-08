class SecondaryIndex<E> {
  static const int KEY_LENGTH = 3;
  static const int IDX_LENGTH = 3;
  static const int VALUE_LENGTH = 20;
  static const int REG_LEN =
      KEY_LENGTH + VALUE_LENGTH + IDX_LENGTH + 3 /* \n + ; + ; */;

  int idx;
  E keyValue;
  int nextIdx;

  SecondaryIndex({this.idx, this.nextIdx, this.keyValue});

  static SecondaryIndex fromString(String register) {
    var fields = register.split(';');
    return SecondaryIndex(
      idx: int.parse(fields[0].trim()),
      keyValue: fields[1].trim(),
      nextIdx: int.parse(fields[2].trim()),
    );
  }

  static String deleted() => ' ' * (REG_LEN - 1);
  String toString() =>
      "${this.idx.toString().padRight(IDX_LENGTH)};" +
      "${this.keyValue.toString().padRight(VALUE_LENGTH)};" +
      "${(this.nextIdx ?? -1).toString().padRight(KEY_LENGTH)}";
}
