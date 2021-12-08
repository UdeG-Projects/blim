import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/widgets/appbar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyListsScreen extends StatelessWidget {
  MyListsScreen({Key key}) : super(key: key);
  static String routeName = '/mylists';
  AppLogic appLogic;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    appLogic = context.read<AppLogic>();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: DefaultAppBar(),
      body: Container(
        margin: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis listas de reproducción',
              style: textTheme.headline5.apply(fontWeightDelta: 2),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                  children: appLogic.listas.toWidgets(
                (e) => Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.nombre,
                        style: textTheme.headline6.apply(fontWeightDelta: 2),
                      ),
                      SizedBox(height: 12),
                      if (e.contenidos.isEmpty)
                        Center(
                          child: Text('No se han agregado contenidos aún.'),
                        )
                      else
                        Container(
                          width: screenSize.width,
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: e.contenidos.toWidgets((c) {
                              return AspectRatio(
                                aspectRatio: 5 / 7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(c.imagen))),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
