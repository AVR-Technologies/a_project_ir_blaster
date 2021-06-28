import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_boost/let.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ping_discover_network/ping_discover_network.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:wifi/wifi.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';
import '../remote.dart';

enum SocketStatus{
  error,
  scanning,
  device_not_found,
  scanned,
  connecting,
  connected,
  disconnected,
  sending,
  sent,
}

class SendRemotePage extends StatefulWidget{
  final List<Remote> remotes;
  const SendRemotePage({Key? key, required this.remotes}) : super(key: key);

  @override
  _SendRemotePageState createState() => _SendRemotePageState();
}

class _SendRemotePageState extends State<SendRemotePage> {
  Socket? socket;
  StreamSubscription<Uint8List>? socketStream;
  StreamSubscription<NetworkAddress>? scanDevicesStream;
  var networkDevices = <String>[];
  var socketStatus = SocketStatus.disconnected;
  @override initState(){
    super.initState();
    scanNetwork();
  }
  @override
  void dispose() {
    closeSocket();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          socketStatus == SocketStatus.error ? 'Error' :
          socketStatus == SocketStatus.scanning ? 'Scanning':
          socketStatus == SocketStatus.device_not_found ? 'Device not found':
          socketStatus == SocketStatus.scanned ? 'Scan complete':
          socketStatus == SocketStatus.connecting ? 'Connecting':
          socketStatus == SocketStatus.connected ? 'Connected':
          socketStatus == SocketStatus.sending ? 'Sending':
          socketStatus == SocketStatus.sent ? 'Sent':
          'Closed', //5
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value:
            socketStatus == SocketStatus.scanning ? null :
            socketStatus == SocketStatus.scanned ? null :
            socketStatus == SocketStatus.connecting ? null :
            socketStatus == SocketStatus.connected ? null :
            socketStatus == SocketStatus.sending ? null :
            socketStatus == SocketStatus.scanned ? null :
            0,
          ),
          ListTile(
            selected: true,
            title: Text('sending remote'),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.remotes.length,
              itemBuilder: (BuildContext context, int index) => Let(
                let: widget.remotes[index],
                builder: (Remote remote) => ListTileTheme(
                  style: ListTileStyle.list,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      child: Icon(
                        remote.remoteType == RemoteType.ac ? Icons.ac_unit :
                        remote.remoteType == RemoteType.music_player ? Icons.music_note :
                        Icons.tv,
                      ),
                    ),
                    title: Text(remote.name),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //network
  scanNetwork() {
    Wifi.ip.then((ip){
      String subnet = ip.substring(0, ip.lastIndexOf('.'));
      setState(() => networkDevices.clear());
      scanDevicesStream = NetworkAnalyzer.discover2(subnet, port).listen((NetworkAddress address) => setState(() {
        socketStatus = SocketStatus.scanning;
        address.exists ? networkDevices.add(address.ip) : print('.');
      }),
        onDone: (){
        if(scanDevicesStream != null){
          if(networkDevices.length > 0) {
            setState(() => socketStatus = SocketStatus.connecting);
            connectSocket(networkDevices[0]);
          } else {
            setState(() => socketStatus = SocketStatus.device_not_found);
          }
        }
        },
        onError: (_) => setState(() => socketStatus = SocketStatus.error),
      );
    });
  }
  connectSocket(String host) async {
    socket = await Socket.connect(host, port);
    setState(() => socketStatus = SocketStatus.connected);
    socketStream = socket?.listen((event) => print(ascii.decode(event)),
      onDone: () {
        if(socketStream != null){
          // setState(() => socketStatus = SocketStatus.disconnected);
          Navigator.pop(context, true);
        }
      },
      onError: (_) => setState(() => socketStatus = SocketStatus.error),
    );
    setState(() => socketStatus = SocketStatus.sending);
    socket?.write(json.encode(widget.remotes.map((e) => e.toMap()).toList()));//sending multiple
    setState(() => socketStatus = SocketStatus.sent);
  }
  closeSocket(){
    scanDevicesStream?.cancel();
    socketStream?.cancel();
    socket?.close();
    scanDevicesStream = null;
    socketStream = null;
    socket = null;
  }
}