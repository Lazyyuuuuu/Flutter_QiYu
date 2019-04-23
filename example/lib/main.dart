import 'package:flutter/material.dart';
import 'dart:async';

import 'package:qiyu/qiyu.dart';
import 'register.dart';
import 'customUIConfig.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeApp(),
    );
  }
}


class HomeApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeApp> {
  //TODO 要改成你自己的appKey
  var _appKey = 'appKey';
  var _appName = 'QiYuDemo';
  var _defaultUIConfig = {
    'navBackgroundColor': '#FF0000',
    'viewBackButtonColor': '#FFFFFF',
    'viewBackButtonText': 'back',
    'sessionTipTextColor': '#CC00FF',
    'sessionTipTextFontSize': 13.0,
    'sessionTipBackgroundColor': '#FFFFFF',
    'customMessageTextColor': '#CC00FF',
    'customMessageHyperLinkColor': '#FFFFFF',
    'customMessageTextFontSize': 13.0,
    'serviceMessageTextColor': '#CC00FF',
    'serviceMessageHyperLinkColor': '#FFFFFF',
    'serviceMessageTextFontSize': 13.0,
    'tipMessageTextColor': '#CC00FF',
    'tipMessageTextFontSize': 13.0,
    'inputTextColor': '#CC00FF',
    'inputTextFontSize': 13.0,
    'sessionBackgroundImage': 'images/session_bg.png',
    'customerHeadImage': 'images/customer_head.png',
    'serviceHeadImage': 'images/service_head.png',
    'customerMessageBubbleNormalImage': '',
    'customerMessageBubblePressedImage': '',
    'serviceMessageBubbleNormalImage': '',
    'serviceMessageBubblePressedImage': '',
    'actionButtonTextColor': '#CC00FF',
    'actionButtonBorderColor': '#CC00FF',
    'sessionMessageSpacing': 3.0,
    'showHeadImage': true,
    'rightBarButtonItemColorBlackOrWhite': true,
    'showAudioEntry': true,
    'showAudioEntryInRobotMode': true,
    'showEmoticonEntry': true,
    'showImageEntry': true,
    'autoShowKeyboard': true,
    'bottomMargin': 10.0,
    'showCloseSessionEntry': true,
    'bypassDisplayMode': 1, //0-None, 1-Center, 2-Bottom
  };
  var _defaultSessionConfig = {
    'sessionTitle': 'QiYuDemoForFlutter',
    'groupId': 0,
    'staffId': 0,
    'robotId': 0,
    'vipLevel': 0,
    'openRobotInShuntMode': false,
    'commonQuestionTemplateId': 0,
    'source': {
      'title':'网易七鱼Flutter',
      'urlString':'http://www.qiyukf.com',
      'customInfo':'我是来自自定义的信息'
    },

    'commodityInfo': {
      'title':'Flutter商品',
      'desc':'这是来自网易七鱼Flutter的商品描述',
      'pictureUrlString':'https://qiyukf.nosdn.127.net/main/res/img/online/qy-web-cp-zxkf-kh-3.1.1-icon@2x_86ec48d3e30b8fe5d6c1d5099d370019.png',
      'urlString':'http://www.qiyukf.com',
      'note':'￥1888',
      'show':true,
      'tagsArray': [
        {
          'label': '1',
          'url': 'http://www.qiyukf.com',
          'focusIframe': '2',
          'data': '3'
        },
      ],
      'tagsString': 'tagsString',
      'isCustom': true,
      'sendByUser': false,
      'actionText': 'actionText',
      'actionTextColor': '#FFFFFF',
      'ext': '123456'
    },
    'buttonInfoArray': [
      {
        'buttonId': '123',
        'title': 'buttonInfoArray',
        'userData': 'userData'
      }
    ],
    'robotFirst':false,
    'faqTemplateId':0,
    'showCloseSessionEntry':true,
    'showQuitQueue':true
  };
  var _defaultUserInfo = {
    'userId': 'uid10101010',
    'data': [
      {
        'key': 'real_name',
        'value': '边晨'
      },
      {
        'key': 'mobile_phone',
        'value': '13805713536',
        'hidden': false
      },
      {
        'key': 'email',
        'value': 'bianchen@163.com',
      },
      {
        'key': 'authentication',
        'value': '已认证',
        'index': 0,
        'label': '实名认证'
      },
      {
        'key': 'bankcard',
        'value': '622202******01116068',
        'index': 1,
        'label': '绑定银行卡'
      }]
  };

  StreamSubscription<dynamic> _buttonClickCallbackSubscription;
  StreamSubscription<dynamic> _urlClickCallbackSubscription;
  StreamSubscription<dynamic> _botClickCallbackSubscription;
  StreamSubscription<dynamic> _quitWaitingCallbackSubscription;
  StreamSubscription<dynamic> _pushMessageClickCallbackSubscription;
  StreamSubscription<dynamic> _botCustomInfoCallbackSubscription;
  StreamSubscription<dynamic> _unreadCountChangedSubscription;
  StreamSubscription<dynamic> _sessionListChangedSubscription;
  StreamSubscription<dynamic> _receiveMessageSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSubscription();
  }

  void initSubscription() {
    _buttonClickCallbackSubscription = Qiyu().onButtonClickCallback().listen((dynamic data) {
      print(data);
    });
    _urlClickCallbackSubscription = Qiyu().onURLClickCallback().listen((dynamic data) {
      print(data);
    });
    _botClickCallbackSubscription = Qiyu().onBotClickCallback().listen((dynamic data) {
      print(data);
    });
    _quitWaitingCallbackSubscription = Qiyu().onQuitWaitingCallback().listen((dynamic data) {
      print(data);
    });
    _pushMessageClickCallbackSubscription = Qiyu().onPushMessageClickCallback().listen((dynamic data) {
      print(data);
    });
    _botCustomInfoCallbackSubscription = Qiyu().onBotCustomInfoCallback().listen((dynamic data) {
      print(data);
    });
    _unreadCountChangedSubscription = Qiyu().onUnreadCountChanged.listen((dynamic data) {
      print(data);
    });
    _sessionListChangedSubscription = Qiyu().onSessionListChanged.listen((dynamic data) {
      print(data);
    });
    _receiveMessageSubscription = Qiyu().onReceiveMessage.listen((dynamic data) {
      print(data);
    });

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await Qiyu.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      //TODO
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo for QiYu Flutter Plugin'),
      ),
      body: Builder(
        builder: (context) => Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlatButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterWidget(
                                  appKey: _appKey,
                                  appName: _appName,
                                  callback: (appKey, appName) => Qiyu().register(appKey, appName)
                              )
                          )
                      );
                    },
                    child: new Text("register"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomUIConfigWidget(
                                  config: _defaultUIConfig,
                                  callback: (config) => Qiyu().setCustomUIConfig(config))
                          )
                      );
                    },
                    child: new Text("setCustomUIConfig"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().openServiceWindow(_defaultSessionConfig);
                    },
                    child: new Text("Open QiYu Service Window"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().restoreCustomUIConfigToDefault();
                    },
                    child: new Text("restoreCustomUIConfigToDefault"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().setDeactivateAudioSessionAfterComplete({'deactivate': true});
                    },
                    child: new Text("setDeactivateAudioSessionAfterComplete"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().getUnreadCount().then((value) => Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('$value'), duration: new Duration(seconds: 1))));
                    },
                    child: new Text("getUnreadCount"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().clearUnreadCount();
                    },
                    child: new Text("clearUnreadCount"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().getSessionList().then((value) => Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('$value'), duration: new Duration(seconds: 1))));
                    },
                    child: new Text("getSessionList"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().setUserInfo(_defaultUserInfo);
                    },
                    child: new Text("setUserInfo"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().setAuthToken({'authToken':'1111111111'});
                    },
                    child: new Text("setAuthToken"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().setUserInfoWithVerificationResultCallback(_defaultUserInfo);
                    },
                    child: new Text("setUserInfoWithVerificationResultCallback"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().getPushMessage({'messageId': '1111111111'});
                    },
                    child: new Text("getPushMessage"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().registerPushMessageNotificationCallback();
                    },
                    child: new Text("registerPushMessageNotificationCallback"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().appKey.then((value) => Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('$value'), duration: new Duration(seconds: 1))));
                    },
                    child: new Text("getappKey"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().cleanResourceCacheCallback();
                    },
                    child: new Text("cleanResourceCacheCallback"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().trackHistory({'title': 'lalala', 'enterOrOut': true, 'key': 'key'});
                    },
                    child: new Text("trackHistory"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().qiyuLogPath.then((value) => Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('$value'), duration: new Duration(seconds: 1))));
                    },
                    child: new Text("getQiyuLogPath"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().sendCommodityInfo({
                        'commodityInfo': {
                          'title':'Flutter商品111',
                          'desc':'这是来自网易七鱼Flutter的商品描述111',
                          'pictureUrlString':'https://qiyukf.nosdn.127.net/main/res/img/online/qy-web-cp-zxkf-kh-3.1.1-icon@2x_86ec48d3e30b8fe5d6c1d5099d370019.png',
                          'urlString':'http://www.qiyukf.com',
                          'note':'￥188811',
                          'show':true,
                          'tagsArray': [
                            {
                              'label': '1',
                              'url': 'http://www.qiyukf.com',
                              'focusIframe': '2',
                              'data': '3'
                            },
                          ],
                          'tagsString': 'tagsString',
                          'isCustom': true,
                          'sendByUser': false,
                          'actionText': 'actionText',
                          'actionTextColor': '#FFFFFF',
                          'ext': '1236'
                        }
                      });
                    },
                    child: new Text("sendCommodityInfo"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().sendSelectedCommodityInfo({
                        'selectedCommodityInfo': {
                          'target': 'lalalala',
                          'params': 'params',
                          'p_status': 'p_status'
                        }
                      });
                    },
                    child: new Text("sendSelectedCommodityInfo"),
                    textColor: Colors.blue,
                  ),
                  new FlatButton(
                    onPressed: (){
                      Qiyu().logout();
                    },
                    child: new Text("logout"),
                    textColor: Colors.blue,
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    cancelSubscription();
  }

  void cancelSubscription() {
    if (_buttonClickCallbackSubscription != null) {
      _buttonClickCallbackSubscription.cancel();
    }
    if (_urlClickCallbackSubscription != null) {
      _urlClickCallbackSubscription.cancel();
    }
    if (_botClickCallbackSubscription != null) {
      _botClickCallbackSubscription.cancel();
    }
    if (_quitWaitingCallbackSubscription != null) {
      _quitWaitingCallbackSubscription.cancel();
    }
    if (_pushMessageClickCallbackSubscription != null) {
      _pushMessageClickCallbackSubscription.cancel();
    }
    if (_botCustomInfoCallbackSubscription != null) {
      _botCustomInfoCallbackSubscription.cancel();
    }
    if (_unreadCountChangedSubscription != null) {
      _unreadCountChangedSubscription.cancel();
    }
    if (_sessionListChangedSubscription != null) {
      _sessionListChangedSubscription.cancel();
    }
    if (_receiveMessageSubscription != null) {
      _receiveMessageSubscription.cancel();
    }
  }
}
