import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IndexCircular extends StatelessWidget {
  Color _color;
  IndexCircular({Key key, Color color})
      : _color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 2, left: 2),
      child: new ClipRRect(
        borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
        child: new Container(
          width: 7.0,
          height: 7.0,
          color: _color,
        ),
      ),
    );
  }
}
