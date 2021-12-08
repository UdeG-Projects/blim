import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/models/Date.dart';
import 'package:blim/src/core/models/Pago.dart';

import 'package:blim/src/providers/AppLogic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardDialog extends StatefulWidget {
  const DashboardDialog({Key key}) : super(key: key);

  @override
  State<DashboardDialog> createState() => _DashboardDialogState();
}

class _DashboardDialogState extends State<DashboardDialog>
    with TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  Contenido contenido = Contenido();
  AppLogic appLogic;
  String imageContent;
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    appLogic = context.watch();

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text('Panel de Administrador',
                  style: textTheme.headline6
                      .apply(fontWeightDelta: 2, color: Colors.white)),
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            TabBar(controller: tabController, tabs: [
              Tab(
                  child:
                      Text('Contenido', style: TextStyle(color: Colors.black))),
              Tab(child: Text('Pagos', style: TextStyle(color: Colors.black))),
            ]),
            SizedBox(height: 12),
            SizedBox(
              height: 350,
              child: TabBarView(
                controller: tabController,
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 4, right: 12),
                                width: 150,
                                height: 230,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(contenido.imagen ??
                                            imageContent ??
                                            ''))),
                              ),
                              Form(
                                key: formKey,
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 6),
                                      TextFormField(
                                        controller: TextEditingController()
                                          ..text = contenido.titulo,
                                        validator: (value) =>
                                            value.isEmpty ? 'Titulo' : null,
                                        onSaved: (v) => contenido.titulo = v,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            label: Text('Titulo')),
                                      ),
                                      SizedBox(height: 6),
                                      TextFormField(
                                        controller: TextEditingController()
                                          ..text = contenido.descripcion,
                                        validator: (value) => value.isEmpty
                                            ? 'Descripción necesaria'
                                            : null,
                                        onSaved: (v) =>
                                            contenido.descripcion = v,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            label: Text('Descripcion')),
                                      ),
                                      SizedBox(height: 6),
                                      TextFormField(
                                        controller: TextEditingController()
                                          ..text = contenido.imagen ??
                                              imageContent ??
                                              '',
                                        validator: (value) => value.isEmpty
                                            ? 'Imagen necesaria'
                                            : null,
                                        onChanged: (v) =>
                                            setState(() => imageContent = v),
                                        onSaved: (v) => contenido.imagen = v,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            label: Text('Imagen')),
                                      ),
                                      SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                          onChanged: (v) => contenido.tipo = v,
                                          onSaved: (v) => contenido.tipo = v,
                                          decoration: InputDecoration(
                                            label: Text('Tipo de contenido'),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: 'TV Novela',
                                              child: Text('TV Novela'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Pelicula',
                                              child: Text('Pelicula'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Serie',
                                              child: Text('Serie'),
                                            ),
                                          ].cast<DropdownMenuItem<String>>()),
                                      SizedBox(height: 28),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(16)),
                                              onPressed: onCreate,
                                              child: Text('Agregar contenido'))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: appLogic.usuarios.toWidgets(
                          (e) => ListTile(
                            title: Text(e.usuario),
                            subtitle: Text(
                                e.nombre.isNotEmpty ? e.nombre : 'SIN NOMBRE'),
                            trailing: Column(
                              children: [
                                Text('Realizar cobro del mes'),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () => realizarCobro('VISA'),
                                        child: Text('VISA')),
                                    SizedBox(width: 12),
                                    ElevatedButton(
                                        onPressed: () =>
                                            realizarCobro('MASTERCARD'),
                                        child: Text('MASTERCARD')),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onCreate() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    await appLogic.addContent(contenido);
    setState(() => contenido = Contenido());
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Se ha agregado el contenido')));
  }

  realizarCobro(String metodo) async {
    await appLogic.agregarPago(
      Pago(fecha: Date.now(), monto: 100, metodo: metodo),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha realizado el cobro al usuario')));
  }
}
