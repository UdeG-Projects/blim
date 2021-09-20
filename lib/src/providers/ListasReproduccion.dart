import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:blim/src/core/models/RegisterIndex.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const String fileName = 'listas_reproduccion.txt';
const String indexfileName = 'listas_reproduccion.index.txt';

class ListasReproduccion {
  MList<ListaReproduccion> peliculas = MList();
  MList<String> indexPeliculas = MList();

  Future<ListaReproduccion> buscar(String id) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName');
    if (!await indexFile.exists()) return null;

    var indices = indexFile.readAsLinesSync();
    int indice;
    indices.forEach((String line) {
      RegisterIndex index = RegisterIndex.fromString(line);
      if (index.value == id) indice = index.key;
    });

    File registersFile = File('${localPath.path}/$fileName');

    var lines = registersFile.readAsLinesSync();
    ListaReproduccion listaReproduccion =
        ListaReproduccion.fromString(lines[indice]);

    return listaReproduccion;
  }

  Future<ListaReproduccion> agregar(ListaReproduccion lista) async {
    lista.id = generateRandomId(RegisterIndex.VALUE_LENGTH);

    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) registersFile.create();
    if (!await indexFile.exists()) indexFile.create();

    RegisterIndex newIndex =
        RegisterIndex(key: await _getNewIndex(), value: lista.id);

    registersFile.writeAsString("${lista.toString()}\n", mode: FileMode.append);
    indexFile.writeAsString("${newIndex.toIndexString()}\n",
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

    var indexLines = indexFile.readAsLinesSync();
    int regIndex, indexIndex = 0;

    for (var i = 0; i < indexLines.length; i++) {
      RegisterIndex index = RegisterIndex.fromString(indexLines[i]);
      if (index.value == id) {
        regIndex = index.key;
        indexIndex = i;
      }
    }

    var regsLines = registersFile.readAsLinesSync();
    regsLines[regIndex] = "";
    indexLines.removeAt(indexIndex);

    registersFile.writeAsString("${regsLines.join('\n')}\n");
    indexFile.writeAsStringSync("${indexLines.join('\n')}\n");

    print('Nuevo registro eliminado en: ${registersFile.path}');
    print('Nuevo indice eliminado en: ${indexFile.path}');
  }

  Future<ListaReproduccion> modificar(ListaReproduccion lista) async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File indexFile = File('${localPath.path}/$indexfileName'),
        registersFile = File('${localPath.path}/$fileName');

    if (!await registersFile.exists()) return null;
    if (!await indexFile.exists()) return null;

    var indexLines = indexFile.readAsLinesSync();
    int regIndex;

    for (var i = 0; i < indexLines.length; i++) {
      RegisterIndex index = RegisterIndex.fromString(indexLines[i]);
      if (index.value == lista.id) {
        regIndex = index.key;
      }
    }

    var regsLines = registersFile.readAsLinesSync();
    regsLines[regIndex] = lista.toString();

    registersFile.writeAsString("${regsLines.join('\n')}\n");

    print('Nuevo registro modificado en: ${registersFile.path}');
  }

  Future<int> _getNewIndex() async {
    Directory localPath = await getApplicationDocumentsDirectory();
    File registersFile = File('${localPath.path}/$fileName');

    return registersFile.readAsLinesSync().length;
  }
}
