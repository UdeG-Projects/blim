import 'dart:io';

import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'usuarios.txt';

class Usuarios {
  MList<Usuario> usuarios = MList<Usuario>();

  Future<Usuario> agregar(Usuario usuario) async {
    usuario.id = generateRandomId();
    usuarios.add(usuario);

    Directory localPath = await getApplicationDocumentsDirectory();

    File fileToSave = File('${localPath.path}/$fileName');
    print(fileToSave.path);
    await fileToSave.writeAsString("${usuario.toString()}\n",
        mode: FileMode.append);

    return usuario.clone();
  }

  Usuario buscar(bool Function(Usuario) whereFunction) {
    var list = usuarios.where(whereFunction);
    Usuario primera = list.first;
    return primera;
  }

  void modificar(String id, Usuario usuarioModificado) async {
    Directory localPath = await getApplicationDocumentsDirectory();

    File fileToSave = File('${localPath.path}/$fileName');
    var lines = await fileToSave.readAsLines();
    await fileToSave.writeAsString('', mode: FileMode.write);

    for (String userText in lines) {
      Usuario tmp = Usuario.fromString(userText);
      if (tmp.id == id) {
        await fileToSave.writeAsString('$usuarioModificado\n',
            mode: FileMode.append);
      } else {
        await fileToSave.writeAsString('$userText\n', mode: FileMode.append);
      }
    }
    print(fileToSave.path);
  }

  void eliminar(String id) {
    Function byIndex = (Usuario usuario) => usuario.id == id;

    usuarios.removeAt(usuarios.indexWhere(byIndex));
  }

  Future<void> leer() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File fileToRead = File('${localPath.path}/$fileName');
    usuarios = MList<Usuario>();
    if (!await fileToRead.exists()) return;

    var lineas = await fileToRead.readAsLines();
    lineas.forEach((String line) {
      if (line.isNotEmpty) {
        Usuario usuarioDesdeDisco = Usuario.fromString(line);
        usuarios.add(usuarioDesdeDisco);
      }
    });
  }
}
