import 'dart:async';

import 'package:flutter/services.dart';

class Qiyu {
  factory Qiyu() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('plugins.lazyyuuuuu.io/qiyu');
      final EventChannel eventChannel =
          const EventChannel('plugins.lazyyuuuuu.io/event_qiyu');
      _instance = Qiyu.private(methodChannel, eventChannel);
    }
    return _instance;
  }

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

  ///get platformVersion
  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///register qiyu
  Future<dynamic> register(String appKey, String appName) async {
    var result = await _methodChannel
        .invokeMethod('register', {'appKey': appKey, 'appName': appName});
    return result;
  }

  ///logout qiyu
  Future<dynamic> logout() async {
    var result = await _methodChannel.invokeMethod('logout');
    return result;
  }

  ///open qiyu service view
  Future<dynamic> openServiceWindow(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('openServiceWindow', param);
    return result;
  }

  ///send commodityInfo in service view
  Future<dynamic> sendCommodityInfo(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('sendCommodityInfo', param);
    return result;
  }

  ///send selected commodityInfo in service view
  Future<dynamic> sendSelectedCommodityInfo(Map<String, dynamic> param) async {
    var result =
        await _methodChannel.invokeMethod('sendSelectedCommodityInfo', param);
    return result;
  }

  ///set custom config in service view
  Future<dynamic> setCustomUIConfig(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setCustomUIConfig', param);
    return result;
  }

  ///restore custom config to default
  Future<dynamic> restoreCustomUIConfigToDefault() async {
    var result =
        await _methodChannel.invokeMethod('restoreCustomUIConfigToDefault');
    return result;
  }

  ///set deactivate audio session
  Future<dynamic> setDeactivateAudioSessionAfterComplete(
      Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod(
        'setDeactivateAudioSessionAfterComplete', param);
    return result;
  }

  ///get unread message count
  Future<int> getUnreadCount() async {
    var result = await _methodChannel.invokeMethod('getUnreadCount');
    return result;
  }

  ///clear unread message count
  Future<dynamic> clearUnreadCount() async {
    var result = await _methodChannel.invokeMethod('clearUnreadCount');
    return result;
  }

  ///get chat session list
  Future<dynamic> getSessionList() async {
    var result = await _methodChannel.invokeMethod('getSessionList');
    return result;
  }

  ///set user info
  Future<dynamic> setUserInfo(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setUserInfo', param);
    return result;
  }

  ///set auth token
  Future<dynamic> setAuthToken(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('setAuthToken', param);
    return result;
  }

  ///set user info with verification result callback
  Future<dynamic> setUserInfoWithVerificationResultCallback(Map param) async {
    var result = await _methodChannel.invokeMethod(
        'setUserInfoWithVerificationResultCallback', param);
    return result;
  }

  ///get push message
  Future<dynamic> getPushMessage(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('getPushMessage', param);
    return result;
  }

  ///register push message notification callback
  Future<dynamic> registerPushMessageNotificationCallback() async {
    var result = await _methodChannel
        .invokeMethod('registerPushMessageNotificationCallback');
    return result;
  }

  ///get app key
  Future<String> get appKey async {
    var result = await _methodChannel.invokeMethod('getappKey');
    return result;
  }

  ///clean resource cache callback
  Future<dynamic> cleanResourceCacheCallback() async {
    var result =
        await _methodChannel.invokeMethod('cleanResourceCacheCallback');
    return result;
  }

  ///track user history
  Future<dynamic> trackHistory(Map<String, dynamic> param) async {
    var result = await _methodChannel.invokeMethod('trackHistory', param);
    return result;
  }

  ///get qiyu log path
  Future<String> get qiyuLogPath async {
    var result = await _methodChannel.invokeMethod('getQiyuLogPath');
    return result;
  }

  ///listen button click
  Stream<dynamic> onButtonClickCallback() {
    if (_onButtonClickCallback == null) {
      _onButtonClickCallback =
          _eventChannel.receiveBroadcastStream('onButtonClickCallback');
    }
    return _onButtonClickCallback;
  }

  ///listen url click
  Stream<dynamic> onURLClickCallback() {
    if (_onURLClickCallback == null) {
      _onURLClickCallback =
          _eventChannel.receiveBroadcastStream('onURLClickCallback');
    }
    return _onURLClickCallback;
  }

  ///listen bot click
  Stream<dynamic> onBotClickCallback() {
    if (_onBotClickCallback == null) {
      _onBotClickCallback =
          _eventChannel.receiveBroadcastStream('onBotClickCallback');
    }
    return _onBotClickCallback;
  }

  ///listen quit waiting
  Stream<dynamic> onQuitWaitingCallback() {
    if (_onQuitWaitingCallback == null) {
      _onQuitWaitingCallback =
          _eventChannel.receiveBroadcastStream('onQuitWaitingCallback');
    }
    return _onQuitWaitingCallback;
  }

  ///listen push message click
  Stream<dynamic> onPushMessageClickCallback() {
    if (_onPushMessageClickCallback == null) {
      _onPushMessageClickCallback =
          _eventChannel.receiveBroadcastStream('onPushMessageClickCallback');
    }
    return _onPushMessageClickCallback;
  }

  ///listen bot custom info
  Stream<dynamic> onBotCustomInfoCallback() {
    if (_onBotCustomInfoCallback == null) {
      _onBotCustomInfoCallback =
          _eventChannel.receiveBroadcastStream('onBotCustomInfoCallback');
    }
    return _onBotCustomInfoCallback;
  }

  ///listen unread message count changed
  Stream<dynamic> get onUnreadCountChanged {
    if (_onUnreadCountChanged == null) {
      _onUnreadCountChanged =
          _eventChannel.receiveBroadcastStream('onUnreadCountChanged');
    }
    return _onUnreadCountChanged;
  }

  ///listen session list changed
  Stream<dynamic> get onSessionListChanged {
    if (_onSessionListChanged == null) {
      _onSessionListChanged =
          _eventChannel.receiveBroadcastStream('onSessionListChanged');
    }
    return _onSessionListChanged;
  }

  ///listen receive message
  Stream<dynamic> get onReceiveMessage {
    if (_onReceiveMessage == null) {
      _onReceiveMessage =
          _eventChannel.receiveBroadcastStream('onReceiveMessage');
    }
    return _onReceiveMessage;
  }
}
