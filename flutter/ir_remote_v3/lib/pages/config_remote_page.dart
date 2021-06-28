import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' show BluetoothConnection;
import 'package:ir_remote_v3/Storage.dart';
import 'package:ir_remote_v3/widgets/remote_buttons.dart';

import '../remote.dart';

class ConfigRemotePage extends StatefulWidget{
  final Remote remote;
  const ConfigRemotePage({Key? key, required this.remote}) : super(key: key);

  @override
  _ConfigRemotePageState createState() => _ConfigRemotePageState();
}

class _ConfigRemotePageState extends State<ConfigRemotePage> {
  int selectedIndex = 0;
  Map<KeyType, RemoteKey>? _keys;
  BluetoothConnection? connection;
  @override
  void initState() {
    super.initState();
    print(widget.remote.all.length);
    setState(() {
      _keys = Map.from(widget.remote.all)..removeWhere((key, value) => !remotePattern(widget.remote.remoteType!).contains(key));
    });
    print(_keys!.length);
    connect();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(
      title: Text('Configure remote'),
    ),
    body:  connection == null ?
    Column(
      children: [
        LinearProgressIndicator(),
        Spacer(),
        Center(child: Text('Connecting')),
        Spacer(),
      ],
    ) :
    !connection!.isConnected ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Icon(Icons.error)),
        Center(child: Text('Disconnected'))
      ],
    ) :
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: _keys!.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              onTap: ()=> setState(() => selectedIndex = index),
              leading: Icon(RemoteButtonIcon.map[_keys!.values.elementAt(index).type]!),
              selected: selectedIndex == index,
              title: Text(
                RemoteButtonLabel.map[_keys!.values.elementAt(index).type]!,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Colors.white54,),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _keys!.values.elementAt(index).irData.data!.toRadixString(16),
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                      color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Colors.white,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.keyboard_arrow_right_outlined),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              _keys!.forEach((key, value) => widget.remote.all[key] = value);
              Navigator.of(context).pop(widget.remote);
            },
          ),
        ),
      ],
    ),
  );


  //bluetooth
  connect() {
    Storage.address.then((_address) {
      BluetoothConnection
          .toAddress(_address)
          .then((value) => connection = value)
          .then((value) => value.input.listen(bluetoothInputListener,
          onDone: ()=> setState(() {}),
          onError: (_)=> setState(() {})))
          .then((_) => setMode())
          .then((_) => setState((){}));
    });
  }

  disconnect() => connection?..close()..dispose();

  bluetoothInputListener(Uint8List event) => JsonData
      .fromMap(json.decode(ascii.decode(event)))
      .then((result) {
    if (result.key == new_ir_key && selectedIndex >= 0 && selectedIndex < _keys!.length) {
      setState(() => _keys?.values.elementAt(selectedIndex).irData = result.irData);
    }
    print(_keys?.values.elementAt(selectedIndex).irData.toMap());
    print(result.irData.toMap());
    print(_keys?.values.elementAt(selectedIndex).irData.toMap());
  });


  readMode()              =>  send(JsonData(0x01, 0x00));

  setMode()               =>  send(JsonData(0x02, 0x01)); //0x01 read mode //0x00 remote mode

  send(JsonData data)     => connection?.output.add(ascii.encode(json.encode(data.toMap())));
// keyPressed(KeyData key) =>  send(JsonData(0x03, 0, irData: key.irData));
}
class JsonData{
  final int key;
  final int val;
  final IrData irData;

  const JsonData(this.key, this.val, {this.irData = const IrData.empty()});

  JsonData.fromMap(Map<String, dynamic> map) : this(
    map['key'],
    map['val'],
    irData: map.containsKey('ir') ?
    IrData.fromList((map['ir'] as List).cast<int>()) :
    IrData.empty(),
  );

  Map toMap() => {'key' : key, 'val': val, 'ir': irData.toList()};

  void then(Function(JsonData) onValue)=> onValue(this);
}