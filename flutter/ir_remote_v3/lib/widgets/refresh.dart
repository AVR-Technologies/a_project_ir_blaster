import 'package:flutter/material.dart';

/// this widget will call onRefresh on onState() call
class Refresh extends StatelessWidget{
  /// child widget
  final Widget child;
  /// things to be done before ui rebuilds
  final Function() onRefresh;
  const Refresh({Key? key, required this.onRefresh, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    onRefresh();
    return child;
  }
}