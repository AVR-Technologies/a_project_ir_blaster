
import 'dart:convert';


// json keys // communication related
const read_mode   =  0x01; // to json
const change_mode =  0x02; // to json
const write_ir    =  0x03; // to json
const send_mode   =  0x11; // from json
const new_ir_key  =  0x12; // from json
//
enum RemoteType{
  tv,//0
  ac, //1
  music_player//2
}
var remoteTypes = const ['tv', 'ac', 'music player'];
enum KeyType{
  key0 ,
  key1 ,
  key2 ,
  key3 ,
  key4 ,
  key5 ,
  key6 ,
  key7 ,
  key8 ,
  key9 ,
  keyVolPlus ,
  keyVolMinus ,
  keyChPlus ,
  keyChMinus ,
  keySelect ,
  keySelectDown ,
  keySelectLeft ,
  keySelectRight ,
  keySelectUp ,
  keyPower ,
  keyTv ,
  keyVolMute ,
  keyBack ,
  keyGuide,
  keyPlay,
  keySkipNext,
  keySkipPrevious,
}
List<KeyType> remotePattern(RemoteType type){
  List<KeyType> tv = const[
    KeyType.key0 ,
    KeyType.key1 ,
    KeyType.key2 ,
    KeyType.key3 ,
    KeyType.key4 ,
    KeyType.key5 ,
    KeyType.key6 ,
    KeyType.key7 ,
    KeyType.key8 ,
    KeyType.key9 ,
    KeyType.keyVolPlus ,
    KeyType.keyVolMinus ,
    KeyType.keyChPlus ,
    KeyType.keyChMinus ,
    KeyType.keySelect ,
    KeyType.keySelectDown ,
    KeyType.keySelectLeft ,
    KeyType.keySelectRight ,
    KeyType.keySelectUp ,
    KeyType.keyPower ,
    KeyType.keyTv ,
    KeyType.keyVolMute ,
    KeyType.keyBack ,
    KeyType.keyGuide
  ];
  return tv;
}

class IrData{
  final int? address;
  final int? command;
  final int? data;     //rawData
  final int? length;   //no of bytes
  final int? protocol;

  const IrData(this.address, this.command, this.data, this.length, this.protocol);
  const IrData.empty() : this(0,0,0,0,0);
  IrData.fromList(List<int> list) : this(list[0], list[1], list[4], list[2], list[3]);
  // IrData.fromMap(Map map) : this(map['address'], map['command'], map['data'], map['length'], map['protocol']);
  IrData.fromDynamic(dynamic map) : this(
      map['address'] ?? 0,
      map['command'] ?? 0,
      map['data'] ?? 0,
      map['length'] ?? 0,
      map['protocol'] ?? 0,
  );

  Map toMap() => {
      'address'   : address ?? 0,
      'command'   : command ?? 0,
      'data'      : data ?? 0,
      'length'    : length ?? 0,
      'protocol'  : protocol ?? 0,
  };

  List<int> toList() => <int>[address ?? 0, command ?? 0, length ?? 0, protocol ?? 0, data ?? 0];
}
/// remote types
///
class RemoteKey{
  final KeyType type;
  IrData irData = IrData.empty();
  RemoteKey(this.type);
}
/// remote object
class Remote{
  int? id = 0;
  var name = "";
  RemoteType? remoteType; // for remote ui selection

  Map<KeyType, RemoteKey> get all => {
    KeyType.key0            : key0,
    KeyType.key1            : key1,
    KeyType.key2            : key2,
    KeyType.key3            : key3,
    KeyType.key4            : key4,
    KeyType.key5            : key5,
    KeyType.key6            : key6,
    KeyType.key7            : key7,
    KeyType.key8            : key8,
    KeyType.key9            : key9,
    KeyType.keyVolPlus      : keyVolPlus,
    KeyType.keyVolMinus     : keyVolMinus,
    KeyType.keyChPlus       : keyChPlus,
    KeyType.keyChMinus      : keyChMinus,
    KeyType.keySelect       : keySelect,
    KeyType.keySelectDown   : keySelectDown,
    KeyType.keySelectLeft   : keySelectLeft,
    KeyType.keySelectRight  : keySelectRight,
    KeyType.keySelectUp     : keySelectUp,
    KeyType.keyPower        : keyPower,
    KeyType.keyTv           : keyTv,
    KeyType.keyVolMute      : keyVolMute,
    KeyType.keyBack         : keyBack,
    KeyType.keyGuide        : keyGuide,
    KeyType.keyPlay         : keyPlay,
    KeyType.keySkipNext     : keySkipNext,
    KeyType.keySkipPrevious : keySkipPrevious,
  };
  List<RemoteKey> get keys => all.values.toList();

  RemoteKey key0            = RemoteKey(KeyType.key0);
  RemoteKey key1            = RemoteKey(KeyType.key1);
  RemoteKey key2            = RemoteKey(KeyType.key2);
  RemoteKey key3            = RemoteKey(KeyType.key3);
  RemoteKey key4            = RemoteKey(KeyType.key4);
  RemoteKey key5            = RemoteKey(KeyType.key5);
  RemoteKey key6            = RemoteKey(KeyType.key6);
  RemoteKey key7            = RemoteKey(KeyType.key7);
  RemoteKey key8            = RemoteKey(KeyType.key8);
  RemoteKey key9            = RemoteKey(KeyType.key9);
  RemoteKey keyVolPlus      = RemoteKey(KeyType.keyVolPlus);
  RemoteKey keyVolMinus     = RemoteKey(KeyType.keyVolMinus);
  RemoteKey keyChPlus       = RemoteKey(KeyType.keyChPlus);
  RemoteKey keyChMinus      = RemoteKey(KeyType.keyChMinus);
  RemoteKey keySelect       = RemoteKey(KeyType.keySelect);
  RemoteKey keySelectDown   = RemoteKey(KeyType.keySelectDown);
  RemoteKey keySelectLeft   = RemoteKey(KeyType.keySelectLeft);
  RemoteKey keySelectRight  = RemoteKey(KeyType.keySelectRight);
  RemoteKey keySelectUp     = RemoteKey(KeyType.keySelectUp);
  RemoteKey keyPower        = RemoteKey(KeyType.keyPower);
  RemoteKey keyTv           = RemoteKey(KeyType.keyTv);
  RemoteKey keyVolMute      = RemoteKey(KeyType.keyVolMute);
  RemoteKey keyBack         = RemoteKey(KeyType.keyBack);
  RemoteKey keyGuide        = RemoteKey(KeyType.keyGuide);
  RemoteKey keyPlay         = RemoteKey(KeyType.keyPlay);
  RemoteKey keySkipNext     = RemoteKey(KeyType.keySkipNext);
  RemoteKey keySkipPrevious = RemoteKey(KeyType.keySkipPrevious);

  // bool selected = false; // for multi select
  Remote(this.id, this.name, this.remoteType);

  Remote.newRemote(String name, RemoteType type) : this(0, name, type);

  // Remote.fromMap(Map map) : this(
  //   map['id'],
  //   map['name'],
  //   RemoteType.values[map['remoteType'] as int],
  //   key0          : IrData.fromMap(map['key0']),
  //   key1          : IrData.fromMap(map['key1']),
  //   key2          : IrData.fromMap(map['key2']),
  //   key3          : IrData.fromMap(map['key3']),
  //   key4          : IrData.fromMap(map['key4']),
  //   key5          : IrData.fromMap(map['key5']),
  //   key6          : IrData.fromMap(map['key6']),
  //   key7          : IrData.fromMap(map['key7']),
  //   key8          : IrData.fromMap(map['key8']),
  //   key9          : IrData.fromMap(map['key9']),
  //   keyVolPlus    : IrData.fromMap(map['keyVolPlus']),
  //   keyVolMinus   : IrData.fromMap(map['keyVolMinus']),
  //   keyChPlus     : IrData.fromMap(map['keyChPlus']),
  //   keyChMinus    : IrData.fromMap(map['keyChMinus']),
  //   keySelect     : IrData.fromMap(map['keySelect']),
  //   keySelectDown : IrData.fromMap(map['keySelectDown']),
  //   keySelectLeft : IrData.fromMap(map['keySelectLeft']),
  //   keySelectRight: IrData.fromMap(map['keySelectRight']),
  //   keySelectUp   : IrData.fromMap(map['keySelectUp']),
  //   keyPower      : IrData.fromMap(map['keyPower']),
  //   keyTv         : IrData.fromMap(map['keyTv']),
  //   keyVolMute    : IrData.fromMap(map['keyVolMute']),
  //   keyBack       : IrData.fromMap(map['keyBack']),
  //   keyGuide      : IrData.fromMap(map['keyGuide']),
  // );
  Remote.fromDynamic(dynamic map){
    id                                  = map['id'] ?? 0;
    name                                = map['name'];
    remoteType                          = RemoteType.values[map['remoteType'] as int];
    all[KeyType.key0]!.irData           = IrData.fromDynamic(json.decode(map['key0']));
    all[KeyType.key0]!.irData           = IrData.fromDynamic(json.decode(map['key0']));
    all[KeyType.key1]!.irData           = IrData.fromDynamic(json.decode(map['key1']));
    all[KeyType.key2]!.irData           = IrData.fromDynamic(json.decode(map['key2']));
    all[KeyType.key3]!.irData           = IrData.fromDynamic(json.decode(map['key3']));
    all[KeyType.key4]!.irData           = IrData.fromDynamic(json.decode(map['key4']));
    all[KeyType.key5]!.irData           = IrData.fromDynamic(json.decode(map['key5']));
    all[KeyType.key6]!.irData           = IrData.fromDynamic(json.decode(map['key6']));
    all[KeyType.key7]!.irData           = IrData.fromDynamic(json.decode(map['key7']));
    all[KeyType.key8]!.irData           = IrData.fromDynamic(json.decode(map['key8']));
    all[KeyType.key9]!.irData           = IrData.fromDynamic(json.decode(map['key9']));
    all[KeyType.keyVolPlus]!.irData     = IrData.fromDynamic(json.decode(map['keyVolPlus']));
    all[KeyType.keyVolMinus]!.irData    = IrData.fromDynamic(json.decode(map['keyVolMinus']));
    all[KeyType.keyChPlus]!.irData      = IrData.fromDynamic(json.decode(map['keyChPlus']));
    all[KeyType.keyChMinus]!.irData     = IrData.fromDynamic(json.decode(map['keyChMinus']));
    all[KeyType.keySelect]!.irData      = IrData.fromDynamic(json.decode(map['keySelect']));
    all[KeyType.keySelectDown]!.irData  = IrData.fromDynamic(json.decode(map['keySelectDown']));
    all[KeyType.keySelectLeft]!.irData  = IrData.fromDynamic(json.decode(map['keySelectLeft']));
    all[KeyType.keySelectRight]!.irData = IrData.fromDynamic(json.decode(map['keySelectRight']));
    all[KeyType.keySelectUp]!.irData    = IrData.fromDynamic(json.decode(map['keySelectUp']));
    all[KeyType.keyPower]!.irData       = IrData.fromDynamic(json.decode(map['keyPower']));
    all[KeyType.keyTv]!.irData          = IrData.fromDynamic(json.decode(map['keyTv']));
    all[KeyType.keyVolMute]!.irData     = IrData.fromDynamic(json.decode(map['keyVolMute']));
    all[KeyType.keyBack]!.irData        = IrData.fromDynamic(json.decode(map['keyBack']));
    all[KeyType.keyGuide]!.irData       = IrData.fromDynamic(json.decode(map['keyGuide']));
    all[KeyType.keyPlay]!.irData        = IrData.fromDynamic(json.decode(map['keyPlay']));
    all[KeyType.keySkipNext]!.irData    = IrData.fromDynamic(json.decode(map['keySkipNext']));
    all[KeyType.keySkipPrevious]!.irData= IrData.fromDynamic(json.decode(map['keySkipPrevious']));
  }
  /*Remote.fromDynamic(dynamic map) : this(
    map['id'] ?? 0,
    map['name'],
    RemoteType.values[map['remoteType'] as int],
    // key0          : IrData.fromDynamicList(map['key0']),
    // key1          : IrData.fromDynamicList(map['key1']),
    // key2          : IrData.fromDynamicList(map['key2']),
    // key3          : IrData.fromDynamicList(map['key3']),
    // key4          : IrData.fromDynamicList(map['key4']),
    // key5          : IrData.fromDynamicList(map['key5']),
    // key6          : IrData.fromDynamicList(map['key6']),
    // key7          : IrData.fromDynamicList(map['key7']),
    // key8          : IrData.fromDynamicList(map['key8']),
    // key9          : IrData.fromDynamicList(map['key9']),
    // keyVolPlus    : IrData.fromDynamicList(map['keyVolPlus']),
    // keyVolMinus   : IrData.fromDynamicList(map['keyVolMinus']),
    // keyChPlus     : IrData.fromDynamicList(map['keyChPlus']),
    // keyChMinus    : IrData.fromDynamicList(map['keyChMinus']),
    // keySelect     : IrData.fromDynamicList(map['keySelect']),
    // keySelectDown : IrData.fromDynamicList(map['keySelectDown']),
    // keySelectLeft : IrData.fromDynamicList(map['keySelectLeft']),
    // keySelectRight: IrData.fromDynamicList(map['keySelectRight']),
    // keySelectUp   : IrData.fromDynamicList(map['keySelectUp']),
    // keyPower      : IrData.fromDynamicList(map['keyPower']),
    // keyTv         : IrData.fromDynamicList(map['keyTv']),
    // keyVolMute    : IrData.fromDynamicList(map['keyVolMute']),
    // keyBack       : IrData.fromDynamicList(map['keyBack']),
    // keyGuide      : IrData.fromDynamicList(map['keyGuide']),
  );*/

  Map<String, Object> toMap() => {
    'name'            : name,
    'remoteType'      : remoteType != null ? remoteType!.index : 0,
    'key0'            : json.encode(all[KeyType.key0]!.irData.toMap()),
    'key1'            : json.encode(all[KeyType.key1]!.irData.toMap()),
    'key2'            : json.encode(all[KeyType.key2]!.irData.toMap()),
    'key3'            : json.encode(all[KeyType.key3]!.irData.toMap()),
    'key4'            : json.encode(all[KeyType.key4]!.irData.toMap()),
    'key5'            : json.encode(all[KeyType.key5]!.irData.toMap()),
    'key6'            : json.encode(all[KeyType.key6]!.irData.toMap()),
    'key7'            : json.encode(all[KeyType.key7]!.irData.toMap()),
    'key8'            : json.encode(all[KeyType.key8]!.irData.toMap()),
    'key9'            : json.encode(all[KeyType.key9]!.irData.toMap()),
    'keyVolPlus'      : json.encode(all[KeyType.keyVolPlus]!.irData.toMap()),
    'keyVolMinus'     : json.encode(all[KeyType.keyVolMinus]!.irData.toMap()),
    'keyChPlus'       : json.encode(all[KeyType.keyChPlus]!.irData.toMap()),
    'keyChMinus'      : json.encode(all[KeyType.keyChMinus]!.irData.toMap()),
    'keySelect'       : json.encode(all[KeyType.keySelect]!.irData.toMap()),
    'keySelectDown'   : json.encode(all[KeyType.keySelectDown]!.irData.toMap()),
    'keySelectLeft'   : json.encode(all[KeyType.keySelectLeft]!.irData.toMap()),
    'keySelectRight'  : json.encode(all[KeyType.keySelectRight]!.irData.toMap()),
    'keySelectUp'     : json.encode(all[KeyType.keySelectUp]!.irData.toMap()),
    'keyPower'        : json.encode(all[KeyType.keyPower]!.irData.toMap()),
    'keyTv'           : json.encode(all[KeyType.keyTv]!.irData.toMap()),
    'keyVolMute'      : json.encode(all[KeyType.keyVolMute]!.irData.toMap()),
    'keyBack'         : json.encode(all[KeyType.keyBack]!.irData.toMap()),
    'keyGuide'        : json.encode(all[KeyType.keyGuide]!.irData.toMap()),
    'keyPlay'         : json.encode(all[KeyType.keyPlay]!.irData.toMap()),
    'keySkipNext'     : json.encode(all[KeyType.keySkipNext]!.irData.toMap()),
    'keySkipPrevious' : json.encode(all[KeyType.keySkipPrevious]!.irData.toMap()),
  };
/*  @override
  String toString() {
    return 'Remote{'
        'name: $name, '
        'remoteType: $remoteType, '
        'key0: $key0, '
        'key1: $key1, '
        'key2: $key2, '
        'key3: $key3, '
        'key4: $key4, '
        'key5: $key5, '
        'key6: $key6, '
        'key7: $key7, '
        'key8: $key8, '
        'key9: $key9, '
        'keyVolPlus: $keyVolPlus, '
        'keyVolMinus: $keyVolMinus, '
        'keyChPlus: $keyChPlus, '
        'keyChMinus: $keyChMinus, '
        'keySelect: $keySelect, '
        'keySelectDown: $keySelectDown, '
        'keySelectLeft: $keySelectLeft, '
        'keySelectRight: $keySelectRight, '
        'keySelectUp: $keySelectUp, '
        'keyPower: $keyPower, '
        'keyTv: $keyTv, '
        'keyVolMute: $keyVolMute, '
        'keyBack: $keyBack, '
        'keyGuide: $keyGuide'
        '}';
  }*/
  static String createTableQuery() {
    return  'CREATE TABLE remotes('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name TEXT, '
        'remoteType INTEGER, '
        'key0 TEXT, '
        'key1 TEXT, '
        'key2 TEXT, '
        'key3 TEXT, '
        'key4 TEXT, '
        'key5 TEXT, '
        'key6 TEXT, '
        'key7 TEXT, '
        'key8 TEXT, '
        'key9 TEXT, '
        'keyVolPlus TEXT, '
        'keyVolMinus TEXT, '
        'keyChPlus TEXT, '
        'keyChMinus TEXT, '
        'keySelect TEXT, '
        'keySelectDown TEXT, '
        'keySelectLeft TEXT, '
        'keySelectRight TEXT, '
        'keySelectUp TEXT, '
        'keyPower TEXT, '
        'keyTv TEXT, '
        'keyVolMute TEXT, '
        'keyBack TEXT, '
        'keyGuide TEXT, '
        'keyPlay TEXT, '
        'keySkipNext TEXT, '
        'keySkipPrevious TEXT'
        ')';
  }
// Remote.withType(String name, RemoteType type) : this(name, type);
/*IrData? irData(KeyType type) {
    return
      type == KeyType.key0 ? key0.irData :
      type == KeyType.key1 ? key1.irData :
      type == KeyType.key2 ? key2.irData :
      type == KeyType.key3 ? key3.irData :
      type == KeyType.key4 ? key4.irData :
      type == KeyType.key5 ? key5.irData :
      type == KeyType.key6 ? key6.irData :
      type == KeyType.key7 ? key7.irData :
      type == KeyType.key8 ? key8.irData :
      type == KeyType.key9 ? key9.irData :
      type == KeyType.keyVolPlus ? keyVolPlus.irData :
      type == KeyType.keyVolMinus ? keyVolMinus.irData :
      type == KeyType.keyChPlus ? keyChPlus.irData :
      type == KeyType.keyChMinus ? keyChMinus.irData :
      type == KeyType.keySelect ? keySelect.irData :
      type == KeyType.keySelectDown ? keySelectDown.irData :
      type == KeyType.keySelectLeft ? keySelectLeft.irData :
      type == KeyType.keySelectRight ? keySelectRight.irData :
      type == KeyType.keySelectUp ? keySelectUp.irData :
      type == KeyType.keyPower ? keyPower.irData :
      type == KeyType.keyTv ? keyTv.irData :
      type == KeyType.keyVolMute ? keyVolMute.irData :
      type == KeyType.keyBack ? keyBack.irData :
      type == KeyType.keyGuide ? keyGuide.irData :
      null;
  }*/
}