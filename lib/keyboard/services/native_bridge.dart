import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('ghost_channel');

  static void sendKey(String text) {
    _channel.invokeMethod('keyPress', {'text': text});
  }
}
