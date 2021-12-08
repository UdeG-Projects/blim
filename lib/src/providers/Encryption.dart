class Encryption {
  static int _key = 2;

  static String caesar(String text, {bool isEncrypt = false}) {
    String _text = text;
    String _temp = "";

    for (int i = 0; i < _text.length; i++) {
      int ch = _text.codeUnitAt(i);

      String h;
      if (ch == ' '.codeUnitAt(0)) {
        _temp += " ";
        continue;
      }

      int c;
      if (isEncrypt)
        c = (ch + _key) % 255;
      else
        c = (ch - _key) % 255;

      h = String.fromCharCode(c);
      _temp += h;
    }

    return _temp;
  }
}
