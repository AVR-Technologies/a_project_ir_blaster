import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ir_remote_v3/Storage.dart';
import '../main.dart'; // ignore: import_of_legacy_library_into_null_safe

class PairedDevicesPage extends StatefulWidget{
  @override
  _PairedDevicesPageState createState() => _PairedDevicesPageState();
}

class _PairedDevicesPageState extends State<PairedDevicesPage> {
  //pref
  String? selectedBluetoothAddress;
  //bluetooth
  var instance = FlutterBluetoothSerial.instance;
  var scanning = false;
  var isBluetoothEnable = true;
  var devices = <BluetoothDevice>[];
  StreamSubscription<Future<bool>>? enableSubscription;

  @override
  void initState() {
    super.initState();
    Storage.address.then((value) => setState(() => selectedBluetoothAddress = value));
    checkIfBluetoothEnabled();
    scan();
  }

  @override
  void dispose() {
    super.dispose();
    enableSubscription?.cancel();
  }

  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(
      title: Text('Devices'),
      actions: [
        if (!scanning) IconButton(
          icon: Icon(Icons.refresh),
          onPressed: scan,
        ),
      ],
    ),
    body: ListView(
      children: [
        LinearProgressIndicator(value: scanning ? null : 0,),
        ListTile(
          dense: true,
          leading: SizedBox(width: 40,),
          title: Text('Paired devices',),
          selected: true,
        ),
        ListView.builder(
          itemCount: devices.length,//.where((element) => element.bondState == BluetoothBondState.bonded).toList()
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Let(
            let: devices[index],
            builder: (BluetoothDevice device) => ListTile(
              leading: CircleAvatar(
                backgroundColor: selectedBluetoothAddress == device.address ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                foregroundColor: Colors.white,
                child: Icon( selectedBluetoothAddress == device.address ? Icons.check : Icons.bluetooth),
              ),
              onTap: ()=> setState(() {
                selectedBluetoothAddress = device.address;
                Storage.address = selectedBluetoothAddress;
                Navigator.of(context).pop();
              }),
              selected: selectedBluetoothAddress == device.address,
              selectedTileColor: primaryColor.withOpacity(0.2),
              // subtitle: device.isBonded ? Text('paired') : null,
              title: Text(device.name ?? ''),
            ),
          ),
        ),
        Divider(indent: 0, endIndent: 0, color: Colors.white38),
        ListTile(
          dense: true,
          leading: Icon(Icons.info_outlined),
          title: Text(
            !isBluetoothEnable ?
            'Bluetooth is off':
            scanning ?
            'Scanning' :
            devices.length > 0 ?
            'Tap device to select' :
            'Scan for devices',
            style: Theme.of(context).textTheme.caption,),
        ), //message
      ],
    ),
  );

  //bluetooth
  checkIfBluetoothEnabled() {
    enableSubscription = Stream
        .periodic(Duration(seconds: 1), (_) async => await instance.isEnabled)
        .listen((event) => event
        .then((enabled) => setState(() => enabled ? isBluetoothEnable = true : stopScan(),),),
      onDone: () => stopScan(),
      onError: (_)=> stopScan(),
    );
  }

  scan() {
    if(isBluetoothEnable){
      setState(() {
        scanning = true;
        devices.clear();
      });
      FlutterBluetoothSerial
          .instance
          .getBondedDevices()
          .then((value) => setState(() {
            devices = value;
            scanning = false;
          }),
          onError: (_)=> setState(() => scanning = false),
      );
    }
  }

  stopScan()=> setState(() {
    scanning = false;
    isBluetoothEnable = false;
  },);
}