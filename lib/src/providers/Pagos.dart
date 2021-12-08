import 'dart:io';

import 'package:blim/src/core/models/Pago.dart';

import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'pagos.txt';

class Pagos {
  Future<Pago> buscar(String id) async {
    MList<Pago> _pagos = MList<Pago>();
    Directory localPath = await getApplicationDocumentsDirectory();

    int hash = (id.codeUnitAt(0) * id.codeUnitAt(id.length - 1)) % 1000;

    File regsFile = File('${localPath.path}/$fileName');
    if (!await regsFile.exists()) return null;
    var regsLines = await regsFile.readAsLines();
    regsLines.forEach((line) => _pagos.add(Pago.fromString(line)));

    while (_pagos[hash].id != id && hash != 1000) hash++;

    return _pagos[hash];
  }

  Future<Pago> agregar(Pago pago) async {
    String id = generateRandomId();
    pago.id = id;

    Directory localPath = await getApplicationDocumentsDirectory();

    File registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) await _createFile();
    print(registersFile.path);
    if (!await exists(pago.hash)) {
      var regsLines = await registersFile.readAsLines();
      regsLines[pago.hash] = pago.toString();
      await registersFile.writeAsString("${regsLines.join('\n')}\n");
    }

    return pago;
  }

  Future<void> modificar(Pago pago) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) return;

    int hash = pago.hash;
    var regsLines = await registersFile.readAsLines();
    while (Pago.fromString(regsLines[hash]).id != pago.id) {
      hash++;
    }

    regsLines[hash] = pago.toString();
    await registersFile.writeAsString("${regsLines.join('\n')}\n");
    print('Nuevo pago modificado en: ${registersFile.path}');
  }

  Future<void> eliminar(Pago pago) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) return;

    int hash = pago.hash;
    var regsLines = await registersFile.readAsLines();
    while (Pago.fromString(regsLines[hash]).id != pago.id) {
      hash++;
    }

    regsLines[hash] = '';
    await registersFile.writeAsString("${regsLines.join('\n')}\n");
    print('Nuevo pago eliminado en: ${registersFile.path}');
  }

  Future<bool> exists(int hash) async {
    Directory localPath = await getApplicationDocumentsDirectory();

    File regsFile = File('${localPath.path}/$fileName');
    var regsLines = await regsFile.readAsLines();

    return regsLines[hash] != '';
  }

  Future<void> _createFile() async {
    String fileInput = "\n" * 1000;
    Directory localPath = await getApplicationDocumentsDirectory();
    File regsFile = File('${localPath.path}/$fileName');
    await regsFile.writeAsString(fileInput);
  }
}
