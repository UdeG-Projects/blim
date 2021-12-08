import 'package:blim/src/core/models/Perfil.dart';
import 'package:blim/src/screens/account/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateProfileDialog extends StatefulWidget {
  CreateProfileDialog({Key key, this.barrierDimisible = true})
      : super(key: key);
  bool barrierDimisible;

  @override
  State<CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<CreateProfileDialog> {
  Perfil tmpPerfil = Perfil();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Crear perfil',
                style: textTheme.headline6.apply(fontWeightDelta: 2)),
            SizedBox(height: 8),
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              width: 76,
              height: 76,
              child: Icon(
                Icons.person_outline_rounded,
                size: 32,
                color: colors[tmpPerfil.color].withOpacity(0.8),
              ),
              decoration: BoxDecoration(
                  color: colors[tmpPerfil.color].withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(height: 8),
            Container(
              height: 32,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: colors
                      .map(
                        (e) => Container(
                          margin: EdgeInsets.only(right: 6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(
                                () => tmpPerfil.color = colors.indexOf(e)),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors[tmpPerfil.color] == e
                                    ? e.withOpacity(0.5)
                                    : e,
                              ),
                              width: 32,
                              height: 32,
                              child: colors[tmpPerfil.color] == e
                                  ? Icon(Icons.done)
                                  : null,
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                onChanged: (v) => setState(() => tmpPerfil.apodo = v),
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    label: Text('Apodo'),
                    hintText: 'Apodo',
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: 8),
            CheckboxListTile(
                dense: true,
                title: Text('Restricción de contenido'),
                subtitle: Text('Este perfil es de un menor de edad'),
                value: tmpPerfil.restriccion,
                onChanged: (v) => setState(() => tmpPerfil.restriccion = v)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.barrierDimisible)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Descartar'),
                  ),
                SizedBox(width: 12),
                ElevatedButton(
                    onPressed: tmpPerfil.apodo?.isNotEmpty ?? false
                        ? () => Navigator.pop(context, tmpPerfil)
                        : null,
                    child: Text('Guardar perfil'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
