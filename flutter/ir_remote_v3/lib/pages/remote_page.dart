import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../Storage.dart';
import '../remote.dart';
import 'config_remote_page.dart';
import 'remotes/remotes.dart';

class RemotePage extends StatefulWidget{
  final Remote remote;
  const RemotePage({Key? key, required this.remote}) : super(key: key);

  @override
  _RemotePageState createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  BluetoothConnection? connection;
  Timer? timer;
  int counter = 0;

  @override
  void initState() {
    connect();
    count();
    super.initState();
  }

  @override
  void dispose() {
    disconnect();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.remote.name),
      ),
      body: connection == null ? Column(
        children: [
          LinearProgressIndicator(),
          Spacer(),
          Center(child: Text('Connecting')),
          Spacer(),
        ],
      ) : !connection!.isConnected ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Icon(Icons.error)),
          Center(child: Text('Disconnected'))
        ],
      ) :
      widget.remote.remoteType == RemoteType.music_player ?
      RemoteMusicPlayer() : RemoteTv(remote: widget.remote, connection: connection!, onPress: keyPressed,),
    );
  }

  //bluetooth
  connect() {
    Storage.address.then((_address) {
      BluetoothConnection
          .toAddress(_address)
          .then((value) => connection = value)
          .then((value) => value.input.listen((event) { },
          onDone: (){
            if(connection!= null)
            setState(() {});
          },
          onError: (_){
            if(connection!= null)
            setState(() {});
          }))
          .then((_) => setMode())
          .then((_) => setState((){}));
    });
  }

  disconnect() {
    connection?..close()..dispose();
    connection = null;
  }

  setMode()               =>  send(JsonData(0x02, 0x00)); //0x01 read mode //0x00 remote mode

  send(JsonData data)     => connection?.output.add(ascii.encode(json.encode(data.toMap())));

  void keyPressed(IrData irData) {
    // print(irData.toMap());
    send(JsonData(0x03, 0, irData: irData));
    setState(() => counter = 0);
  }

  count(){
    timer = new Timer.periodic(
      const Duration(seconds: 1),
          (timer) => counter >= 60 ?
          Navigator.of(context).pop() :
          print(counter++),
    );
  }

}