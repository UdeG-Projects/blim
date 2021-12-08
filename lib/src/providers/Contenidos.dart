import 'dart:io';

import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'contenidos.txt';

class Contenidos {
  MList<Contenido> contenidos = MList();

  Future<void> agregar(Contenido contenido) async {
    contenido.id ??= generateRandomId();
    contenidos.add(contenido);

    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToSave = File('${localPath.path}/$fileName');
    if (!await fileToSave.exists()) fileToSave.create();

    await fileToSave.writeAsString("${contenido.toString()}\n",
        mode: FileMode.append);
  }

  Contenido buscar(bool Function(Contenido) whereFunction) {
    Contenido primera = contenidos.where(whereFunction).first;
    return primera;
  }

  Future<void> modificar(String id, Contenido peliculaModificada) async {
    int indexPelicula =
        contenidos.indexWhere((contenido) => contenido.id == id);
    contenidos[indexPelicula] = peliculaModificada;
    await guardar();
  }

  Future<void> eliminar(String id) async {
    Function byIndex = (Contenido contenido) {
      return contenido.id == id;
    };
    contenidos.removeAt(contenidos.indexWhere(byIndex));
    await guardar();
  }

  guardar() async {
    Directory localPath = await getApplicationDocumentsDirectory();

    File fileToSave = File('${localPath.path}/$fileName');

    if (!await fileToSave.exists()) fileToSave.create();
    await fileToSave.writeAsString('');

    print(fileToSave.path);

    contenidos.forEach((Contenido contenido) async {
      print(contenido);
      await fileToSave.writeAsString("${contenido.toString()}\n",
          mode: FileMode.append);
    });
  }

  void leer() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToRead = File('${localPath.path}/$fileName');
    contenidos = MList<Contenido>();
    if (!await fileToRead.exists()) return;

    var lineas = await fileToRead.readAsLines();
    lineas.forEach((String line) {
      Contenido peliculaDesdeDisco = Contenido.fromString(line);
      contenidos.add(peliculaDesdeDisco);
    });
  }
}
