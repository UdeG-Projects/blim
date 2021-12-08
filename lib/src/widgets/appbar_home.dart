import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/screens/account/constants.dart';
import 'package:blim/src/screens/account/screen.dart';
import 'package:blim/src/screens/home/screen.dart';
import 'package:blim/src/screens/lists/screen.dart';
import 'package:blim/src/screens/login/screen.dart';
import 'package:blim/src/widgets/dashboard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TabItem {
  String title, route;
  TabItem({this.title, this.route});
}

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  DefaultAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  final tabs = [
    TabItem(title: 'TV EN VIVO', route: '/tv'),
    TabItem(title: 'SERIES', route: '/series'),
    TabItem(title: 'PELÍCULAS', route: '/peliculas'),
    TabItem(title: 'NOVELAS', route: '/novelas'),
  ];

  AppLogic appLogic;

  @override
  Widget build(BuildContext context) {
    appLogic = context.watch<AppLogic>();
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      height: kToolbarHeight,
      color: Colors.black,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (ModalRoute.of(context).settings.name != HomeScreen.routeName)
            IconButton(
                onPressed: () => Navigator.pop(context),
                color: Color(0xff03D3EE),
                icon: Icon(Icons.arrow_back))
          else
            Container(
              padding: EdgeInsets.all(16),
              child: Image.asset('assets/blim-logo.png'),
            ),
          SizedBox(width: 12),
          if (ModalRoute.of(context).settings.name == '/')
            ...tabs.map((e) => Container(
                  margin: EdgeInsets.only(left: 6),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom().copyWith(
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (s) {
                          if (s.contains(MaterialState.hovered))
                            return Colors.blue;

                          return Colors.grey;
                        },
                      ),
                    ),
                    child: Text(e.title),
                  ),
                )),
          Expanded(child: Container()),
          if (ModalRoute.of(context).settings.name == '/')
            IconButton(
                onPressed: () {},
                color: Colors.grey.shade600,
                icon: Icon(Icons.search)),
          SizedBox(width: 12),
          if (ModalRoute.of(context).settings.name !=
              LoginScreen.routeName) ...[
            if (!appLogic.authenticated)
              Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          colors: [Color(0xff00d3ef), Color(0xff2abbac)])),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context)
                            .pushNamed(LoginScreen.routeName);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 0,
                          primary: Colors.transparent),
                      icon: Icon(Icons.login),
                      label: Text('INICIAR')))
            else
              InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor:
                        colors[appLogic?.perfil?.color ?? 0].withOpacity(0.5),
                    child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.person_outline,
                          color: colors[appLogic?.perfil?.color ?? 0]
                                      .computeLuminance() <
                                  0.5
                              ? Colors.white70
                              : Colors.black,
                        ),
                        offset: Offset(0, 50),
                        onSelected: (v) async {
                          if (v == null) return;
                          if (ModalRoute.of(context).settings.name != '/')
                            Navigator.pop(context);
                          if (ModalRoute.of(context).settings.name != v)
                            Navigator.of(context).pushNamed(v);
                        },
                        color: Colors.black87,
                        itemBuilder: (_) => [
                              PopupMenuItem<String>(
                                onTap: null,
                                child: SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...appLogic.perfiles.toWidgets(
                                        (p) => Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: p.id == appLogic.perfil.id
                                                ? null
                                                : () {
                                                    appLogic.changeProfile(p);
                                                    Navigator.pop(context);
                                                  },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  colors[p.color ?? 0]
                                                      .withOpacity(0.6),
                                              child: Icon(
                                                Icons.person_outline_rounded,
                                                size: 18,
                                                color: colors[p.color ?? 0]
                                                            .computeLuminance() <
                                                        0.5
                                                    ? Colors.white70
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              PopupMenuItem<String>(
                                value: MyAccountScreen.routeName,
                                child: Text('Mi cuenta'),
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              PopupMenuItem<String>(
                                child: Text('Mis listas'),
                                textStyle: TextStyle(color: Colors.white),
                                value: MyListsScreen.routeName,
                              ),
                              PopupMenuItem<String>(
                                child: Text('Cerrar sesión'),
                                textStyle: TextStyle(color: Colors.white),
                                onTap: () => onLogout(context),
                              ),
                            ]),
                  ))
          ],
          SizedBox(width: 12),
          if (ModalRoute.of(context).settings.name == '/')
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DashboardDialog(),
                  );
                },
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ))
        ],
      ),
    );
  }

  onLogout(context) async {
    appLogic.logout();
  }
}
