#include "ArduinoJson.h"
#include "BluetoothSerial.h"
#include "IRremote.h"
//bluetooth and json
BluetoothSerial SerialBT;
StaticJsonDocument<400> doc;
String output = "";
String input = "";
// esp special
#define ir_receive_pin          15  // D15
#define ir_send_pin              4  // D4
#define tone(a,b,c) void()      // no tone() available on ESP32
#define noTone(a) void()
//ir mode handle
int mode = 0x00; //0x01 edit mode , 0x00 remote mode
// json keys
const byte read_mode   =  0x01; // from json
const byte change_mode =  0x02; // from json
const byte write_ir    =  0x03; // from json
const byte send_mode   =  0x11; // to json
const byte new_ir_key  =  0x12; // to json
//structs
struct irData2 {
  uint16_t  address;      // ir
  uint16_t  command;      // ir
  uint8_t   numberOfBits; // ir
  uint8_t   protocol;     // ir
  uint32_t  rawData;      // ir
  bool fromJson(JsonArray ir) {
    if (ir.size() == 5) {
      address       = ir[0];
      command       = ir[1];
      numberOfBits  = ir[2];
      protocol      = ir[3];
      rawData       = ir[4];
      return true;
    }
    else return false;
  }
  void toJson() {
    JsonArray ir = doc.createNestedArray("ir");
    ir.add(address);
    ir.add(command);
    ir.add(numberOfBits);
    ir.add(protocol);
    ir.add(rawData);
  }
  bool irWrite() {
    if (protocol > 0) {
      Serial.println("ir write");
      if (protocol == NEC)             IrSender.sendNECRaw(rawData, 0); //data, repeat
      //    else if (protocol == SAMSUNG)    IrSender.sendSamsung((unsigned long)rawData, (int) numberOfBits);
      else if (protocol == SONY)       IrSender.sendSony(rawData, numberOfBits);
      //  else if (protocol == PANASONIC)  IrSender.sendPanasonic(tAddress, tCommand, 0);
      //  else if (protocol == DENON)      IrSender.sendDenon(tAddress, tCommand, 0);
      //  else if (protocol == SHARP)      IrSender.sendSharp(tAddress, tCommand, 0);
      //  else if (protocol == LG)         IrSender.sendLG(tAddress, tCommand, 0, 0);
      //  else if (protocol == JVC)        IrSender.sendJVC((uint8_t) tAddress, (uint8_t) tCommand, 0); // casts are required to specify the right function
      else if (protocol == RC5)        IrSender.sendRC5(rawData, numberOfBits); // No toggle for repeats
      else if (protocol == RC6)        IrSender.sendRC6(rawData, numberOfBits); // No toggle for repeats
      //  else if (protocol == ONKYO)      IrSender.sendOnkyo(tAddress, tCommand, 0, 0);
      //  else if (protocol == APPLE)      IrSender.sendApple(tAddress, tCommand, 0, 0);
      delay(1000);
      return true;
    } else return false;
  }
  void resume() {
    IrReceiver.resume();
  }
  void start() {
    IrReceiver.start();
  }
  void stop() {
    IrReceiver.stop();
  }
} irData;
struct JsonData {
  byte      key;          // json // data type
  byte      val;          // json // data
  bool fromJson() {
    doc.clear();
    if (!deserializeJson(doc, SerialBT)) {
      if (doc.containsKey("key")) key = doc["key"];
      if (doc.containsKey("val")) val = doc["val"];
      if (doc.containsKey("ir"))  irData.fromJson(doc["ir"]);
      input = "";
      act();
      return true;
    } else return false;
  }
  void toJson() {
    output = "";
    doc.clear();
    doc["key"] = key;
    doc["val"] = val;
    if (key == new_ir_key) irData.toJson();
    serializeJson(doc, output);
  }
  void print() {
    toJson();
    SerialBT.print(output);
    Serial.println(F("[address, command, noOfBits, protocol, rawData]"));
    Serial.println(output);
  }
  void act() {
    if (key == read_mode) readMode();   
    else if (key == change_mode) changeMode(); 
    else if (key == write_ir) irData.irWrite(); //print function also reads ir data from json and write to ir
  }
  void changeMode() {
    mode = val;
    mode == read_mode ? irData.start() : irData.stop(); //0x01 edit mode , 0x00 remote mode
    Serial.print(mode ? F("enter in edit mode") : F("enter in remote mode"));
    readMode();
  }
  void readMode() {
    key = send_mode;
    val = mode;
    print();
  }
} json;
void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32test");
  IrReceiver.begin(ir_receive_pin, ENABLE_LED_FEEDBACK);
  IrSender.begin(ir_send_pin, ENABLE_LED_FEEDBACK);
  IrReceiver.stop();
}
void loop() {
  if (SerialBT.available()) {
//    Serial.println(SerialBT.readString());
//    input = SerialBT.readString();
//    Serial.println(input);
    if (!json.fromJson()) Serial.print("error");
  }
  readNewKeyEntry();
}
void readNewKeyEntry() {
  if (IrReceiver.decode()) {
    Serial.println("new ir enterred");
    if (IrReceiver.decodedIRData.protocol > 0 && IrReceiver.decodedIRData.decodedRawData > 0) {
      irData.address       = IrReceiver.decodedIRData.address;
      irData.command       = IrReceiver.decodedIRData.command;
      irData.numberOfBits  = IrReceiver.decodedIRData.numberOfBits;//also 0 if key not released
      irData.protocol      = IrReceiver.decodedIRData.protocol;
      irData.rawData       = IrReceiver.decodedIRData.decodedRawData;//also 0 if key not released
      json = {new_ir_key, 0};
      json.print();
    }
    IrReceiver.resume();
  }
}
