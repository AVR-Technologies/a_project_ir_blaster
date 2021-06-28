import 'package:flutter/material.dart';
import 'package:ir_remote_v3/widgets/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';

class RemoteMusicPlayer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            RemoteButton.keyPower().textButtonWithLabel(() { }).sizedBox(Size.square(60)).paddingAll().expanded(),
            RemoteButton.keyVolMute().textButtonWithLabel(() { }).sizedBox(Size.square(60)).paddingAll().expanded(),
          ],
        ),

        Material(
          color: Colors.grey[800],
          shape: CircleBorder(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RemoteButton.keySelectUp().roundButton(() { }).sizedBox(Size.square(60))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RemoteButton.keySelectLeft().roundButton(() { }).sizedBox(Size.square(60)),
                  RemoteButton.keySelect().roundButton(() { }).sizedBox(Size.square(60)).paddingAll(value: 4),
                  RemoteButton.keySelectRight().roundButton(() { }).sizedBox(Size.square(60)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RemoteButton.keySelectDown().roundButton(() { }).sizedBox(Size.square(60)),
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
                  RemoteButton.keyChMinus().textButton(() {}).expanded(),
                  Text('CH'),
                  RemoteButton.keyChPlus().textButton(() {}).expanded(),
                ],
              ).paddingAll(),
            ).paddingAll().expanded(),
            Material(
              shape: shape,
              child: Row(
                children: [
                  RemoteButton.keyVolMinus().textButton(() {}).expanded(),
                  Text('VOL'),
                  RemoteButton.keyVolPlus().textButton(() {}).expanded(),
                ],
              ).paddingAll(),
            ).paddingAll().expanded(),
          ],
        ),
      ],
    );
  }

}