import 'package:flutter/material.dart';
import 'text_icons.dart';

// json keys
const read_mode   =  0x01; // to json
const change_mode =  0x02; // to json
const write_ir    =  0x03; // to json
const send_mode   =  0x11; // from json
const new_ir_key  =  0x12; // from json

class IRData{
  final int address;
  final int command;
  final int numberOfBits;
  final int protocol;
  final int rawData;

  const IRData(this.address, this.command, this.numberOfBits, this.protocol, this.rawData);

  const IRData.empty() : this(0,0,0,0,0);

  IRData.fromList(List<int> list) : this(list[0], list[1], list[2], list[3], list[4]);

  List<int> toList() => <int>[address, command, numberOfBits, protocol, rawData];
}
class KeyData{
  IRData _irData;
  final IconData icon;
  final String hintText;
  final TextEditingController controller = TextEditingController(text: '0');

  KeyData(this.icon, this._irData, {this.hintText});

  IRData get irData => _irData ?? IRData.empty();

  set irData(IRData data){
    _irData = data;
    controller.text = _irData.rawData.toRadixString(16);
  }
}
class Remote{
  final TextEditingController controller = TextEditingController(text: 'Remote');

  final List<KeyData> keys = [
    KeyData(Icons.power_settings_new,           IRData.empty(), hintText: 'Power'),
    KeyData(Icons.add,                          IRData.empty(), hintText: 'Volume +'),
    KeyData(Icons.remove,                       IRData.empty(), hintText: 'Volume -'),
    KeyData(Icons.volume_off,                   IRData.empty(), hintText: 'Volume mute'),
    KeyData(Icons.keyboard_arrow_up_rounded,    IRData.empty(), hintText: 'Channel next'),
    KeyData(Icons.keyboard_arrow_down_rounded,  IRData.empty(), hintText: 'Channel previous'),
    KeyData(TextIcons.num_0,                    IRData.empty(), hintText: 'key 0'),
    KeyData(TextIcons.num_1,                    IRData.empty(), hintText: 'key 1'),
    KeyData(TextIcons.num_2,                    IRData.empty(), hintText: 'key 2'),
    KeyData(TextIcons.num_3,                    IRData.empty(), hintText: 'key 3'),
    KeyData(TextIcons.num_4,                    IRData.empty(), hintText: 'key 4'),
    KeyData(TextIcons.num_5,                    IRData.empty(), hintText: 'key 5'),
    KeyData(TextIcons.num_6,                    IRData.empty(), hintText: 'key 6'),
    KeyData(TextIcons.num_7,                    IRData.empty(), hintText: 'key 7'),
    KeyData(TextIcons.num_8,                    IRData.empty(), hintText: 'key 8'),
    KeyData(TextIcons.num_9,                    IRData.empty(), hintText: 'key 9'),
    KeyData(Icons.tv,                           IRData.empty(), hintText: 'TV'),
    KeyData(Icons.menu,                         IRData.empty(), hintText: 'menu'),
    KeyData(Icons.keyboard_arrow_up_rounded,    IRData.empty(), hintText: 'up'),
    KeyData(Icons.keyboard_arrow_down_rounded,  IRData.empty(), hintText: 'down'),
    KeyData(Icons.keyboard_arrow_left_rounded,  IRData.empty(), hintText: 'left'),
    KeyData(Icons.keyboard_arrow_right_rounded, IRData.empty(), hintText: 'right'),
    KeyData(TextIcons.G,                        IRData.empty(), hintText: 'guide'),
    KeyData(Icons.keyboard_return,              IRData.empty(), hintText: 'back'),
  ];

  Remote(String name) {
    controller.text = name;
  }

  Remote.fromJson(Map<String, dynamic> map) {
    controller.text = map['name'];
    for(int i = 0; i < keys.length; i++) keys[i].irData = IRData.fromList((map['keys'][i] as List).cast<int>());
  }

  get name => controller.text;

  Map<String, dynamic> toJson() => {
    'name' : controller.text,
    'keys' : keys.map((key) => key.irData.toList()).toList(),
  };
  /**{"name":"remote","keys":[[0,0,0,0,0],[1,1,1,1,1],[2,2,2,2,2],...]}
  **/
}
class JsonData{
  final int key;
  final int val;
  final IRData irData;

  const JsonData(this.key, this.val, {this.irData = const IRData.empty()});

  JsonData.fromMap(Map<String, dynamic> map) : this(
    map['key'],
    map['val'],
    irData: map.containsKey('ir') ?
    IRData.fromList((map['ir'] as List).cast<int>()) :
    IRData.empty(),
  );

  Map toMap() => {'key' : key, 'val': val, 'ir': irData.toList()};

  void then(Function(JsonData) onValue)=> onValue(this);
}