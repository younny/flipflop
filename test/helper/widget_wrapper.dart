import 'package:flutter/material.dart';

Widget wrap(Widget child) {
  return MaterialApp(
    home: Material(
      child: child,
    ),
  );
}

Widget wrapWithContext(Function injectChild) {
  return MaterialApp(
    home: Material(
      child: Builder(
        builder: (BuildContext context) {
          return Container(
            child: injectChild(context),
          );
        },
      ),
    )
  );
}