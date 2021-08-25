import 'dart:math';

/// Taken from zzpmaster on https://gist.github.com/zzpmaster/ec51afdbbfa5b2bf6ced13374ff891d9
String formatBytes(int bytes, int decimals) {
  if (bytes <= 2) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  int i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

String generateRandomId([int length = 12]) {
  String generated = "";
  Random rand = Random();

  for (int i = 0; i < length; i++) {
    bool upper = rand.nextBool();
    int randLetter = rand.nextInt(26);
    generated += String.fromCharCode((upper ? 65 : 97) + randLetter);
  }

  return generated;
}
