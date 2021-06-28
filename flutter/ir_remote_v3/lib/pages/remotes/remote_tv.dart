import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:ir_remote_v3/widgets/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';
import '../../remote.dart';

class RemoteTv extends StatelessWidget{
  final BluetoothConnection connection;
  final void Function(IrData) onPress;
  final Remote remote;
  const RemoteTv({Key? key, required this.connection, required this.remote, required this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      Row(
        children: [
          RemoteButton.keyPower().textButton(() => onPress(remote.keyPower.irData)).paddingAll().expanded(),
          RemoteButton.keyTv().textButton(() => onPress(remote.keyTv.irData)).paddingAll().expanded(),
          RemoteButton.keyVolMute().textButton(() => onPress(remote.keyVolMute.irData)).paddingAll().expanded()
        ],
      ).paddingAll(),//power, mute
      Material(
        color: Colors.grey[800],
        shape: CircleBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.keySelectUp().roundButton(() => onPress(remote.keySelectUp.irData)).sizedBox(Size.square(60))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.keySelectLeft().roundButton(() => onPress(remote.keySelectLeft.irData)).sizedBox(Size.square(60)),
                RemoteButton.keySelect().roundButton(() => onPress(remote.keySelect.irData)).sizedBox(Size.square(60)).paddingAll(value: 4),
                RemoteButton.keySelectRight().roundButton(() => onPress(remote.keySelectRight.irData)).sizedBox(Size.square(60)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.keySelectDown().roundButton(() => onPress(remote.keySelectDown.irData)).sizedBox(Size.square(60)),
              ],
            ),
          ],
        ),
      ).paddingAll(),
      Row(
        children: [
          Material(
            shape: shape,
            child: Row(
              children: [
                RemoteButton.keyChMinus().textButton(() => onPress(remote.keyChMinus.irData)).expanded(),
                Text('CH'),
                RemoteButton.keyChPlus().textButton(() => onPress(remote.keyChPlus.irData)).expanded(),
              ],
            ).paddingAll(),
          ).paddingAll().expanded(),
          Material(
            shape: shape,
            child: Row(
              children: [
                RemoteButton.keyVolMinus().textButton(() => onPress(remote.keyVolMinus.irData)).expanded(),
                Text('VOL'),
                RemoteButton.keyVolPlus().textButton(() => onPress(remote.keyVolPlus.irData)).expanded(),
              ],
            ).paddingAll(),
          ).paddingAll().expanded(),
        ],
      ),
      LayoutGrid(
        columnSizes: [auto, auto, auto,],
        rowSizes: [auto, auto, auto, auto,],
        rowGap: 28,
        children: [
          RemoteButton.key1().iconButton(() => onPress(remote.key1.irData)).center(),
          RemoteButton.key2().iconButton(() => onPress(remote.key2.irData)).center(),
          RemoteButton.key3().iconButton(() => onPress(remote.key3.irData)).center(),

          RemoteButton.key4().iconButton(() => onPress(remote.key4.irData)).center(),
          RemoteButton.key5().iconButton(() => onPress(remote.key5.irData)).center(),
          RemoteButton.key6().iconButton(() => onPress(remote.key6.irData)).center(),

          RemoteButton.key7().iconButton(() => onPress(remote.key7.irData)).center(),
          RemoteButton.key8().iconButton(() => onPress(remote.key8.irData)).center(),
          RemoteButton.key9().iconButton(() => onPress(remote.key9.irData)).center(),

          RemoteButton.keyBack().labelButton(() => onPress(remote.keyBack.irData)).center(),
          RemoteButton.key0().iconButton(() => onPress(remote.key0.irData)).center(),
          RemoteButton.keyGuide().labelButton(() => onPress(remote.keyGuide.irData)).center(),
        ],
      ).paddingAll(),
    ],
  );
}
