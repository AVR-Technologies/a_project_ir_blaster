// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/devices_page.dart';

void main() => runApp(MyApp());

var darkGrey = const Color(0xff101010);
var lightGrey = const Color(0xff252525);
var primaryColor = Colors.blue.shade300;
var shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12.0),
);
var darkTheme = ThemeData.dark().copyWith(
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
    color: Colors.grey[900],
    elevation: 0,
    iconTheme: ThemeData.dark().iconTheme.copyWith(
      color: primaryColor,
    ),
  ),
  buttonColor: primaryColor,
  cardColor: darkGrey,
  cardTheme: ThemeData.dark().cardTheme.copyWith(
    elevation: 0,
    margin: EdgeInsets.all(6.0),
    shape: shape.copyWith(
      side: BorderSide(
        color: ThemeData.dark().dividerColor,
        width: 2,
      ),
    ),
  ),
  colorScheme: ColorScheme(
    primary: primaryColor,
    primaryVariant: primaryColor,
    secondary: primaryColor,
    secondaryVariant: primaryColor,
    surface: darkGrey,
    background: darkGrey,
    error: Colors.red[200],
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.red[200],
    brightness: Brightness.dark,
  ),
  dialogBackgroundColor: darkGrey,
  dialogTheme: ThemeData.dark().dialogTheme.copyWith(
    shape: shape.copyWith(
      side: BorderSide(
        color: ThemeData.dark().dividerColor,
        width: 2,
      ),
    ),
  ),
  dividerTheme: ThemeData.dark().dividerTheme.copyWith(
    indent: 8,
    endIndent: 8,
    space: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      onPrimary: Colors.grey[900],
      primary: primaryColor,
      shape: shape,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(color: Colors.grey[600],),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: primaryColor,
      shape: shape,
      side: BorderSide(
        color: primaryColor,
      ),
    ),
  ),
  scaffoldBackgroundColor: darkGrey,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: primaryColor,
      shape: shape,
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
    home: DevicesPage(),
    debugShowCheckedModeBanner: false,
    theme: darkTheme,
    title: 'IR Remote v2',
  );
}
