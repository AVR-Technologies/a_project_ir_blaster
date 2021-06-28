import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RoundButton extends StatelessWidget{
  final Function() onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final EdgeInsetsGeometry margin;
  final double radius;
  const RoundButton({Key key, this.onTap, this.backgroundColor, this.foregroundColor, this.icon, this.margin, this.radius = 40}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
    padding: margin ?? const EdgeInsets.all(8.0),
    // child: Material(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(radius ?? 30),
    //   ),
    //   color: backgroundColor ?? lightGrey,
    //   child: InkWell(
    //     borderRadius: BorderRadius.circular(radius ?? 30),
    //     onTap: onTap,
    //     child: Padding(
    //       padding: EdgeInsets.all(radius ?? 20.0),
    //       child: Icon(icon ?? Icons.power_settings_new, color: foregroundColor ?? Colors.red[400],),
    //     ),
    //   ),
    // ),
    // child: SizedBox.fromSize(
    //   size: Size.square(radius*2),
    //   child: Material(
    //     color: backgroundColor ?? Colors.grey[900],
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(radius),
    //     ),
    //     child: InkWell(
    //       borderRadius: BorderRadius.circular(radius),
    //       onTap: (){},
    //       child: Center(child: Icon(icon, color: foregroundColor ?? Colors.red[400],)),
    //     ),
    //   ),
    // ),
    child: TextButton(
      child: Icon(icon),
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: backgroundColor,
        primary: foregroundColor,
        minimumSize: Size.square(radius ?? 50),
      ),
    ),
  );
}
