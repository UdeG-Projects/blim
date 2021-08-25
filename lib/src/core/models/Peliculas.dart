import 'dart:io';

import 'package:call_center/src/core/models/Pelicula.dart';
import 'package:call_center/src/core/structures/MList.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'peliculas.txt';

class Peliculas {
  MList<Pelicula> peliculas = MList();

  void agregar(Pelicula pelicula) {
    peliculas.add(pelicula);
  }

  Pelicula buscar(bool Function(Pelicula) whereFunction) {
    Pelicula primera = peliculas.where(whereFunction).first;
    return primera;
  }

  void modificar(String id, Pelicula peliculaModificada) {
    int indexPelicula = peliculas.indexWhere((pelicula) => pelicula.id == id);
    peliculas[indexPelicula] = peliculaModificada;
  }

  void eliminar(String id) {
    Function byIndex = (Pelicula pelicula) => pelicula.id == id;
    peliculas.removeAt(peliculas.indexWhere(byIndex));
  }

  void guardar() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToSave = File('${localPath.path}/$fileName');

    if (!await fileToSave.exists()) fileToSave.create();
    fileToSave.writeAsStringSync('');
    print(fileToSave.path);

    peliculas.forEach((Pelicula pelicula) async {
      fileToSave.writeAsStringSync("Hola mundo ${pelicula.toString()}\n",
          mode: FileMode.append);
    });
  }

  void leer() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToRead = File('${localPath.path}/$fileName');
    if (!await fileToRead.exists()) return;

    fileToRead.readAsLinesSync().forEach((line) {
      peliculas.add(Pelicula.fromString(line));
    });
  }
}
