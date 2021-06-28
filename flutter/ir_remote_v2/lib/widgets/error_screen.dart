import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget{
  final String message;

  const ErrorScreen({Key key, this.message}) : super(key: key);

  @override
  Widget build(context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.sentiment_very_dissatisfied_rounded,
          size: 200,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    ),
  );
}