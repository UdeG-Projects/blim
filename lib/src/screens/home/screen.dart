import 'dart:async';

import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/widgets/appbar_home.dart';
import 'package:blim/src/widgets/onhover.dart';
import 'package:blim/src/widgets/playlist_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HeaderContent {
  String title, description, image;

  HeaderContent({this.title, this.description, this.image});
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  static String routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int headerSelected = 0;

  final headers = [
    HeaderContent(
        title: 'Libre para Amarte',
        description:
            '¡Taxiiiii! Súbete a este viaje romántico. Aurora es instructora en un gimnasio y taxista, cuando el amor le marca el alto.',
        image:
            'https://static0.blim.com/images/picture/2021/11/08/53112/libreparaamarte_aspot_l_7.jpg'),
    HeaderContent(
        title: 'Hijas de la Luna',
        description:
            'Las cuatro Juanas nacieron el mismo año y son hijas del mismo hombre. Juana Victoria descubre la verdad e inicia su búsqueda.',
        image:
            'https://static0.blim.com/images/picture/2021/11/07/53042/hijasdelaluna_aspot_l_7.jpg'),
    HeaderContent(
        title: 'Perdiendo el juicio',
        description:
            '¡Preestreno! El Coque Muñiz rendirá cuentas al ser enjuiciado por haberse equivocado al cantar el Himno Nacional.',
        image:
            'https://static0.blim.com/images/picture/2021/11/07/53052/pej_aspot_l_7.jpg')
  ];

  Timer timer;

  @override
  void initState() {
    setState(() {
      timer = Timer.periodic(Duration(seconds: 6), (timer) {
        setState(() {
          if (headerSelected == headers.length - 1)
            setState(() => headerSelected = 0);
          else
            setState(() => headerSelected += 1);
        });
      });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        future = appLogic.load();
      });
    });
  }

  Future future;
  AppLogic appLogic;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    appLogic = context.watch();

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: DefaultAppBar(),
          body: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator.adaptive());

                return ListView(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: screenSize.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    headers[headerSelected].image))),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [Colors.black, Colors.transparent]),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: screenSize.width * .4,
                                  margin:
                                      EdgeInsets.only(left: 40, bottom: 120),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        headers[headerSelected].title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        headers[headerSelected].description,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient: LinearGradient(colors: [
                                                Color(0xff00d3ef),
                                                Color(0xff2abbac)
                                              ])),
                                          child: ElevatedButton.icon(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                  enableFeedback: false,
                                                  elevation: 0,
                                                  primary: Colors.transparent),
                                              icon: Icon(appLogic.authenticated
                                                  ? Icons.play_arrow
                                                  : Icons.login),
                                              label: Text(appLogic.authenticated
                                                  ? 'VER AHORA'
                                                  : 'REGISTRATE Y DISFRUTA GRATIS'))),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: headers
                                          .map((e) => OnHover(
                                              builder: (isHovered) =>
                                                  GestureDetector(
                                                    onTap: () => setState(() =>
                                                        headerSelected =
                                                            headers.indexOf(e)),
                                                    child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 200),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 2),
                                                        width: 25,
                                                        color: isHovered ||
                                                                headerSelected ==
                                                                    headers
                                                                        .indexOf(
                                                                            e)
                                                            ? Colors.white
                                                            : Colors.grey,
                                                        height: 3),
                                                  )))
                                          .toList()),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pelicula',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          SizedBox(height: 12),
                          if (appLogic.contenidos
                              .where((e) => e.tipo == 'Pelicula')
                              .isEmpty)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text('No hay peliculas.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          else
                            Container(
                              height: 200,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: appLogic.contenidos
                                      .where((e) => e.tipo == 'Pelicula')
                                      .toWidgets(
                                        (e) => Container(
                                          margin: EdgeInsets.only(right: 12),
                                          child: AspectRatio(
                                            aspectRatio: 5 / 7,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                e.imagen))),
                                                  ),
                                                  if (appLogic.authenticated)
                                                    Align(
                                                      alignment:
                                                          Alignment(0.9, 0.9),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                minimumSize:
                                                                    Size.zero,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                fixedSize: Size(
                                                                    35, 35),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        onPressed: () =>
                                                            agregarAPlaylist(e),
                                                        child: Icon(Icons
                                                            .add_box_rounded),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Series',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          SizedBox(height: 12),
                          if (appLogic.contenidos
                              .where((e) => e.tipo == 'Series')
                              .isEmpty)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text('No hay Series.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          else
                            Container(
                              height: 200,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: appLogic.contenidos
                                      .where((e) => e.tipo == 'Series')
                                      .toWidgets(
                                        (e) => Container(
                                          margin: EdgeInsets.only(right: 12),
                                          child: AspectRatio(
                                            aspectRatio: 5 / 7,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                e.imagen))),
                                                  ),
                                                  if (appLogic.authenticated)
                                                    Align(
                                                      alignment:
                                                          Alignment(0.9, 0.9),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                minimumSize:
                                                                    Size.zero,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                fixedSize: Size(
                                                                    35, 35),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        onPressed: () =>
                                                            agregarAPlaylist(e),
                                                        child: Icon(Icons
                                                            .add_box_rounded),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TV Novelas',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          SizedBox(height: 12),
                          if (appLogic.contenidos
                              .where((e) => e.tipo == 'TV Novelas')
                              .isEmpty)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text('No hay TV Novelas.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          else
                            Container(
                              height: 200,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: appLogic.contenidos
                                      .where((e) => e.tipo == 'TV Novelas')
                                      .toWidgets(
                                        (e) => Container(
                                          margin: EdgeInsets.only(right: 12),
                                          child: AspectRatio(
                                            aspectRatio: 5 / 7,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                e.imagen))),
                                                  ),
                                                  if (appLogic.authenticated)
                                                    Align(
                                                      alignment:
                                                          Alignment(0.9, 0.9),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                minimumSize:
                                                                    Size.zero,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                fixedSize: Size(
                                                                    35, 35),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        onPressed: () =>
                                                            agregarAPlaylist(e),
                                                        child: Icon(Icons
                                                            .add_box_rounded),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                );
              })),
    );
  }

  agregarAPlaylist(Contenido contenido) async {
    await showDialog(
      context: context,
      builder: (_) => PlaylistDialog(contenido: contenido),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
