import 'dart:convert';
import 'dart:io';

import 'package:blim/src/core/models/PrimaryIndex.dart';
import 'package:blim/src/core/models/Factura.dart';
import 'package:blim/src/core/models/SecondaryIndex.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:blim/src/providers/ListasReproduccion.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'facturas.txt';
const String idxFileName = 'facturas.index.txt';
const String secIdxfileName = 'facturas.sec_index.txt';

class Facturas {
  Future<MList<Factura>> buscar(String userId) async {
    MList<Factura> _facturas = MList<Factura>();
    Directory localPath = await getApplicationDocumentsDirectory();

    int indice = await _searchIndex(userId);
    if (indice == -1) return _facturas;

    MList<SecondaryIndex> _indexs = MList<SecondaryIndex>();
    _indexs = await searchRegisterIndexs(indice);

    File regsFile = File('${localPath.path}/$fileName');
    var regsLines = await regsFile.readAsLines();
    _indexs.forEach((i) {
      _facturas.add(Factura.fromString(regsLines[i.idx]));
    });

    return _facturas;
  }

  Future<Factura> agregar(Factura factura) async {
    factura.id = generateRandomId(SecondaryIndex.VALUE_LENGTH);

    Directory localPath = await getApplicationDocumentsDirectory();

    File indexFile = File('${localPath.path}/$idxFileName'),
        secIndexFile = File('${localPath.path}/$secIdxfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) registersFile.create();
    if (!await indexFile.exists()) indexFile.create();
    if (!await secIndexFile.exists()) secIndexFile.create();

    int startIndex = await _searchIndex(factura.userId), secIndex, regIndex;

    // If the user not save any factura yet
    if (startIndex == -1) {
      startIndex = await _getNewIndex();
      regIndex = await _getNewRegIndex();
      secIndex = await _getNewSecondaryIndex();

      await registersFile.writeAsString("${factura.toString()}\n",
          mode: FileMode.append);
      await secIndexFile.writeAsString(
          "${SecondaryIndex(idx: regIndex, keyValue: factura.id).toString()}\n",
          mode: FileMode.append);
      await indexFile.writeAsString(
          "${PrimaryIndex(key: secIndex, value: factura.userId).toString()}\n",
          mode: FileMode.append);
    } else {
      int regPos;
      SecondaryIndex reg;

      while (startIndex != -1) {
        regPos = startIndex * SecondaryIndex.REG_LEN;
        Stream streamFile =
            secIndexFile.openRead(regPos, regPos + SecondaryIndex.REG_LEN);
        StringBuffer buffer = new StringBuffer();

        await for (String data in streamFile.transform(utf8.decoder)) {
          buffer.write(data);
        }

        reg = SecondaryIndex.fromString(buffer.toString());
        startIndex = reg.nextIdx;
      }

      reg.nextIdx = await _getNewSecondaryIndex();

      // Update to point the new Secondary Index
      int index = regPos ~/ SecondaryIndex.REG_LEN;
      var secIndexLines = await secIndexFile.readAsLines();
      secIndexLines[index] = reg.toString();
      await secIndexFile.writeAsString("${secIndexLines.join('\n')}\n");

      // Get where the new register will save
      regIndex = await _getNewRegIndex();

      // Write the new Secondary Index
      await secIndexFile.writeAsString(
          "${SecondaryIndex(idx: regIndex, keyValue: factura.id).toString()}\n",
          mode: FileMode.append);

      // Write the new register
      await registersFile.writeAsString("${factura.toString()}\n",
          mode: FileMode.append);
    }
    print('Nuevo registro guardado en: ${registersFile.path}');
    print('Nuevo indice guardado en: ${indexFile.path}');
    print('Nuevo indice secundario guardado en: ${secIndexFile.path}');

    return factura;
  }

  Future modificar(Factura factura) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$idxFileName'),
        secIndexFile = File('${localPath.path}/$secIdxfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists() ||
        !await secIndexFile.exists() ||
        !await indexFile.exists()) return;

    int initialIndex = await _searchIndex(factura.userId), regPos = 0;
    SecondaryIndex reg;

    if (initialIndex == -1) Future.error('userId not found on database');
    int indexIterador = initialIndex;

    do {
      regPos = indexIterador * SecondaryIndex.REG_LEN;

      Stream streamFile =
          secIndexFile.openRead(regPos, regPos + SecondaryIndex.REG_LEN);
      StringBuffer buffer = new StringBuffer();

      await for (String data in streamFile.transform(utf8.decoder))
        buffer.write(data);

      reg = SecondaryIndex.fromString(buffer.toString());
      if (reg.keyValue == factura.id) break;
      indexIterador = reg.nextIdx;
    } while (indexIterador != -1);

    var regsLines = await registersFile.readAsLines();
    regsLines[reg.idx] = factura.toString();
    await registersFile.writeAsString("${regsLines.join('\n')}\n");

    print('Nuevo registro modificado en: ${registersFile.path}');
  }

  Future eliminar(Factura factura) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$idxFileName'),
        secIndexFile = File('${localPath.path}/$secIdxfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists() ||
        !await secIndexFile.exists() ||
        !await indexFile.exists()) return;

    int initialIndex = await _searchIndex(factura.userId),
        regPos = 0,
        prevRegPos = -1;
    SecondaryIndex reg, prevReg;

    if (initialIndex == -1) Future.error('userId not found on database');
    int indexIterador = initialIndex;

    do {
      regPos = indexIterador * SecondaryIndex.REG_LEN;

      Stream streamFile =
          secIndexFile.openRead(regPos, regPos + SecondaryIndex.REG_LEN);
      StringBuffer buffer = new StringBuffer();

      await for (String data in streamFile.transform(utf8.decoder))
        buffer.write(data);

      prevReg = reg;
      reg = SecondaryIndex.fromString(buffer.toString());
      if (reg.keyValue == factura.id) break;
      indexIterador = reg.nextIdx;
      prevRegPos = regPos;
    } while (indexIterador != -1);

    var secIndexLines = await secIndexFile.readAsLines();

    // If iterator was on more than 2 indexs
    if (prevRegPos != -1) {
      Stream streamFile = secIndexFile.openRead(
        prevRegPos,
        prevRegPos + SecondaryIndex.REG_LEN,
      );
      StringBuffer buffer = new StringBuffer();

      await for (String data in streamFile.transform(utf8.decoder))
        buffer.write(data);

      prevReg = SecondaryIndex.fromString(buffer.toString());

      // Update to point the prev Secondary Index
      prevReg.nextIdx = -1;
      int lastSecondaryIndexConnected = prevRegPos ~/ SecondaryIndex.REG_LEN;
      secIndexLines[lastSecondaryIndexConnected] = prevReg.toString();
    }
    // If the secondary index selected is the first, change the primary index pointer
    if (prevRegPos == -1 && initialIndex == regPos ~/ SecondaryIndex.REG_LEN) {
      int indexUser = await _searchUserIndex(factura.userId);

      var userIndexLines = await indexFile.readAsLines();
      if (reg.nextIdx != -1) {
        PrimaryIndex actualIndex =
            PrimaryIndex.fromString(userIndexLines[indexUser]);
        actualIndex.key = reg.nextIdx;
        userIndexLines[indexUser] = actualIndex.toString();
      } else {
        userIndexLines[indexUser] = PrimaryIndex.deleted();
      }

      await indexFile.writeAsString("${userIndexLines.join('\n')}\n");

      print('Nuevo indice eliminado en: ${indexFile.path}');
    }

    int actualSecondaryIndex = regPos ~/ SecondaryIndex.REG_LEN;
    secIndexLines[actualSecondaryIndex] = SecondaryIndex.deleted();
    await secIndexFile.writeAsString("${secIndexLines.join('\n')}\n");

    var regsLines = await registersFile.readAsLines();
    regsLines[reg.idx] = '';
    await registersFile.writeAsString("${regsLines.join('\n')}\n");

    print('Nuevo indice secundario eliminado en: ${indexFile.path}');
    print('Nuevo registro eliminado en: ${registersFile.path}');
  }

  Future<int> _getNewIndex() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$indexfileName');

    return (await registersFile.readAsLines()).length;
  }

  Future<int> _getNewSecondaryIndex() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$secIdxfileName');

    return (await registersFile.readAsLines()).length;
  }

  Future<int> _getNewRegIndex() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$fileName');

    return (await registersFile.readAsLines()).length;
  }

  /// Search initial secondary Index by userId
  Future<int> _searchIndex(String userId) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$idxFileName');

    if (!await indexFile.exists()) return -1;

    int indice = -1;
    var idxLinex = await indexFile.readAsLines();

    for (String line in idxLinex) {
      if (line == PrimaryIndex.deleted()) continue;
      PrimaryIndex index = PrimaryIndex.fromString(line);
      if (index.value == userId) {
        indice = index.key;
        break;
      }
    }
    return indice;
  }

  /// Search user index by userId
  Future<int> _searchUserIndex(String userId) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$idxFileName');
    int indice = -1;

    if (!await indexFile.exists()) return indice;

    var idxLinex = await indexFile.readAsLines();

    for (String line in idxLinex) {
      indice++;
      if (line == PrimaryIndex.deleted()) continue;
      PrimaryIndex _index = PrimaryIndex.fromString(line);

      if (_index.value == userId) return indice;
    }

    return -1;
  }

  /// Search secondary indexs by userId
  Future<MList<SecondaryIndex>> searchRegisterIndexs(int startIndex) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    MList<SecondaryIndex> indexs = MList<SecondaryIndex>();

    File secIndexFile = File('${localPath.path}/$secIdxfileName');
    if (!await secIndexFile.exists()) return indexs;

    while (startIndex != -1) {
      int regPos = startIndex * SecondaryIndex.REG_LEN;
      Stream streamFile =
          secIndexFile.openRead(regPos, regPos + SecondaryIndex.REG_LEN);
      StringBuffer buffer = new StringBuffer();

      await for (String data in streamFile.transform(utf8.decoder)) {
        buffer.write(data);
      }

      SecondaryIndex reg = SecondaryIndex.fromString(buffer.toString());
      indexs.add(reg);
      startIndex = reg.nextIdx;
    }
    return indexs;
  }
}
