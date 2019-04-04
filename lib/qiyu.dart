import 'dart:async';

import 'package:flutter/services.dart';

class Qiyu {
  static const MethodChannel _channel =
      const MethodChannel('qiyu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
