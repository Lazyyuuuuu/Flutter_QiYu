import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;

class Qiyu {

  factory Qiyu() {
    if(_instance == null) {
      final MethodChannel methodChannel =
        const MethodChannel('plugins.lazyyuuuuu.io/qiyu');
      final EventChannel eventChannel =
        const EventChannel('plugins.lazyyuuuuu.io/event_qiyu');
      _instance = Qiyu.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  Qiyu.private(this._methodChannel, this._eventChannel);

  static Qiyu _instance;
  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  Stream<dynamic> _onButtonClickCallback;
  Stream<dynamic> _onURLClickCallback;
  Stream<dynamic> _onBotClickCallback;
  Stream<dynamic> _onQuitWaitingCallback;
  Stream<dynamic> _onPushMessageClickCallback;
  Stream<dynamic> _onBotCustomInfoCallback;
  Stream<dynamic> _onUnreadCountChanged;
  Stream<dynamic> _onSessionListChanged;
  Stream<dynamic> _onReceiveMessage;

  Future<String> get platformVersion async {
    final String version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<dynamic> register(String appKey, String appName) async {
    var result = await _methodChannel
        .invokeMethod('register', {'appKey': appKey, 'appName': appName});
    return result;
  }

  Future<dynamic> logout() async {
    var result = await _methodChannel.invokeMethod('logout');
    return result;
  }

  Future<dynamic> openServiceWindow(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('openServiceWindow', param);
    return result;
  }

  Future<dynamic> sendCommodityInfo(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('sendCommodityInfo', param);
    return result;
  }

  Future<dynamic> sendSelectedCommodityInfo(Map<String, dynamic> param) async {
    var result =
        await _methodChannel.invokeMethod('sendSelectedCommodityInfo', param);
    return result;
  }

  Future<dynamic> setCustomUIConfig(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setCustomUIConfig', param);
    return result;
  }

  Future<dynamic> restoreCustomUIConfigToDefault() async {
    var result = await _methodChannel.invokeMethod('restoreCustomUIConfigToDefault');
    return result;
  }

  Future<dynamic> setDeactivateAudioSessionAfterComplete(
      Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod(
        'setDeactivateAudioSessionAfterComplete', param);
    return result;
  }

  Future<int> getUnreadCount() async {
    var result = await _methodChannel.invokeMethod('getUnreadCount');
    return result;
  }

  Future<dynamic> clearUnreadCount() async {
    var result = await _methodChannel.invokeMethod('clearUnreadCount');
    return result;
  }

  Future<dynamic> getSessionList() async {
    var result = await _methodChannel.invokeMethod('getSessionList');
    return result;
  }

  Future<dynamic> setUserInfo(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setUserInfo', param);
    return result;
  }

  Future<dynamic> setAuthToken(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setAuthToken', param);
    return result;
  }

  Future<dynamic> setUserInfoWithVerificationResultCallback(
      Map param) async {
    var result = await _methodChannel.invokeMethod(
        'setUserInfoWithVerificationResultCallback', param);
    return result;
  }

  Future<dynamic> getPushMessage(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('getPushMessage', param);
    return result;
  }

  Future<dynamic> registerPushMessageNotificationCallback() async {
    var result =
        await _methodChannel.invokeMethod('registerPushMessageNotificationCallback');
    return result;
  }

  Future<String> get appKey async {
    var result = await _methodChannel.invokeMethod('getappKey');
    return result;
  }

  Future<dynamic> cleanResourceCacheCallback() async {
    var result = await _methodChannel.invokeMethod('cleanResourceCacheCallback');
    return result;
  }

  Future<dynamic> trackHistory(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('trackHistory', param);
    return result;
  }

  Future<String> get qiyuLogPath async {
    var result = await _methodChannel.invokeMethod('getQiyuLogPath');
    return result;
  }

  Stream<dynamic> onButtonClickCallback() {
    if (_onButtonClickCallback == null) {
      _onButtonClickCallback =
          _eventChannel.receiveBroadcastStream('onButtonClickCallback');
    }
    return _onButtonClickCallback;
  }

  Stream<dynamic> onURLClickCallback() {
    if (_onURLClickCallback == null) {
      _onURLClickCallback =
          _eventChannel.receiveBroadcastStream('onURLClickCallback');
    }
    return _onURLClickCallback;
  }

  Stream<dynamic> onBotClickCallback() {
    if (_onBotClickCallback == null) {
      _onBotClickCallback =
          _eventChannel.receiveBroadcastStream('onBotClickCallback');
    }
    return _onBotClickCallback;
  }

  Stream<dynamic> onQuitWaitingCallback() {
    if (_onQuitWaitingCallback == null) {
      _onQuitWaitingCallback =
          _eventChannel.receiveBroadcastStream('onQuitWaitingCallback');
    }
    return _onQuitWaitingCallback;
  }

  Stream<dynamic> onPushMessageClickCallback() {
    if (_onPushMessageClickCallback == null) {
      _onPushMessageClickCallback =
          _eventChannel.receiveBroadcastStream('onPushMessageClickCallback');
    }
    return _onPushMessageClickCallback;
  }

  Stream<dynamic> onBotCustomInfoCallback() {
    if (_onBotCustomInfoCallback == null) {
      _onBotCustomInfoCallback =
          _eventChannel.receiveBroadcastStream('onBotCustomInfoCallback');
    }
    return _onBotCustomInfoCallback;
  }

  Stream<dynamic> get onUnreadCountChanged {
    if (_onUnreadCountChanged == null) {
      _onUnreadCountChanged =
          _eventChannel.receiveBroadcastStream('onUnreadCountChanged');
    }
    return _onUnreadCountChanged;
  }

  Stream<dynamic> get onSessionListChanged {
    if (_onSessionListChanged == null) {
      _onSessionListChanged =
          _eventChannel.receiveBroadcastStream('onSessionListChanged');
    }
    return _onSessionListChanged;
  }

  Stream<dynamic> get onReceiveMessage {
    if (_onReceiveMessage == null) {
      _onReceiveMessage =
          _eventChannel.receiveBroadcastStream('onReceiveMessage');
    }
    return _onReceiveMessage;
  }
}
