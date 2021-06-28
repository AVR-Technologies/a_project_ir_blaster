import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ir_remote_v3/Storage.dart';
import '../main.dart'; // ignore: import_of_legacy_library_into_null_safe

class DevicesPage extends StatefulWidget{
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  //pref
  String? selectedBluetoothAddress;
  //bluetooth
  var instance = FlutterBluetoothSerial.instance;
  var scanning = false;
  var isBluetoothEnable = true;
  var devices = <BluetoothDevice>[];
  StreamSubscription<BluetoothDiscoveryResult>? devicesSubscription;
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
    devicesSubscription?.cancel();
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
          title: Text('Available devices',),
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
              onTap: ()=> device.isBonded ?
              setState(() {
                selectedBluetoothAddress = device.address;
                Storage.address = selectedBluetoothAddress;
              }) :
              instance
                  .bondDeviceAtAddress(device.address)
                  .then(
                    (success) => success ?
                    setState(() => device =
                        BluetoothDevice(
                          name: device.name,
                          address: device.address,
                          type: device.type,
                          bondState: BluetoothBondState.bonded,
                        ),
                    ) :
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('bonding failed'))),
              ),
              selected: selectedBluetoothAddress == device.address,
              selectedTileColor: primaryColor.withOpacity(0.2),
              subtitle: device.isBonded ? Text('paired') : null,
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
      // instance.requestDiscoverable(200);
      devicesSubscription = instance
          .startDiscovery()
          .listen(
            (device) => setState(() => devices.add(device.device)),
        onDone: ()=> setState(() => scanning = false,),
        onError:  (_)=> setState(() => scanning = false,),
      );
    }
  }

  stopScan()=> setState(() {
    scanning = false;
    isBluetoothEnable = false;
    devicesSubscription?.cancel();
    },);
  //prefs
  // Future<void> scanPrefs() => _prefs.then((prefs) => !prefs.containsKey('address') ? saveAddress() : readAddress());
  //
  // /*Future<void> saveToPref() => _prefs
  //     .then((prefs) => prefs.setString('address', selectedBluetoothAddress!))
  //     .then((success) => ScaffoldMessenger
  //     .of(context)
  //     .showSnackBar(SnackBar(content: Text(success ? 'Saved' : 'Error saving'),),),)
  //     .then((_) => setState((){}));*/
  //
  // Future<void> saveAddress() => _prefs
  //     .then((prefs) => prefs.setString("address", selectedBluetoothAddress!))
  //     .then((success) => setState(() {print(success ? 'address saved' : 'address not saved');}));
  //
  // Future<void> readAddress() => _prefs
  //     .then((prefs) => selectedBluetoothAddress = prefs.getString('address'))
  //     .then((_) => setState(() {}));
}