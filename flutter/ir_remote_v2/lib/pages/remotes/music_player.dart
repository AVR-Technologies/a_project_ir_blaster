import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:ir_remote/button_styles.dart';
import 'package:ir_remote/widgets/round_button.dart';
import '../../extensions.dart';
import '../../key_data.dart';
import '../../main.dart';
import 'remotes.dart';

class MusicPlayerRemote extends StatelessWidget{
  final BluetoothConnection connection;
  final Remote remote;

  const MusicPlayerRemote({Key key, this.connection, this.remote}) : super(key: key);

  @override
  Widget build(context) => Column(
    children: [
      Row(
        children: [
          RemoteButton.power().textButtonWithLabel(() { }).sizedBox(Size.square(60)).paddingAll().expanded(),
          RemoteButton.mute().textButtonWithLabel(() { }).sizedBox(Size.square(60)).paddingAll().expanded(),
        ],
      ),

      Material(
        color: Colors.grey[900],
        shape: CircleBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.up().roundButton(() { }).sizedBox(Size.square(60))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.left().roundButton(() { }).sizedBox(Size.square(60)),
                RemoteButton.menu().roundButton(() { }).sizedBox(Size.square(60)).paddingAll(value: 4),
                RemoteButton.right().roundButton(() { }).sizedBox(Size.square(60)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton.down().roundButton(() { }).sizedBox(Size.square(60)),
              ],
            ),
          ],
        ),
      ).paddingAll(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            shape: shape,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RemoteButton.channelPrevious().textButton(() { }),
                Text('CH'),
                RemoteButton.channelNext().textButton(() { }),
              ],
            ).paddingAll(),
          ).paddingAll().expanded(),
          Material(
            shape: shape,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RemoteButton.volumeMinus().textButton(() { }),
                Text('VOL'),
                RemoteButton.volumePlus().textButton(() { }),
              ],
            ).paddingAll(),
          ).paddingAll().expanded(),
        ],
      ),
    ],
  );

  keyPressed(KeyData key) =>  send(JsonData(0x03, 0, irData: key.irData));

  send(JsonData data) => connection.output.add(ascii.encode(json.encode(data.toMap())));
}