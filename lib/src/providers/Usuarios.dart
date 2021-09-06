import 'dart:io';

import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'usuarios.txt';

class Usuarios {
  MList<Usuario> usuarios = MList();

  void agregar(Usuario usuario) {
    usuarios.add(usuario);
  }

  Usuario buscar(bool Function(Usuario) whereFunction) {
    Usuario primera = usuarios.where(whereFunction).first;
    return primera;
  }

  void modificar(String id, Usuario usuarioModificado) {
    int indexPelicula = usuarios.indexWhere((usuario) => usuario.id == id);
    usuarios[indexPelicula] = usuarioModificado;
  }

  void eliminar(String id) {
    Function byIndex = (Usuario usuario) {
      return usuario.id == id;
    };

    usuarios.removeAt(usuarios.indexWhere(byIndex));
  }

  void guardar() async {
    Directory localPath = await getApplicationDocumentsDirectory();

    File fileToSave = File('${localPath.path}/$fileName');

    if (!await fileToSave.exists()) fileToSave.create();
    fileToSave.writeAsStringSync('');

    print(fileToSave.path);

    usuarios.forEach((Usuario usuario) async {
      fileToSave.writeAsStringSync("${usuario.toString()}\n",
          mode: FileMode.append);
    });
  }

  void leer() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToRead = File('${localPath.path}/$fileName');
    usuarios = MList<Usuario>();
    if (!await fileToRead.exists()) return;

    var lineas = fileToRead.readAsLinesSync();
    lineas.forEach((String line) {
      Usuario usuarioDesdeDisco = Usuario.fromString(line);
      usuarios.add(usuarioDesdeDisco);
    });
  }
}
