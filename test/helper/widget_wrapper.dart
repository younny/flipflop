import 'package:flutter/material.dart';

class WidgetWrapper {

  static Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Material(
        child: child,
      ),
    );
  }
}
