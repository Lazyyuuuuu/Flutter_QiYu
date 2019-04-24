# 网易七鱼 Flutter 插件集成指南

## QiYu

### 简介

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 APP 中。
本模块支持 iOS 7 以上，Android 2.3 以上版本，同时支持手机、Pad。在iOS 9.2 以上版本中支持 IPv6，能正常通过苹果审核。
详情请前往：http://www.qiyukf.com

### 安装与配置

#### 安装

1.依赖它

* 打开你工程中的```pubspec.yaml``` 文件，然后在```dependencies```下添加```qiyu:```

2.安装它

* 在 terminal中: 运行```flutter packages get```
  **或者**

* 在 IntelliJ中: 点击```pubspec.yaml```文件顶部的’Packages Get’

3.导入它

* 在您的Dart代码中添加相应的```import```语句.
#### 配置


#####https相关
v3.1.3 版本开始，SDK 已经全面支持 https，但是聊天消息中可能存在链接，点击链接会用 UIWebView 打开，链接地址有可能是 http 的，为了能够正常打开，需要增加配置项。在 Info.plist 中加入以下内容：
```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```
加了这些配置项，在 iOS9 下，会放开所有 http 请求，在 iOS10 下，因 iOS10 规定，如果设置了 NSAllowsArbitraryLoadsInWebContent，就会忽略 NSAllowsArbitraryLoads，所以效果是只允许 UIWebView 中使用 http。
#####iOS10权限设置
在 Info.plist 中加入以下内容：
```
<key>NSPhotoLibraryUsageDescription</key>
<string>需要照片权限</string>
<key>NSCameraUsageDescription</key>
<string>需要相机权限</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要麦克风权限</string>
```
如果不加，会 crash。
#####iOS11权限设置
在 Info.plist 中加入以下内容：
```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>App需要您的同意,才能添加照片到相册</string>
```
如果不加，会 crash。请注意，iOS11 需要的是 NSPhotoLibraryAddUsageDescription，跟 iOS10 需要的 NSPhotoLibraryUsageDescription 不一样。

具体使用请参考QiYuDemo例子工程

### Method
- register
- logout
- openServiceWindow
- sendCommodityInfo
- sendSelectedCommodityInfo
- setCustomUIConfig
- restoreCustomUIConfigToDefault
- setDeactivateAudioSessionAfterComplete
- getUnreadCount
- clearUnreadCount
- getSessionList
- setUserInfo
- setAuthToken
- setUserInfoWithVerificationResultCallback
- getPushMessage
- registerPushMessageNotificationCallback
- appKey
- cleanResourceCacheCallback
- trackHistory
- qiyuLogPath
### Event Method
- onButtonClickCallback
- onURLClickCallback
- onBotClickCallback
- onQuitWaitingCallback
- onPushMessageClickCallback
- onBotCustomInfoCallback
- onUnreadCountChanged
- onSessionListChanged
- onReceiveMessage

### 方法接口描述

#### * registerAppId
注册七鱼SDK
```
register(appKey, appName)
```
##### params
| 参数名  | 类型       | 默认值 | 描述                  |
| :------ | :--------- | :----- | :-------------------- |
| appKey  | 字符串类型 | 无     | 七鱼管理后台的appKey  |
| appName | 字符串类型 | 无     | 七鱼管理后台的App名称 |

##### 示例代码
```
Qiyu().register(appKey, appName)
```
##### 注意事项
建议在应用启动时初始化，初始化之前无法使用此模块的其他方法。七鱼模块只需要初始化一次。代码如下
```
void initState() {
    super.initState();
    Qiyu().register('七鱼管理后台的appKey', '七鱼管理后台的App名称')
}
```
#### * logout
注销当前账号
```
logout()
```
##### 示例代码
```
QiYu.logout();
```
#### * openServiceWindow
启动客服聊天窗口
```
openServiceWindow(params)
```
##### params
‘>’代表下一层级，'>>'代表下下一层级 

| 参数名                | 类型       | 默认值 | 描述                                                         |
| :-------------------- | :--------- | :----- | :----------------------------------------------------------- |
| source                | JSON对象   | 无     | 会话窗口来源                                                 |
| >title                 | 字符串类型 | 无     | 会话窗口来源标题                                             |
| >urlString             | 字符串类型 | 无     | 会话窗口来源URL                                              |
| >customInfo            | 字符串类型 | 无     | 会话窗口来源自定义消息                                       |
| commodityInfo         | JSON对象   | 无     | 商品详情信息                                                 |
| >title                | 字符串类型 | 无     | 商品详情信息展示商品标题，字符数要求小于100                  |
| >desc                 | 字符串类型 | 无     | 商品详情信息展示商品描述，字符数要求小于300                  |
| >pictureUrlString     | 字符串类型 | 无     | 商品详情信息展示商品图片URL，字符数要求小于1000              |
| >urlString            | 字符串类型 | 无     | 商品详情信息展示跳转URL，字符数要求小于1000                  |
| >note                 | 字符串类型 | 无     | 商品详情信息展示备注信息，可以显示价格、订单号等，字符数要求小于100 |
| >show                 | 布尔类型   | false  | 商品详情信息展示发送时是否要在用户端显示，默认不显示         |
| >tagsArray			|数组类型     |无|自定义商品信息按钮数组，最多显示三个按钮|
| >>label			|字符串类型     |无|文案显示|
| >>url			|字符串类型     |无|链接|
| >>focusIframe			|字符串类型     |无|无|
| >>data			|字符串类型     |无|无|
| >tagsString                 | 字符串类型    | 无  | 自定义商品信息按钮数组，最多显示三个按钮;NSString *类型，跟上面的数组类型二选一|
| >show                 | 布尔类型   | false  | 商品详情信息展示发送时是否要在用户端显示，默认不显示         |
| >isCustom                 | 布尔类型   | false  | 自定义的话，只有pictureUrlString、urlString有效，只显示一张图片|
| >actionText                 | 字符串类型    | 无  | 发送按钮文案|
| >actionTextColor                 | 字符串类型    | 无  | 发送按钮文案颜色|
| >ext                 | 字符串类型    | 无  | 一般用户不需要填这个字段，这个字段仅供特定用户使用|
| sessionTitle          | 字符串类型 | 无     | 客服会话窗口标题|
| staffId               | long类型   | 无     | 指定客服id，如果同时指定 staffId 和 groupId，以 staffId 为准，忽略 groupId |
| groupId               | long类型   | 无     | 指定客服分组id，如果同时指定 staffId 和 groupId，以 staffId 为准，忽略 groupId |
| robotId               | long类型   | 无     | 多机器人接入后，可指定机器人id，进入聊天界面时，会直接以此 id 去请求到对应的机器人 |
| vipLevel              | long类型   | 无     | 设置访客的vip等级                                            |
| openRobotInShuntMode            | 布尔类型   | false  | 指定访客分流是否开启机器人，如果开启机器人，则选择客服或者客服分组之后，先进入机器人模式 |
| commonQuestionTemplateId         | long类型   | 无     | 在机器人开启状态下，指定常见问题模版ID，进入聊天界面时，会下发该ID对应的常见问题模版 |
| showCloseSessionEntry | 布尔类型   | false  | 是否在界面显示关闭会话入口                                   |
| showQuitQueue         | 布尔类型   | false  | 是否在界面显示退出排队入口，以及在退出时显示退出排队提示     |
| buttonInfoArray         | 数组类型   | 无  | 输入区域上方工具栏内的按钮信息|
| >buttonId          | 字符串类型 | 无     | |
| >title          | 字符串类型 | 无     | |
| >userData          | 字符串类型 | 无     | |

##### 示例代码
```
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
    'showCloseSessionEntry':true,
    'showQuitQueue':true
  };
Qiyu().openServiceWindow(_defaultSessionConfig);
```
#### * sendCommodityInfo
主动发送商品信息
```
sendCommodityInfo(params)
```
##### params
| 参数名                    | 类型                                                         | 默认值 | 描述                                                         |
| :------------------------ | :----------------------------------------------------------- | :----- | :----------------------------------------------------------- |
| commodityInfo         | JSON对象   | 无     | 商品详情信息                                                 |
| >title                | 字符串类型 | 无     | 商品详情信息展示商品标题，字符数要求小于100                  |
| >desc                 | 字符串类型 | 无     | 商品详情信息展示商品描述，字符数要求小于300                  |
| >pictureUrlString     | 字符串类型 | 无     | 商品详情信息展示商品图片URL，字符数要求小于1000              |
| >urlString            | 字符串类型 | 无     | 商品详情信息展示跳转URL，字符数要求小于1000                  |
| >note                 | 字符串类型 | 无     | 商品详情信息展示备注信息，可以显示价格、订单号等，字符数要求小于100 |
| >show                 | 布尔类型   | false  | 商品详情信息展示发送时是否要在用户端显示，默认不显示         |
| >tagsArray			|数组类型     |无|自定义商品信息按钮数组，最多显示三个按钮|
| >>label			|字符串类型     |无|文案显示|
| >>url			|字符串类型     |无|链接|
| >>focusIframe			|字符串类型     |无|无|
| >>data			|字符串类型     |无|无|
| >tagsString                 | 字符串类型    | 无  | 自定义商品信息按钮数组，最多显示三个按钮;NSString *类型，跟上面的数组类型二选一|
| >show                 | 布尔类型   | false  | 商品详情信息展示发送时是否要在用户端显示，默认不显示         |
| >isCustom                 | 布尔类型   | false  | 自定义的话，只有pictureUrlString、urlString有效，只显示一张图片|
| >actionText                 | 字符串类型    | 无  | 发送按钮文案|
| >actionTextColor                 | 字符串类型    | 无  | 发送按钮文案颜色|
| >ext                 | 字符串类型    | 无  | 一般用户不需要填这个字段，这个字段仅供特定用户使用|
##### 示例代码
```
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
```
#### * setCustomUIConfig
自定义客服聊天窗口UI
```
setCustomUIConfig(params)
```
##### params

| 参数名                    | 类型                                                         | 默认值 | 描述                                                         |
| :------------------------ | :----------------------------------------------------------- | :----- | :----------------------------------------------------------- |
| navBackgroundColor | 字符串类型，如'#CC00FF'| 无| 导航栏背景颜色 |
| viewBackButtonColor | 字符串类型，如'#CC00FF'| 无 | 返回按钮颜色|
| viewBackButtonText| 字符串类型，如'#CC00FF'| 无 |返回按钮文本|
| sessionTipTextColor       | 字符串类型，如'#CC00FF'  | 无     | 会话窗口上方提示条中的文本字体颜色  |
| sessionTipTextFontSize    | int类型，如15 | 无     | 会话窗口上方提示条中的文本字体大小 |
| sessionTipBackgroundColor    | i字符串类型，如'#CC00FF' | 无     | 会话窗口上方提示条中的背景颜色 |
| customMessageTextColor    | 字符串类型，如'#CC00FF'| 无     | 访客文本消息字体颜色 |
| customMessageHyperLinkColor    | 字符串类型，如'#CC00FF'| 无     | 访客文本消息中的链接字体颜色 |
| customMessageTextFontSize    | int类型，如15 | 无     | 访客文本消息字体大小 |
| serviceMessageTextColor   | 字符串类型，如'#CC00FF'| 无     | 客服文本消息字体颜色 |
| serviceMessageHyperLinkColor    | 字符串类型，如'#CC00FF'| 无     | 客服文本消息中的链接字体颜色 |
| serviceMessageTextFontSize    | int类型，如15 | 无     | 客服文本消息字体大小 |
| tipMessageTextColor       | 字符串类型，如'#CC00FF'                                      | 无     | 提示文本消息字体颜色 |
| tipMessageTextFontSize    | int类型，如15                                                | 无     | 提示文本消息字体大小 |
| inputTextColor            | 字符串类型，如'#CC00FF'                                      | 无     | 输入框文本字体颜色 |
| inputTextFontSize         | int类型，如15                                                | 无     | 输入框文本字体大小 |
| sessionBackgroundImage    | [\*]字符串类型，传入图片的绝对路径，如'images/session_bg.png' | 无     | 客服聊天窗口背景图片 |
| customerHeadImage         | [\*]字符串类型，传入图片的绝对路径                           | 无     | 访客头像  |
| serviceHeadImage          | [\*]字符串类型，传入图片的绝对路径                           | 无     | 客服头像 |
| customerMessageBubbleNormalImage          | [\*]字符串类型，传入图片的绝对路径                           | 无     | 访客消息气泡normal图片 |
| customerMessageBubblePressedImage          | [\*]字符串类型，传入图片的绝对路径                           | 无     | 访客消息气泡pressed图片 |
| serviceMessageBubbleNormalImage          | [\*]字符串类型，传入图片的绝对路径                           | 无     | 客服消息气泡normal图片 |
| serviceMessageBubblePressedImage          | [\*]字符串类型，传入图片的绝对路径                           | 无     | 客服消息气泡pressed图片 |
| actionButtonTextColor       | 字符串类型，如'#CC00FF'| 无     | 输入框上方操作按钮文字颜色 |
| actionButtonBorderColor       | 字符串类型，如'#CC00FF'| 无     | 输入框上方操作按钮边框颜色 |
| sessionMessageSpacing     | float类型，如3.5 | 无     | 消息竖直方向间距 |
| showHeadImage             | 布尔类型  | true   | 是否显示头像 |
| rightBarButtonItemColorBlackOrWhite | 布尔类型| true   | 默认是YES,默认rightBarButtonItem内容是黑色，设置为NO，可以修改为白色 |
| showAudioEntry            | 布尔类型| true   | 是否显示发送语音入口，设置为false，可以修改为隐藏|
| showAudioEntryInRobotMode            | 布尔类型| true   | 默认是YES,默认在机器人模式下显示发送语音入口，设置为NO，可以修改为隐藏|
| showEmoticonEntry| 布尔类型| true   | 是否显示发送表情入口，设置为false，可以修改为隐藏 |
| showImageEntry| 布尔类型| true   | 默认是YES,默认显示发送图片入口，设置为NO，可以修改为隐藏 |
| autoShowKeyboard    | 布尔类型 | true   | 进入聊天界面，是文本输入模式的话，会弹出键盘，设置为false，可以修改为不弹出 |
| bottomMargin     | float类型，如10.0 | 无     | 表示聊天组件离界面底部的间距，默认是0；比较典型的是底部有tabbar，这时候设置为tabbar的高度即可 |
| showCloseSessionEntry    | 布尔类型 | false   | 默认是NO,默认隐藏关闭会话入口，设置为YES，可以修改为显示 |
| bypassDisplayMode     | int类型，如10.0 | 无     | 访客分流展示模式0-None, 1-Center, 2-Bottom |

- **注意**
  为了防止 Flutter 在打包时将用于七鱼的图片文件过滤掉，我们需要将用于七鱼的图片文件在```pubspec.yaml``` 文件添加引用，如

```
assets:
   - images/
```

##### 示例代码

```
var config = {
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
Qiyu().setCustomUIConfig(config));
```
#### * restoreCustomUIConfigToDefault
回复自定义聊天窗口UI到默认值
```
restoreCustomUIConfigToDefault()
```
##### 示例代码
```
Qiyu().restoreCustomUIConfigToDefault();
```
#### * setDeactivateAudioSessionAfterComplete
设置录制或者播放语音完成以后是否自动deactivate AVAudioSession
```
setDeactivateAudioSessionAfterComplete(config)
```
##### 示例代码
```
Qiyu().setDeactivateAudioSessionAfterComplete({'deactivate': true});
```
#### * getUnreadCount
获取未读消息数
```
getUnreadCount()
```
##### 示例代码
```
Qiyu().getUnreadCount().then((value) =>print(value));
```
#### * clearUnreadCount
清除未读消息数
```
clearUnreadCount()
```
##### 示例代码
```
Qiyu().clearUnreadCount();
```
#### * getSessionList
获取消息列表
```
getSessionList()
```
##### 示例代码
```
Qiyu().getSessionList().then((value) =>print(value));
```
#### * setUserInfo
用于设置CRM个人信息
```
setUserInfo(params)
```
##### params
| 参数名 | 类型       | 默认值 | 描述             |
| :----- | :--------- | :----- | :--------------- |
| userId | 字符串类型 | 无     | 个人账号Id       |
| data   | 字符串类型 | 无     | 用户详细信息json |
##### 示例代码
```
  var params = {
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
QiYu().setUserInfo(params);
```
#### * setAuthToken
设置authToken
```
setAuthToken(params)
```
##### params
| 参数名 | 类型       | 默认值 | 描述             |
| :----- | :--------- | :----- | :--------------- |
| authToken | 字符串类型 | 无     | authToken      |
##### 示例代码
```
  Qiyu().setAuthToken({'authToken':'1111111111'});
```
#### * getPushMessage
获取推送消息
```
getPushMessage(params)
```
##### params
| 参数名 | 类型       | 默认值 | 描述             |
| :----- | :--------- | :----- | :--------------- |
| messageId | 字符串类型 | 无     | messageId      |
##### 示例代码
```
  Qiyu().getPushMessage({'messageId': '1111111111'});
```
#### * appKey
获取AppKey
```
appKey()
```
##### 示例代码
```
  Qiyu().appKey().then((value) =>print(value));
```
#### * cleanResourceCacheCallback
清理接收文件缓存
```
cleanResourceCacheCallback()
```
##### 示例代码
```
  Qiyu().cleanResourceCacheCallback().then((value) =>print(value));
```
#### * cleanResourceCacheCallback
清理接收文件缓存
```
cleanResourceCacheCallback()
```
##### 示例代码
```
  Qiyu().cleanResourceCacheCallback().then((value) =>print(value));
```
#### * trackHistory
设置访问轨迹
```
trackHistory(params)
```
##### params
| 参数名    | 类型       | 默认值 | 描述                                                         |
| :-------- | :--------- | :----- | :----------------------------------------------------------- |
| title | 字符串类型 | 无     | 标题 |
|enterOrOut  | Bool类型  | 无     | 进入还是退出|
|key  | 字符串类型  | 无     | key|
##### 示例代码
```
   Qiyu().trackHistory({'title': 'lalala', 'enterOrOut': true, 'key': 'key'});
```
#### * qiyuLogPath
获取七鱼log文件路径
```
qiyuLogPath()
```
##### 示例代码
```
  Qiyu().qiyuLogPath().then((value) =>print(value));
```
### 事件接口描述

#### * onButtonClickCallback
输入区域上方工具栏内的按钮点击回调
```
onButtonClickCallback()
```
##### params
| 参数名    | 类型       | 默认值 | 描述 |
| :-------- | :--------- | :----- | :----------------------------------------------------------- |
| buttonId | 字符串类型 | 无     | buttonId |
| title  | Event对象  | 无     | 标题 |
| userData  | Event对象  | 无     | 用户数据|
##### 示例代码
```
Qiyu().onButtonClickCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onURLClickCallback
所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）
```
onURLClickCallback()
```
##### 示例代码
```
Qiyu().onURLClickCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onBotClickCallback
bot相关点击
```
onBotClickCallback()
```
##### 示例代码
```
Qiyu().onBotClickCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onQuitWaitingCallback
显示退出排队提示，0-当前不是在排队状态，1-继续排队，2-退出排队，3-取消操作
```
onQuitWaitingCallback()
```
##### 示例代码
```
Qiyu().onQuitWaitingCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onPushMessageClickCallback
推送消息相关点击
```
onPushMessageClickCallback()
```
##### 示例代码
```
Qiyu().onPushMessageClickCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onBotCustomInfoCallback
显示bot自定义信息
```
onBotCustomInfoCallback()
```
##### 示例代码
```
Qiyu().onBotCustomInfoCallback().listen((dynamic data) {
      print(data);
    });
```
#### * onUnreadCountChanged
会话未读数变化
```
onUnreadCountChanged()
```
##### 示例代码
```
Qiyu().onUnreadCountChanged().listen((dynamic data) {
      print(data);
    });
```
#### * onSessionListChanged
会话列表变化；非平台电商用户，只有一个会话项，平台电商用户，有多个会话项
```
onSessionListChanged()
```
##### 示例代码
```
Qiyu().onSessionListChanged().listen((dynamic data) {
      print(data);
    });
```
#### * onReceiveMessage
收到消息
```
onReceiveMessage()
```
##### 示例代码
```
Qiyu().onReceiveMessage().listen((dynamic data) {
      print(data);
    });
```