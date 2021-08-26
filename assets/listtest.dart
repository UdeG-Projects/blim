import 'package:blim/src/core/structures/MList.dart';

testing() {
  MList<String> listStrings = MList();
  listStrings.add("1");
  listStrings.add("2");
  listStrings.add("3");
  listStrings.add("4");

  print(listStrings[0]);
  listStrings[0] = "0";
  print(listStrings[0]);

  print(listStrings);
}
