import 'package:blim/src/core/models/Contenido.dart';
import 'package:blim/src/core/models/ListaReproduccion.dart';
import 'package:blim/src/providers/AppLogic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistDialog extends StatefulWidget {
  PlaylistDialog({Key key, this.contenido}) : super(key: key);
  Contenido contenido;

  @override
  State<PlaylistDialog> createState() => _PlaylistDialogState();
}

class _PlaylistDialogState extends State<PlaylistDialog> {
  AppLogic appLogic;
  ListaReproduccion lista;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => appLogic = context.read<AppLogic>());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Agregar a playlist',
              style: textTheme.headline5.apply(fontWeightDelta: 2),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Image.network(
                widget.contenido.imagen,
                fit: BoxFit.cover,
              ),
              title: Text(widget.contenido.titulo),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<ListaReproduccion>(
                value: lista,
                onChanged: (v) => setState(() => lista = v),
                decoration: InputDecoration(
                  label: Text('Seleccionar playlist'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                items: appLogic.listas
                    .toWidgets((e) =>
                        DropdownMenuItem(value: e, child: Text(e.nombre)))
                    .cast<DropdownMenuItem<ListaReproduccion>>()),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('Agregar '),
                onPressed: lista == null
                    ? null
                    : () async {
                        appLogic.agregarContenidoPlaylist(
                            widget.contenido, lista);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Se ha agregado a tu playlist.')));
                      },
              ),
            )
          ],
        ),
      ),
    );
  }
}
