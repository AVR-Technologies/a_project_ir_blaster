import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ir_remote/widgets/error_screen.dart';
import 'package:ir_remote/widgets/loading_screen.dart';
import 'device_page.dart';

class DevicesPage extends StatefulWidget{
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(
      title: Text('Devices'),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () => setState(() {}),
          tooltip: 'Refresh devices',
        ),
      ],
    ),
    body: FutureBuilder<List<BluetoothDevice>>(
      builder: (_, snapshot) =>
      snapshot.connectionState == ConnectionState.waiting ? LoadingScreen() :
      !snapshot.hasData ? ErrorScreen(message: 'Error',) :
      snapshot.data.length == 0 ? ErrorScreen(message: 'No device found') :
      ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (_, index) => ListTile(
          hoverColor: Colors.red,
          focusColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              width: 2,
              color: Colors.transparent,
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DevicePage(
                device: snapshot.data[index],
              ),
            ),
          ),
          leading: Icon(
            Icons.bluetooth_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          trailing: Icon(Icons.keyboard_arrow_right_outlined),
          title: Text(
            snapshot.data[index].name,
          ),
          subtitle: Text(
            // FlutterBluetoothSerial.instance.toString()
            snapshot.data[index].type.stringValue,
          ),
        ),
      ),
      future: FlutterBluetoothSerial.instance.getBondedDevices(),
    ),
  );
}
