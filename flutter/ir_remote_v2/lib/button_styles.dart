import 'package:flutter/material.dart';
import 'package:ir_remote/text_icons.dart';

typedef Callback = void Function();

class RemoteButton {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final Size size;
  final String label;

  RemoteButton._(
      this.backgroundColor,
      this.foregroundColor,
      this.icon,
      this.label,
      this.size,
      );

  // RemoteButton(this.backgroundColor, this.foregroundColor, this.icon, this.label, this.size,);

  Widget elevatedButton(Callback onPressed) => ElevatedButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: backgroundColor,
      onPrimary: foregroundColor,
      minimumSize: size,
    ),
  );

  Widget elevatedButtonWithLabel(Callback onPressed) => ElevatedButton.icon(
    icon: Icon(icon),
    label: Text(label),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: backgroundColor,
      onPrimary: foregroundColor,
      minimumSize: size,
    ),
  );

  Widget textButton(Callback onPressed) => TextButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      primary: foregroundColor,
      minimumSize: size,
    ),
  );

  Widget textButtonWithLabel(Callback onPressed) => TextButton.icon(
    icon: Icon(icon),
    label: Text(label),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      primary: foregroundColor,
      minimumSize: size,
    ),
  );

  Widget textButtonEndIcon(Callback onPressed) => TextButton(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Icon(icon),
      ],
    ),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      primary: foregroundColor,
      minimumSize: size,
    ),
  );

  Widget labelButton(Callback onPressed) => TextButton(
    child: Text(label),
    onPressed: onPressed,
    style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        primary: foregroundColor,
        shape: CircleBorder(),
        minimumSize: size,
        padding: EdgeInsets.all(0)),
  );

  Widget roundButton(Callback onPressed) => TextButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      primary: foregroundColor,
      minimumSize: size,
      shape: CircleBorder(),
    ),
  );

  Widget iconButton(Callback onPressed) => IconButton(
    icon: Icon(icon),
    onPressed: onPressed,
    color: foregroundColor,
  );

  RemoteButton.power() : this._(
    Colors.red[300],
    Colors.grey[900],
    Icons.power_settings_new_rounded,
    'Power',
    Size.fromHeight(50),
  );

  RemoteButton.mute() : this._(
    Colors.grey[900],
    Colors.red[300],
    Icons.volume_off_rounded,
    'Mute',
    Size.fromHeight(50),
  );

  RemoteButton.tv() : this._(
    Colors.grey[900],
    Colors.blue[300],
    Icons.tv,
    'TV',
    Size.fromHeight(50),
  );

  RemoteButton.play() : this._(
    Colors.blue[300],
    Colors.grey[900],
    Icons.play_arrow_rounded,
    'Play',
    Size.fromHeight(50),
  );

  RemoteButton.skipNext() : this._(
    Colors.grey[900],
    Colors.blue[300],
    Icons.skip_next_rounded,
    'Skip next',
    Size.fromHeight(50),
  );

  RemoteButton.skipPrevious() : this._(
    Colors.grey[900],
    Colors.blue[300],
    Icons.skip_previous_rounded,
    'Skip previous',
    Size.fromHeight(50),
  );

  RemoteButton.volumePlus() : this._(
    Colors.transparent,
    Colors.white,
    Icons.add_rounded,
    'VOL',
    Size.fromHeight(50),
  );

  RemoteButton.volumeMinus() : this._(
    Colors.transparent,
    Colors.white,
    Icons.remove_rounded,
    'VOL',
    Size.fromHeight(50),
  );

  RemoteButton.channelPrevious() : this._(
    Colors.transparent,
    Colors.white,
    Icons.keyboard_arrow_left_rounded,
    'CH',
    Size.fromHeight(50),
  );

  RemoteButton.channelNext() : this._(
    Colors.transparent,
    Colors.white,
    Icons.keyboard_arrow_right_rounded,
    'CH',
    Size.fromHeight(50),
  );

  RemoteButton.zero() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_0,
    'zero',
    Size.fromHeight(80),
  );

  RemoteButton.one() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_1,
    'one',
    Size.fromHeight(80),
  );

  RemoteButton.two() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_2,
    'two',
    Size.fromHeight(80),
  );

  RemoteButton.three() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_3,
    'three',
    Size.fromHeight(80),
  );

  RemoteButton.four() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_4,
    'four',
    Size.fromHeight(80),
  );

  RemoteButton.five() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_5,
    'five',
    Size.fromHeight(80),
  );

  RemoteButton.six() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_6,
    'six',
    Size.fromHeight(80),
  );

  RemoteButton.seven() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_7,
    'seven',
    Size.fromHeight(80),
  );

  RemoteButton.eight() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_8,
    'eight',
    Size.fromHeight(80),
  );

  RemoteButton.nine() : this._(
    Colors.transparent,
    Colors.white,
    TextIcons.num_9,
    'nine',
    Size.fromHeight(80),
  );

  RemoteButton.menu() : this._(
    Colors.blue[300],
    Colors.grey[900],
    Icons.menu,
    'menu',
    Size.fromHeight(80),
  );

  RemoteButton.left() : this._(
    Colors.transparent,
    Colors.blue[300],
    Icons.keyboard_arrow_left_rounded,
    'left',
    Size.fromHeight(80),
  );

  RemoteButton.right() : this._(
    Colors.transparent,
    Colors.blue[300],
    Icons.keyboard_arrow_right_rounded,
    'right',
    Size.fromHeight(80),
  );

  RemoteButton.up() : this._(
    Colors.transparent,
    Colors.blue[300],
    Icons.keyboard_arrow_up_rounded,
    'up',
    Size.fromHeight(80),
  );

  RemoteButton.down() : this._(
    Colors.transparent,
    Colors.blue[300],
    Icons.keyboard_arrow_down_rounded,
    'down',
    Size.fromHeight(80),
  );

  RemoteButton.guide() : this._(
    Colors.transparent,
    Colors.white,
    Icons.menu,
    'guide',
    Size.fromHeight(70),
  );
  RemoteButton.back() : this._(
    Colors.transparent,
    Colors.white,
    // Icons.arrow_back,
    Icons.keyboard_return,
    'back',
    Size.fromHeight(70),
  );
}
