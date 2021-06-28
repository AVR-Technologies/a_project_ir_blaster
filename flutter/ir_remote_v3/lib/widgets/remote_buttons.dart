import 'package:flutter/material.dart';

import '../remote.dart';
import '../text_icons.dart';

typedef Callback = void Function();
class RemoteButtonStyle{
  final Color backgroundColor;
  final Color foregroundColor;
  // RemoteButtons(this.backgroundColor, this.foregroundColor, this.icon, this.label);
  RemoteButtonStyle._(this.backgroundColor, this.foregroundColor);

  ButtonStyle elevatedStyle() =>
      ElevatedButton.styleFrom(primary: backgroundColor, onPrimary: foregroundColor);
  ButtonStyle flatStyle() =>
      TextButton.styleFrom(backgroundColor: backgroundColor, primary: foregroundColor);

  RemoteButtonStyle.style1() : this._(Colors.red[300]!,   Colors.grey[900]!);//power
  RemoteButtonStyle.style2() : this._(Colors.grey[900]!,  Colors.red[300]!);//mute
  RemoteButtonStyle.style3() : this._(Colors.grey[900]!,  Colors.blue[300]!);//tv/mode//skip-next//skip-previous
  RemoteButtonStyle.style4() : this._(Colors.blue[300]!,  Colors.grey[900]!);//play/select
  RemoteButtonStyle.style5() : this._(Colors.transparent, Colors.blue[300]!);//arrows // left/right/up/down
  RemoteButtonStyle.style6() : this._(Colors.transparent, Colors.white); //number//other normal

  static Map<KeyType, RemoteButtonStyle> map = {
    KeyType.keyPower       : RemoteButtonStyle.style1(),
    KeyType.keyVolMute     : RemoteButtonStyle.style2(),
    KeyType.keyTv          : RemoteButtonStyle.style3(),
    KeyType.keyPlay           : RemoteButtonStyle.style4(),
    KeyType.keySkipNext       : RemoteButtonStyle.style3(),
    KeyType.keySkipPrevious   : RemoteButtonStyle.style3(),
    KeyType.keySelect      : RemoteButtonStyle.style4(),
    KeyType.keySelectLeft  : RemoteButtonStyle.style5(),
    KeyType.keySelectRight : RemoteButtonStyle.style5(),
    KeyType.keySelectUp    : RemoteButtonStyle.style5(),
    KeyType.keySelectDown  : RemoteButtonStyle.style5(),
    KeyType.keyVolPlus     : RemoteButtonStyle.style6(),
    KeyType.keyVolMinus    : RemoteButtonStyle.style6(),
    KeyType.keyChMinus     : RemoteButtonStyle.style6(),
    KeyType.keyChPlus      : RemoteButtonStyle.style6(),
    KeyType.key0           : RemoteButtonStyle.style6(),
    KeyType.key1           : RemoteButtonStyle.style6(),
    KeyType.key2           : RemoteButtonStyle.style6(),
    KeyType.key3           : RemoteButtonStyle.style6(),
    KeyType.key4           : RemoteButtonStyle.style6(),
    KeyType.key5           : RemoteButtonStyle.style6(),
    KeyType.key6           : RemoteButtonStyle.style6(),
    KeyType.key7           : RemoteButtonStyle.style6(),
    KeyType.key8           : RemoteButtonStyle.style6(),
    KeyType.key9           : RemoteButtonStyle.style6(),
    KeyType.keyGuide       : RemoteButtonStyle.style6(),
    KeyType.keyBack        : RemoteButtonStyle.style6(),
  };
  static List<RemoteButtonStyle> all()=> map.values.toList();
}
/*class RemoteButton{
  final RemoteButtonStyle style;
  final IconData icon;
  final String label;
  RemoteButton._(this.style, this.icon, this.label);

  ElevatedButton elevatedButton(Callback onPressed) => ElevatedButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: style.elevatedStyle(),
  );
  Widget elevatedButtonWithLabel(Callback onPressed) => ElevatedButton.icon(
    icon: Icon(icon),
    label: Text(label),
    onPressed: onPressed,
    style: style.elevatedStyle(),
  );
  Widget textButton(Callback onPressed) => TextButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: style.flatStyle(),
  );
  Widget textButtonWithLabel(Callback onPressed) => TextButton.icon(
    icon: Icon(icon),
    label: Text(label),
    onPressed: onPressed,
    style: style.flatStyle(),
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
    style: style.flatStyle(),
  );

  Widget labelButton(Callback onPressed) => TextButton(
    child: Text(label),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: style.backgroundColor,
      primary: style.foregroundColor,
      shape: CircleBorder(),
    ),
  );
  Widget roundButton(Callback onPressed) => TextButton(
    child: Icon(icon),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: style.backgroundColor,
      primary: style.foregroundColor,
      shape: CircleBorder(),
    ),
  );

  Widget iconButton(Callback onPressed) => IconButton(
    icon: Icon(icon),
    onPressed: onPressed,
    color: style.foregroundColor,
  );

  RemoteButton.keyPower()       : this._(RemoteButtonStyle.style1(), Icons.power_settings_new_rounded, 'Power',);
  RemoteButton.keyVolMute()     : this._(RemoteButtonStyle.style2(), Icons.volume_off_rounded, 'Mute',);
  RemoteButton.keyTv()          : this._(RemoteButtonStyle.style3(), Icons.tv, 'TV',);

  RemoteButton.play()           : this._(RemoteButtonStyle.style4(), Icons.play_arrow_rounded, 'Play',);
  RemoteButton.skipNext()       : this._(RemoteButtonStyle.style3(), Icons.skip_next_rounded, 'Skip next',);
  RemoteButton.skipPrevious()   : this._(RemoteButtonStyle.style3(), Icons.skip_previous_rounded, 'Skip previous',);

  RemoteButton.keySelect()      : this._(RemoteButtonStyle.style4(), Icons.menu, 'menu',);
  RemoteButton.keySelectLeft()  : this._(RemoteButtonStyle.style5(), Icons.keyboard_arrow_left_rounded, 'left',);
  RemoteButton.keySelectRight() : this._(RemoteButtonStyle.style5(), Icons.keyboard_arrow_right_rounded, 'right',);
  RemoteButton.keySelectUp()    : this._(RemoteButtonStyle.style5(), Icons.keyboard_arrow_up_rounded, 'up',);
  RemoteButton.keySelectDown()  : this._(RemoteButtonStyle.style5(), Icons.keyboard_arrow_down_rounded, 'down',);

  RemoteButton.keyVolPlus()     : this._(RemoteButtonStyle.style6(), Icons.add_rounded, 'VOL',);
  RemoteButton.keyVolMinus()    : this._(RemoteButtonStyle.style6(), Icons.remove_rounded, 'VOL',);
  RemoteButton.keyChMinus()     : this._(RemoteButtonStyle.style6(), Icons.keyboard_arrow_left_rounded, 'CH',);
  RemoteButton.keyChPlus()      : this._(RemoteButtonStyle.style6(), Icons.keyboard_arrow_right_rounded, 'CH',);

  RemoteButton.key0()           : this._(RemoteButtonStyle.style6(), TextIcons.num_0, 'zero',);
  RemoteButton.key1()           : this._(RemoteButtonStyle.style6(), TextIcons.num_1, 'one',);
  RemoteButton.key2()           : this._(RemoteButtonStyle.style6(), TextIcons.num_2, 'two',);
  RemoteButton.key3()           : this._(RemoteButtonStyle.style6(), TextIcons.num_3, 'three',);
  RemoteButton.key4()           : this._(RemoteButtonStyle.style6(), TextIcons.num_4, 'four',);
  RemoteButton.key5()           : this._(RemoteButtonStyle.style6(), TextIcons.num_5, 'five',);
  RemoteButton.key6()           : this._(RemoteButtonStyle.style6(), TextIcons.num_6, 'six',);
  RemoteButton.key7()           : this._(RemoteButtonStyle.style6(), TextIcons.num_7, 'seven',);
  RemoteButton.key8()           : this._(RemoteButtonStyle.style6(), TextIcons.num_8, 'eight',);
  RemoteButton.key9()           : this._(RemoteButtonStyle.style6(), TextIcons.num_9, 'nine',);

  RemoteButton.keyGuide()       : this._(RemoteButtonStyle.style6(), Icons.menu, 'guide',);
  RemoteButton.keyBack()        : this._(RemoteButtonStyle.style6(), Icons.keyboard_return, 'back',);
}*/
class RemoteButton{
  KeyType key;
  RemoteButton._(this.key);

  ElevatedButton elevatedButton(Callback onPressed) => ElevatedButton(
    child: Icon(RemoteButtonIcon.map[key]),
    onPressed: onPressed,
    style: RemoteButtonStyle.map[key]!.elevatedStyle(),
  );
  Widget elevatedButtonWithLabel(Callback onPressed) => ElevatedButton.icon(
    icon: Icon(RemoteButtonIcon.map[key]),
    label: Text(RemoteButtonLabel.map[key]!),
    onPressed: onPressed,
    style: RemoteButtonStyle.map[key]!.elevatedStyle(),
  );
  Widget textButton(Callback onPressed) => TextButton(
    child: Icon(RemoteButtonIcon.map[key]),
    onPressed: onPressed,
    style: RemoteButtonStyle.map[key]!.flatStyle(),
  );
  Widget textButtonWithLabel(Callback onPressed) => TextButton.icon(
    icon: Icon(RemoteButtonIcon.map[key]),
    label: Text(RemoteButtonLabel.map[key]!),
    onPressed: onPressed,
    style: RemoteButtonStyle.map[key]!.flatStyle(),
  );
  Widget textButtonEndIcon(Callback onPressed) => TextButton(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(RemoteButtonLabel.map[key]!),
        Icon(RemoteButtonIcon.map[key]),
      ],
    ),
    onPressed: onPressed,
    style: RemoteButtonStyle.map[key]!.flatStyle(),
  );
  Widget labelButton(Callback onPressed) => TextButton(
    child: Text(RemoteButtonLabel.map[key]!),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: RemoteButtonStyle.map[key]!.backgroundColor,
      primary: RemoteButtonStyle.map[key]!.foregroundColor,
      shape: CircleBorder(),
    ),
  );
  Widget roundButton(Callback onPressed) => TextButton(
    child: Icon(RemoteButtonIcon.map[key]!),
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: RemoteButtonStyle.map[key]!.backgroundColor,
      primary: RemoteButtonStyle.map[key]!.foregroundColor,
      shape: CircleBorder(),
    ),
  );
  Widget iconButton(Callback onPressed) => IconButton(
    icon: Icon(RemoteButtonIcon.map[key]!),
    onPressed: onPressed,
    color: RemoteButtonStyle.map[key]!.foregroundColor,
  );

  RemoteButton.keyPower()       : this._(KeyType.keyPower);
  RemoteButton.keyVolMute()     : this._(KeyType.keyVolMute);
  RemoteButton.keyTv()          : this._(KeyType.keyTv);
  RemoteButton.play()           : this._(KeyType.keyPlay);
  RemoteButton.skipNext()       : this._(KeyType.keySkipNext);
  RemoteButton.skipPrevious()   : this._(KeyType.keySkipPrevious);
  RemoteButton.keySelect()      : this._(KeyType.keySelect);
  RemoteButton.keySelectLeft()  : this._(KeyType.keySelectLeft);
  RemoteButton.keySelectRight() : this._(KeyType.keySelectRight);
  RemoteButton.keySelectUp()    : this._(KeyType.keySelectUp);
  RemoteButton.keySelectDown()  : this._(KeyType.keySelectDown);
  RemoteButton.keyVolPlus()     : this._(KeyType.keyVolPlus);
  RemoteButton.keyVolMinus()    : this._(KeyType.keyVolMinus);
  RemoteButton.keyChMinus()     : this._(KeyType.keyChMinus);
  RemoteButton.keyChPlus()      : this._(KeyType.keyChPlus);
  RemoteButton.key0()           : this._(KeyType.key0);
  RemoteButton.key1()           : this._(KeyType.key1);
  RemoteButton.key2()           : this._(KeyType.key2);
  RemoteButton.key3()           : this._(KeyType.key3);
  RemoteButton.key4()           : this._(KeyType.key4);
  RemoteButton.key5()           : this._(KeyType.key5);
  RemoteButton.key6()           : this._(KeyType.key6);
  RemoteButton.key7()           : this._(KeyType.key7);
  RemoteButton.key8()           : this._(KeyType.key8);
  RemoteButton.key9()           : this._(KeyType.key9);
  RemoteButton.keyGuide()       : this._(KeyType.keyGuide);
  RemoteButton.keyBack()        : this._(KeyType.keyBack);

  // Map map = {
  //   KeyType.keyPower : RemoteButton.keyPower(),
  //   KeyType.keyVolMute : RemoteButton.keyVolMute(),
  //   KeyType.keyTv : RemoteButton.keyTv(),
  //   KeyType.keyPlay : RemoteButton.play(),
  //   KeyType.keySkipNext : RemoteButton.skipNext(),
  //   KeyType.keySkipPrevious : RemoteButton.skipPrevious(),
  //   KeyType.keySelect : RemoteButton.keySelect(),
  //   KeyType.keySelectLeft : RemoteButton.keySelectLeft(),
  //   KeyType.keySelectRight : RemoteButton.keySelectRight(),
  //   KeyType.keySelectUp : RemoteButton.keySelectUp(),
  //   KeyType.keySelectDown : RemoteButton.keySelectDown(),
  //   KeyType.keyVolPlus : RemoteButton.keyVolPlus(),
  //   KeyType.keyVolMinus : RemoteButton.keyVolMinus(),
  //   KeyType.keyChMinus : RemoteButton.keyChMinus(),
  //   KeyType.keyChPlus : RemoteButton.keyChPlus(),
  //   KeyType.key0 : RemoteButton.key0(),
  //   KeyType.key1 : RemoteButton.key1(),
  //   KeyType.key2 : RemoteButton.key2(),
  //   KeyType.key3 : RemoteButton.key3(),
  //   KeyType.key4 : RemoteButton.key4(),
  //   KeyType.key5 : RemoteButton.key5(),
  //   KeyType.key6 : RemoteButton.key6(),
  //   KeyType.key7 : RemoteButton.key7(),
  //   KeyType.key8 : RemoteButton.key8(),
  //   KeyType.key9 : RemoteButton.key9(),
  //   KeyType.keyGuide : RemoteButton.keyGuide(),
  //   KeyType.keyBack : RemoteButton.keyBack(),
  // };
}
class RemoteButtonIcon{
  static Map<KeyType, IconData> map = {
    KeyType.key0           : TextIcons.num_0,
    KeyType.key1           : TextIcons.num_1,
    KeyType.key2           : TextIcons.num_2,
    KeyType.key3           : TextIcons.num_3,
    KeyType.key4           : TextIcons.num_4,
    KeyType.key5           : TextIcons.num_5,
    KeyType.key6           : TextIcons.num_6,
    KeyType.key7           : TextIcons.num_7,
    KeyType.key8           : TextIcons.num_8,
    KeyType.key9           : TextIcons.num_9,
    KeyType.keyVolPlus     : Icons.add_rounded,
    KeyType.keyVolMinus    : Icons.remove_rounded,
    KeyType.keyChMinus     : Icons.keyboard_arrow_left_rounded,
    KeyType.keyChPlus      : Icons.keyboard_arrow_right_rounded,
    KeyType.keySelect      : Icons.menu,
    KeyType.keySelectLeft  : Icons.keyboard_arrow_left_rounded,
    KeyType.keySelectRight : Icons.keyboard_arrow_right_rounded,
    KeyType.keySelectUp    : Icons.keyboard_arrow_up_rounded,
    KeyType.keySelectDown  : Icons.keyboard_arrow_down_rounded,
    KeyType.keyPower       : Icons.power_settings_new_rounded,
    KeyType.keyTv          : Icons.tv,
    KeyType.keyVolMute     : Icons.volume_off_rounded,
    KeyType.keyBack        : Icons.keyboard_return,
    KeyType.keyGuide       : Icons.menu,
    KeyType.keyPlay           : Icons.play_arrow_rounded,
    KeyType.keySkipNext       : Icons.skip_next_rounded,
    KeyType.keySkipPrevious   : Icons.skip_previous_rounded,
  };
  static List<IconData> all()=> map.values.toList();
}
class RemoteButtonLabel{
  static Map<KeyType, String> map = {
    KeyType.key0           : 'zero',
    KeyType.key1           : 'one',
    KeyType.key2           : 'two',
    KeyType.key3           : 'three',
    KeyType.key4           : 'four',
    KeyType.key5           : 'five',
    KeyType.key6           : 'six',
    KeyType.key7           : 'seven',
    KeyType.key8           : 'eight',
    KeyType.key9           : 'nine',
    KeyType.keyVolPlus     : 'VOL +',
    KeyType.keyVolMinus    : 'VOL -',
    KeyType.keyChMinus     : 'CH +',
    KeyType.keyChPlus      : 'CH -',
    KeyType.keySelect      : 'menu',
    KeyType.keySelectLeft  : 'left',
    KeyType.keySelectRight : 'right',
    KeyType.keySelectUp    : 'up',
    KeyType.keySelectDown  : 'down',
    KeyType.keyPower       : 'Power',
    KeyType.keyTv          : 'TV',
    KeyType.keyVolMute     : 'Mute',
    KeyType.keyBack        : 'back',
    KeyType.keyGuide       : 'guide',
    KeyType.keyPlay           : 'Play',
    KeyType.keySkipNext       : 'Skip next',
    KeyType.keySkipPrevious   : 'Skip previous',
  };
  static List<String> all()=> map.values.toList();
}