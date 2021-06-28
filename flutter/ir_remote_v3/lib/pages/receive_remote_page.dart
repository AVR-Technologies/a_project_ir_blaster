import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boost/let.dart';
import 'package:ir_remote_v3/remote.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

enum ServerStatus{
  error, //0
  connected, //1 //client found
  disconnected, //2
}
class ReceiveRemotePage extends StatefulWidget{
  //network server and socket
  @override
  _ReceiveRemotePageState createState() => _ReceiveRemotePageState();
}

class _ReceiveRemotePageState extends State<ReceiveRemotePage> {
  ServerSocket? serverSocket;
  Socket? socket;

  StreamSubscription<Socket>? serverStream;
  StreamSubscription<Uint8List>? socketStream;
  var serverStatus = ServerStatus.disconnected;
  var _remotes = <Remote>[];

  @override
  void initState() {
    super.initState();
    createServer();
  }
  @override
  void dispose() {
    closeServer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print(serverStatus);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serverStatus == ServerStatus.connected ? 'connected' :
          serverStatus == ServerStatus.disconnected ? 'waiting for connection':
          'closed',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: serverStatus == ServerStatus.error ? 0 : null,
          ),
          if(_remotes.length > 0) ListTile(
            dense: true,
            leading: SizedBox(width: 40,),
            title: Text('Received remote'),
            selected: true,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Let(
                let: _remotes[index],
                builder: (Remote remote) => ListTileTheme(
                  style: ListTileStyle.list,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      child: Icon(
                        remote.remoteType == RemoteType.ac ? Icons.ac_unit :
                        remote.remoteType == RemoteType.music_player ? Icons.music_note :
                        Icons.tv,),
                    ),
                    title: Text(remote.name),
                  ),
                ),
              ),
              itemCount: _remotes.length,
            ),
          ),
        ],
      ),
    );
  }

  createServer() async{
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    serverStream = serverSocket?.listen((event){
      setState(() => socket = event);
      setState(() => serverStatus = ServerStatus.connected);
      socketStream = socket?.listen((event) {
        try{
          dynamic result = json.decode(ascii.decode(event));
          setState(() => _remotes.add(Remote.fromDynamic(result[0]))); //receiving multiple
          if(_remotes.length > 0) Navigator.pop(context, _remotes);
        }catch(e){
          print('error decoding');
        }
      },
        onDone: (){
          if(socketStream != null) setState(() => serverStatus = ServerStatus.disconnected);
        },
        onError: (_)=> setState(() => serverStatus = ServerStatus.error),
      );
    },
      onDone: (){
        if(serverStream != null) setState(() => serverStatus = ServerStatus.disconnected);
      },
      onError: (_)=> setState(() => serverStatus = ServerStatus.error),
    );
  }
  closeServer(){
    serverStream?.cancel();
    socketStream?.cancel();
    serverSocket?.close();
    socket?.close();

    serverStream = null;
    socketStream = null;
    serverSocket = null;
    socket = null;
    print('server closed');
  }
}