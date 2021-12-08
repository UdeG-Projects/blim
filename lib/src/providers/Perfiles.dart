import 'dart:io';

import 'package:blim/src/core/models/Perfil.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'perfiles.txt';

class Perfiles {
  MList<Perfil> perfiles = MList();

  void agregar(Perfil p) async {
    perfiles.add(p);
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToSave = File('${localPath.path}/$fileName');
    print(fileToSave.path);
    if (!await fileToSave.exists()) fileToSave.create();

    await fileToSave.writeAsString("${p.toString()}\n", mode: FileMode.append);
  }

  Perfil buscar(bool Function(Perfil) whereFunction) {
    int indexPerfil = perfiles.indexWhere(whereFunction);
    Perfil primera = perfiles[indexPerfil];

    return primera;
  }

  void eliminar(String id) async {
    Function byIndex = (Perfil perfil) => perfil.id == id;
    perfiles.removeAt(perfiles.indexWhere(byIndex));

    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToSave = File('${localPath.path}/$fileName');
    var lineas = await fileToSave.readAsLines();

    if (!await fileToSave.exists()) fileToSave.create();
    await fileToSave.writeAsString('');

    lineas.forEach((String line) async {
      if (Perfil.fromString(line).id != id) {
        await fileToSave.writeAsString("$line\n", mode: FileMode.append);
      }
    });
  }

  Future<void> leer(String userId) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToRead = File('${localPath.path}/$fileName');
    perfiles = MList<Perfil>();
    if (!await fileToRead.exists()) return;
    var lineas = await fileToRead.readAsLines();

    lineas.forEach((String line) {
      Perfil peliculaDesdeDisco = Perfil.fromString(line);
      print("${peliculaDesdeDisco.usuario} = $userId");
      if (peliculaDesdeDisco.usuario == userId)
        perfiles.add(peliculaDesdeDisco);
    });
  }

  void clear() async {
    perfiles = MList<Perfil>();
  }
}
