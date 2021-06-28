// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ir_remote_v3/remote.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/pages.dart';

const port = 11111;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'remotes_base.db'),
    onCreate: (db, version) => db.execute(Remote.createTableQuery()),  version: 1,
  );
  runApp(MyApp(database: await database,));
}

var darkGrey = Colors.grey.shade900;
// var darkGrey = const Color(0xff101010);
var lightGrey = const Color(0xff252525);
var primaryColor = Colors.blue.shade200;
var shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12.0),
);
var darkTheme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.ptSansTextTheme(ThemeData.dark().textTheme),
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
    brightness: Brightness.dark,
    color: Colors.grey[900],
    iconTheme: ThemeData.dark().iconTheme,//.copyWith(color: Colors.white,),
    /**for default bottom border of appbar on dark mode
     * */
    elevation: 1,//border on bottom like bluetooth settings in stock android
    shadowColor: Colors.white,//border on bottom like bluetooth settings in stock android
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
  bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
    backgroundColor: darkGrey,
  ),
  dialogTheme: ThemeData.dark().dialogTheme.copyWith(
    backgroundColor: darkGrey,
    // shape: shape.copyWith(
    //   side: BorderSide(
    //     color: ThemeData.dark().dividerColor,
    //     width: 2,
    //   ),
    // ),
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
      // shape: shape,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(color: Colors.grey[600],),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: primaryColor,
      // shape: shape,
      side: BorderSide(
        color: primaryColor,
      ),
    ),
  ),
  scaffoldBackgroundColor: darkGrey,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      // primary: Colors.white,
      // shape: shape,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.grey[900],
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey[800],
  ),
);
class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({Key key, this.database}) : super(key: key);
  @override
  Widget build(_) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'IR Remote v3',
    theme: darkTheme,
    home: RemotesPage(database: database,),
  );
}
