import 'package:flutter/material.dart';

class DoubleButton extends StatelessWidget{
  final Color backgroundColor;
  final Function() onTapUp;
  final Function() onTapDown;
  final String title;
  final IconData iconUp;
  final IconData iconDown;
  final Size size;
  const DoubleButton({
    Key key,
    @required this.backgroundColor,
    @required this.onTapUp,
    @required this.onTapDown,
    @required this.size,
    @required this.title,
    @required this.iconUp,
    @required this.iconDown}) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox.fromSize(
      size: size ?? Size(60, 180),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width/2 ?? 30),
        ),
        color: backgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.width/2 ?? 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(size.width/2 ?? 30)),
                  onTap: onTapUp,
                  child: Center(
                    child: Icon(iconUp),
                  ),
                ),
              ),
              Expanded(child: Center(child: Text(title))),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(size.width/2 ?? 30)),
                  onTap: onTapDown,
                  child: Center(
                    child: Icon(iconDown),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

}