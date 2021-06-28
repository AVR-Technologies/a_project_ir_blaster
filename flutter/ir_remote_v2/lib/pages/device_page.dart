import 'dart:convert';
import 'dart:typed_data';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ir_remote/widgets/error_screen.dart';
import 'package:ir_remote/widgets/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'remotes/tv_remote.dart';
import '../key_data.dart';
import '../main.dart';

class DevicePage extends StatefulWidget{
  final BluetoothDevice device;
  const DevicePage({Key key, this.device}) : super(key: key);
  @override _DevicePageState createState() => _DevicePageState();
}
class _DevicePageState extends State<DevicePage> {
  var devices             = <BluetoothDevice>[];
  var remotes             = <Remote>[ Remote('name') ];
  var selectedDeviceIndex = 0;
  var selectedRemoteIndex = 0;
  var selectedInputIndex  = -1;
  var onRemotePage        = true;

  BluetoothConnection connection;
  var _prefs = SharedPreferences.getInstance();
  var newRemoteFormKey = GlobalKey<FormState>();


  @override void initState() {
    super.initState();
    scanPref();
    connect();
  }

  @override void dispose() {
    disconnect();
    super.dispose();
  }


  @override
  Widget build(context) => BackdropScaffold(
    backLayerBackgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    headerHeight: 0,
    appBar: appBar(),
    backLayer: backLayer(),
    frontLayer: frontLayer(),
  );

  Widget appBar() => AppBar(
    title: Text(widget.device.name),
    actions: <Widget>[
      IconButton(
        icon: Icon( onRemotePage ? Icons.settings : Icons.settings_remote),
        onPressed: setMode,
      ),
      BackdropToggleButton(
        color: Theme.of(context).appBarTheme.iconTheme.color,
        icon: AnimatedIcons.close_menu,
      ),
    ],
  );

  Widget backLayer() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ListTile(
        dense: true,
        title: Text('AVAILABLE REMOTES'),
      ),
      Expanded(
        child: ListView.separated(
          itemCount: remotes.length,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              child: selectedRemoteIndex == index ? Icon(Icons.check) : Text(remotes[index].name[0]),
              backgroundColor: selectedRemoteIndex == index ? primaryColor : Colors.black,
            ),
            selectedTileColor: primaryColor.withOpacity(0.3),
            selected: selectedRemoteIndex == index,
            title: Text(remotes[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: ()=> showDialog(
                    context: context,
                    builder: (_) => deleteRemoteConfirmDialog(index),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
          separatorBuilder: (_,  __) => Divider(),
        ),
      ),//deleted
      Padding(
        child: ElevatedButton(
          child: const Text('CREATE'),
          onPressed: ()=> showDialog(
            context: context,
            builder: newRemoteDialog,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
      ),
    ],
  );

  Widget frontLayer() => SafeArea(
    child: connection == null ? LoadingScreen() :
    !connection.isConnected ? ErrorScreen() :
    remotes.length > 0 ? Let(
      let: remotes[selectedRemoteIndex],
      builder: (Remote let) => !onRemotePage ? editPage() : TVRemote(
        remote: let,
        connection: connection,
      ),
    ) :
    ErrorScreen(message: 'Error',),
  );

  Widget editPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('EDIT REMOTE',),
                ),
                Divider(),
                TextField(
                  controller: remotes[selectedRemoteIndex].controller,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.title),//ascii if text/number character
                    prefix: Text('Name'),
                    suffixIcon: Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Divider(),
                ...List.generate(remotes[selectedRemoteIndex].keys.length, (index) => Column(
                  children: [
                    field(index, remotes[selectedRemoteIndex].keys[index],),
                    Divider(),
                  ],
                  mainAxisSize: MainAxisSize.min,),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        child: ElevatedButton(
          child: const Text('SAVE'),
          onPressed: () => saveToPref(true),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
      ),
    ],
  );

  Widget field(int _index, KeyData key) => TextField(
    controller: key.controller,
    decoration: InputDecoration(
      hintText: key.hintText,
      prefixIcon: Icon(key.icon,),
      prefix: Text(key.hintText,),
      suffixIcon: Icon(Icons.keyboard_arrow_right_outlined,),
    ),
    enableInteractiveSelection: false,
    onTap: () => setState(() => selectedInputIndex = _index,),
    readOnly: true,
    textDirection: TextDirection.rtl,
  );

  Widget newRemoteDialog(BuildContext context) => AlertDialog(
    title: Text('New remote',textAlign: TextAlign.center,),
    content: Form(
      key: newRemoteFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                errorStyle: TextStyle(
                  color: Colors.red[300],
                ),
              ),
            ),
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter new remote name',
              ),
              validator: (value){
                if (value.isEmpty) return 'This remote needs a name';
                remotes.add(Remote(value));
                Navigator.pop(context);
                saveToPref(false);
                setState(() {});
                return null;
              },
            ),
          ),
          DividerTheme(
            data: DividerTheme.of(context).copyWith(
              space: 20,
              indent: 0,
              endIndent: 0,
            ),
            child: Divider(),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.check_rounded),
            label: Text('Create remote'),
            onPressed: (){
              if(newRemoteFormKey.currentState.validate()) newRemoteFormKey.currentState.save();
            },
          ),
          OutlinedButton.icon(
            icon: Icon(Icons.clear_rounded),
            label: Text('Cancel'),
            onPressed: ()=> Navigator.pop(context),
          ),
        ],
      ),
    ),
  );

  Widget deleteRemoteConfirmDialog(int index) => AlertDialog(
    title: Text('Delete remote', textAlign: TextAlign.center,),
    content: Column(
      children: [
        Text('This will delete remote permanently.'),
        DividerTheme(
          data: DividerTheme.of(context).copyWith(
            space: 20,
            indent: 0,
            endIndent: 0,
          ),
          child: Divider(),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.delete_forever_rounded),
          label: Text('Delete'),
          onPressed: (){
            remotes.removeAt(index);
            Navigator.pop(context);
            saveToPref(false);
            setState(() {});
          },
        ),
        OutlinedButton.icon(
          icon: Icon(Icons.clear_rounded),
          label: Text('Cancel'),
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
    ),
  );

  readMode()              =>  send(JsonData(0x01, 0x00));

  setMode()               =>  send(JsonData(0x02, onRemotePage ? 0x01 : 0x00));

  keyPressed(KeyData key) =>  send(JsonData(0x03, 0, irData: key.irData));

  //bluetooth
  connect() => BluetoothConnection
      .toAddress(widget.device.address)
      .then((value) => connection = value)
      .then((value) => value.input.listen(bluetoothInputListener))
      .then((_) => readMode())
      .then((_) => setState((){}));

  disconnect() =>
      connection == null ?
      print('error') :
      connection
          .close()
          .then((_) => connection.dispose())
          .then((_) => print('disconnected :)'));

  bluetoothInputListener(Uint8List event) => JsonData
      .fromMap(json.decode(ascii.decode(event)))
      .then((result) {
    if(result.key == send_mode) setState(() => onRemotePage = result.val == 0x00);
    else if(result.key == new_ir_key)
      if(selectedInputIndex >= 0 && selectedInputIndex < remotes[selectedRemoteIndex].keys.length)
        setState(() => remotes[selectedRemoteIndex].keys[selectedInputIndex].irData = result.irData);
  });

  send(JsonData data) => connection.output.add(ascii.encode(json.encode(data.toMap())));

  //preferences
  scanPref() => _prefs.then((prefs) => prefs.getKeys().length > 0 ? readPref() : initPref());

  readPref() => _prefs
      .then((value) => !value.containsKey('remotes')
      ? initPref()
      : setState(() => remotes =
      (json.decode(value.getString('remotes')) as List)
          .map((e) => Remote.fromJson(e))
          .toList()));

  initPref() => _prefs.then((prefs) => prefs
      .clear()
      .then((_) => remotes = [Remote('remote 1'), Remote('remote 2')])
      .then((_) => prefs.setString("remotes", json.encode(remotes)))
      .then((_) => setState(() {})));

  saveToPref(bool changePage) => _prefs
      .then((value) => value.setString('remotes', json.encode(remotes)))
      .then((success) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(success ? 'Saved' : 'Error saving'))))
      .then((_) => changePage ? setMode() : 0)
      .then((_) => setState((){}));
}
