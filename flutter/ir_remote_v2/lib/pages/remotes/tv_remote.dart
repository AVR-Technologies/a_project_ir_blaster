import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:ir_remote/button_styles.dart';

import '../../extensions.dart';
import '../../key_data.dart';
import '../../main.dart';

class TVRemote extends StatelessWidget{
  final BluetoothConnection connection;
  final Remote remote;
  const TVRemote({Key key, this.connection, this.remote}) : super(key: key);

  @override
  Widget build(context) => ListView(
    children: [
      Row(
        children: [
          RemoteButton.power().elevatedButton(() => keyPressed(remote.keys[0])).paddingAll().expanded(),
          RemoteButton.tv().elevatedButton(() => keyPressed(remote.keys[16])).paddingAll().expanded(),
          RemoteButton.mute().textButton(() => keyPressed(remote.keys[3])).paddingAll().expanded()
        ],
      ).paddingAll(),//power, mute
      Material(
        color: Colors.grey[900],
        shape: CircleBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.up().roundButton(() => keyPressed(remote.keys[18])).sizedBox(Size.square(60))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.left().roundButton(() => keyPressed(remote.keys[20])).sizedBox(Size.square(60)),
                RemoteButton.menu().roundButton(() => keyPressed(remote.keys[17])).sizedBox(Size.square(60)).paddingAll(value: 4),
                RemoteButton.right().roundButton(() => keyPressed(remote.keys[21])).sizedBox(Size.square(60)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.down().roundButton(() => keyPressed(remote.keys[19])).sizedBox(Size.square(60)),
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
                RemoteButton.channelPrevious().textButton(() => keyPressed(remote.keys[5])).expanded(),
                Text('CH'),
                RemoteButton.channelNext().textButton(() => keyPressed(remote.keys[4])).expanded(),
              ],
            ).paddingAll(),
          ).paddingAll().expanded(),
          Material(
            shape: shape,
            child: Row(
              children: [
                RemoteButton.volumeMinus().textButton(() => keyPressed(remote.keys[2])).expanded(),
                Text('VOL'),
                RemoteButton.volumePlus().textButton(() => keyPressed(remote.keys[1])).expanded(),
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
          RemoteButton.one().iconButton(() => keyPressed(remote.keys[7])).center(),
          RemoteButton.two().iconButton(() => keyPressed(remote.keys[8])).center(),
          RemoteButton.three().iconButton(() => keyPressed(remote.keys[9])).center(),

          RemoteButton.four().iconButton(() => keyPressed(remote.keys[10])).center(),
          RemoteButton.five().iconButton(() => keyPressed(remote.keys[11])).center(),
          RemoteButton.six().iconButton(() => keyPressed(remote.keys[12])).center(),

          RemoteButton.seven().iconButton(() => keyPressed(remote.keys[13])).center(),
          RemoteButton.eight().iconButton(() => keyPressed(remote.keys[14])).center(),
          RemoteButton.nine().iconButton(() => keyPressed(remote.keys[15])).center(),

          RemoteButton.back().labelButton(() => keyPressed(remote.keys[23])).center(),
          RemoteButton.zero().iconButton(() => keyPressed(remote.keys[6])).center(),
          RemoteButton.guide().labelButton(() => keyPressed(remote.keys[22])).center(),
        ],
      ).paddingAll(),
    ],
  );

  // Widget numberButton(int index) => Center(
  //   child: IconButton(
  //     icon: Icon(
  //       Remotes.tv[index].icon,
  //       color: Colors.white,
  //     ),
  //     onPressed: ()=> keyPressed(remote.keys[index]),
  //   ),
  // );
  //
  // Widget muteButton()=> Center(
  //   child: IconButton(
  //     icon: Icon(Remotes.tv[3].icon, color: Colors.red[400],),
  //     onPressed: ()=> keyPressed(remote.keys[3]),
  //   ),
  // );

  keyPressed(KeyData key) =>  send(JsonData(0x03, 0, irData: key.irData));

  send(JsonData data) => connection.output.add(ascii.encode(json.encode(data.toMap())));

}