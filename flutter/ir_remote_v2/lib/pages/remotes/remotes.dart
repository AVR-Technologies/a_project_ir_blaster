import 'package:flutter/material.dart';
import 'package:ir_remote/key_data.dart';

import '../../text_icons.dart';

class Remotes {
  static var tv = <KeyData>[
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
  ];
  static var musicPlayer = <KeyData>[
    KeyData(Icons.power_settings_new,           IRData.empty(), hintText: 'Power'),
    KeyData(Icons.volume_off,                   IRData.empty(), hintText: 'Volume mute'),

    KeyData(Icons.skip_next_rounded,            IRData.empty(), hintText: 'Next'),
    KeyData(Icons.skip_previous_rounded,        IRData.empty(), hintText: 'Previous'),
    KeyData(Icons.play_arrow_rounded,           IRData.empty(), hintText: 'Play'),

    KeyData(Icons.add,                          IRData.empty(), hintText: 'Volume +'),
    KeyData(Icons.remove,                       IRData.empty(), hintText: 'Volume -'),
  ];

}