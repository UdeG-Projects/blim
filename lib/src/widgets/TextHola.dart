import 'package:flutter/widgets.dart';

class HolaText extends StatefulWidget {
  HolaText({Key key, this.text}) : super(key: key);

  String text;

  @override
  _HolaTextState createState() => _HolaTextState();
}

class _HolaTextState extends State<HolaText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}
