import 'package:flutter/material.dart';

extension WidgetModifier on Widget{
  Widget paddingAll({double value}) => Padding(
    padding: EdgeInsets.all(value ?? 8.0),
    child: this,
  );
  Widget expanded() => Expanded(child: this);
  Widget sizedBox(Size size) => SizedBox.fromSize(child: this, size: size,);
  Widget center() => Center(child: this);
}