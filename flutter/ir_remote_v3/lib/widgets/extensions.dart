import 'package:flutter/material.dart';

extension DividerExtension on Divider{
  DividerTheme withTheme(DividerThemeData theme) => DividerTheme(
    data: theme,
    child: this,
  );
  DividerTheme withSpace(double space) => DividerTheme(
    data: DividerThemeData(space: space),
    child: this,
  );
}
extension ListTileExtension on ListTile{
  ListTileTheme withTheme(ListTileTheme theme) => ListTileTheme(
    child: this,
  );
}
extension WidgetExtension on Widget{
  Widget paddingAll({double value = 8.0}) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );
  Widget expanded() => Expanded(child: this);
  Widget sizedBox(Size size) => SizedBox.fromSize(child: this, size: size,);
  Widget center() => Center(child: this);
}