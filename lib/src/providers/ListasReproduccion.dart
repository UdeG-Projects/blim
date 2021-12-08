import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:blim/src/core/models/PrimaryIndex.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'listas_reproduccion.txt';
const String indexfileName = 'listas_reproduccion.index.txt';

class ListasReproduccion {
  MList<ListaReproduccion> listas = MList();
  MList<String> indexPeliculas = MList();

  Future<ListaReproduccion> buscar(String id) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName');
    if (!await indexFile.exists()) return null;

    var indices = await indexFile.readAsLines();
    int indice;

    indices.forEach((String line) {
      PrimaryIndex index = PrimaryIndex.fromString(line);
      if (index.value == id) indice = index.key;
    });

    File registersFile = File('${localPath.path}/$fileName');

    var lines = await registersFile.readAsLines();
    ListaReproduccion listaReproduccion =
        ListaReproduccion.fromString(lines[indice]);

    return listaReproduccion;
  }

  Future<ListaReproduccion> agregar(ListaReproduccion lista) async {
    lista.id = lista.id ?? generateRandomId(PrimaryIndex.VALUE_LENGTH);

    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) registersFile.create();
    if (!await indexFile.exists()) indexFile.create();

    PrimaryIndex newIndex =
        PrimaryIndex(key: await _getNewIndex(), value: lista.id);

    await registersFile.writeAsString("${lista.toString()}\n",
        mode: FileMode.append);
    await indexFile.writeAsString("${newIndex.toString()}\n",
        mode: FileMode.append);

    print('Nuevo registro guardado en: ${registersFile.path}');
    print('Nuevo indice guardado en: ${indexFile.path}');

    return lista;
  }

  Future<ListaReproduccion> eliminar(String id) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) return null;
    if (!await indexFile.exists()) return null;

    var indexLines = await indexFile.readAsLines();
    int regIndex, indexIndex = 0;

    for (var i = 0; i < indexLines.length; i++) {
      PrimaryIndex index = PrimaryIndex.fromString(indexLines[i]);
      if (index.value == id) {
        regIndex = index.key;
        indexIndex = i;
      }
    }

    var regsLines = await registersFile.readAsLines();
    regsLines[regIndex] = "";
    indexLines.removeAt(indexIndex);

    registersFile.writeAsString("${regsLines.join('\n')}\n");
    await indexFile.writeAsString("${indexLines.join('\n')}\n");

    print('Nuevo registro eliminado en: ${registersFile.path}');
    print('Nuevo indice eliminado en: ${indexFile.path}');
  }

  Future<ListaReproduccion> modificar(ListaReproduccion lista) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) return null;
    if (!await indexFile.exists()) return null;

    var indexLines = await indexFile.readAsLines();
    int regIndex;

    for (var i = 0; i < indexLines.length; i++) {
      PrimaryIndex index = PrimaryIndex.fromString(indexLines[i]);
      if (index.value == lista.id) {
        regIndex = index.key;
      }
    }

    var regsLines = await registersFile.readAsLines();
    regsLines[regIndex] = lista.toString();

    registersFile.writeAsString("${regsLines.join('\n')}\n");

    print('Nuevo registro modificado en: ${registersFile.path}');
  }

  Future<int> _getNewIndex() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$fileName');

    return (await registersFile.readAsLines()).length;
  }

  Future<void> leer(MList<dynamic> ids) {
    listas = MList<ListaReproduccion>();

    if (ids.length == 0) return null;

    ids.forEach((e) async {
      var tmpList = await buscar(e as String);
      listas.add(tmpList);
    });
  }

  void clear() {
    listas = MList<ListaReproduccion>();
  }
}
