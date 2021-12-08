import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/models/Pago.dart';
import 'package:blim/src/core/models/Perfil.dart';
import 'package:blim/src/core/models/PrimaryIndex.dart';
import 'package:blim/src/core/models/Usuario.dart';
import 'package:blim/src/core/structures/MList.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/core/utils.dart';
import 'package:blim/src/providers/ListasReproduccion.dart';
import 'package:blim/src/providers/Contenidos.dart';
import 'package:blim/src/providers/Pagos.dart';
import 'package:blim/src/providers/Perfiles.dart';
import 'package:blim/src/providers/Usuarios.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AppLogic extends ChangeNotifier {
  Usuario usuario;
  Perfil perfil;
  Usuarios _usuarios = Usuarios();
  MList<Usuario> get usuarios => _usuarios.usuarios;

  Pagos _pagos = Pagos();

  Perfiles _perfiles = Perfiles();
  MList<Perfil> get perfiles => _perfiles.perfiles;

  ListasReproduccion _listas = ListasReproduccion();
  MList<ListaReproduccion> get listas => _listas.listas;

  Contenidos _contenidos = Contenidos();
  MList<Contenido> get contenidos => _contenidos.contenidos;

  Future<void> addContent(Contenido contenido) async {
    await _contenidos.agregar(contenido);
  }

  Future<void> updateContent(Contenido contenido) async {
    await _contenidos.modificar(contenido.id, contenido);
  }

  bool get authenticated => usuario != null;

  void addProfile(Perfil tmp, [String userId]) async {
    tmp.id = generateRandomId();
    tmp.usuario = userId ?? usuario.id;

    var tmpLista = ListaReproduccion(
        id: generateRandomId(PrimaryIndex.VALUE_LENGTH),
        nombre: 'Favoritos',
        contenidos: MList<Contenido>(),
        perfil: tmp.id);

    tmp.listas ??= MList<String>();
    tmp.listas.add(tmpLista.id);

    print('ID Lista nueva: ${tmpLista.id}');

    await _perfiles.agregar(tmp);
    await _listas.agregar(tmpLista);
    notifyListeners();
  }

  void addListaReproduccion(ListaReproduccion tmp, [String perfilId]) async {
    tmp.id = generateRandomId();
    tmp.perfil = perfilId ?? perfil.id;

    _listas.agregar(tmp);
    notifyListeners();
  }

  void agregarPago(Pago tmp, [String perfilId]) async {
    tmp.id ??= generateRandomId();

    _pagos.agregar(tmp);
    notifyListeners();
  }

  void changeProfile(Perfil tmp) async {
    perfil = tmp;

    // Cargar las listas de reproducción del perfil
    await _listas.leer(tmp.listas);

    notifyListeners();
  }

  Future<void> login(Usuario user) async {
    usuario = user;
    await leerPerfiles();
    await leerListas();
    notifyListeners();
  }

  void logout() {
    usuario = null;
    perfil = null;
    _perfiles.clear();
    _listas.clear();
    notifyListeners();
  }

  Future<void> leerPerfiles() async {
    // Cargar los perfiles del usuario
    await _perfiles.leer(usuario.id);
    print(perfiles);
    int principal = perfiles.indexWhere((p) => p.principal);
    print(perfiles[principal]);
    perfil = perfiles[principal];
  }

  Future<void> leerListas() async {
    // Cargar las listas de reproducción del perfil
    await _listas.leer(perfil.listas);
    notifyListeners();
  }

  Future<void> load() async {
    if (_contenidos.contenidos?.isNotEmpty ?? false) return;
    await _contenidos.leer();
    if (_usuarios.usuarios?.isNotEmpty ?? false) return;
    await _usuarios.leer();
  }

  Future<void> modificarUsuario(String id, Usuario usuario) async {
    await _usuarios.modificar(id, usuario);
  }

  Future<void> agregarContenidoPlaylist(
    Contenido c,
    ListaReproduccion lr,
  ) async {
    await lr.contenidos.add(c);
    await _listas.modificar(lr);
  }
}
