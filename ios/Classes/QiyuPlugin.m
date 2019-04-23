#import "QiyuPlugin.h"
#import <QYSDK.h>

static NSString *const CHANNEL_NAME = @"plugins.lazyyuuuuu.io/qiyu";
static NSString *const EVENT_CHANNEL_NAME = @"plugins.lazyyuuuuu.io/event_qiyu";

@interface QiyuPlugin ()<FlutterStreamHandler, QYConversationManagerDelegate>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIColor *navBackgroundColor;
@property (nonatomic, strong) UIColor *viewBackButtonColor;
@property (nonatomic, strong) NSString *viewBackButtonText;
@property (nonatomic, strong, readonly) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, copy) FlutterEventSink buttonClickCallbackEvent;
@property (nonatomic, copy) FlutterEventSink onURLClickCallbackEvent;
@property (nonatomic, copy) FlutterEventSink onBotClickCallbackEvent;
@property (nonatomic, copy) FlutterEventSink onQuitWaitingCallbackEvent;
@property (nonatomic, copy) FlutterEventSink onPushMessageClickCallbackEvent;
@property (nonatomic, copy) FlutterEventSink onBotCustomInfoCallbackEvent;
@property (nonatomic, copy) FlutterEventSink unreadCountChangedEvent;
@property (nonatomic, copy) FlutterEventSink sessionListChangedEvent;
@property (nonatomic, copy) FlutterEventSink receiveMessageEvent;

@end

@implementation QiyuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME binaryMessenger:[registrar messenger]];
    QiyuPlugin* instance = [[QiyuPlugin alloc] initWithRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:EVENT_CHANNEL_NAME binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    NSAssert(self, @"super init cannot be nil");
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"register" isEqualToString:call.method]) {
        NSString *appKey = arguments[@"appKey"];
        NSString *appName = arguments[@"appName"];
        [[QYSDK sharedSDK] registerAppId:appKey appName:appName];
        result(nil);
    }
    else if ([@"logout" isEqualToString:call.method]) {
        [[QYSDK sharedSDK] logout:^{
            result(nil);
        }];
    }
    else if ([@"openServiceWindow" isEqualToString:call.method]) {
        NSString *sessionTitle = arguments[@"sessionTitle"];
        int64_t groupId = [arguments[@"groupId"] longLongValue];
        int64_t staffId = [arguments[@"staffId"] longLongValue];
        int64_t robotId = [arguments[@"robotId"] longLongValue];
        NSInteger vipLevel = [arguments[@"vipLevel"] integerValue];
        BOOL openRobotInShuntMode = [arguments[@"openRobotInShuntMode"] boolValue];
        int64_t commonQuestionTemplateId = [arguments[@"commonQuestionTemplateId"] longLongValue];
        NSDictionary *sourceDict = arguments[@"source"];
        NSDictionary *commodityInfoDict = arguments[@"commodityInfo"];
        NSArray<NSDictionary *> *buttonInfoList = arguments[@"buttonInfoArray"];
        QYSource *source = nil;
        if (sourceDict && [sourceDict isKindOfClass:[NSDictionary class]]) {
            source = [QYSource new];
            source.title = sourceDict[@"title"] ? : @"";
            source.urlString = sourceDict[@"urlString"] ? : @"";
            source.customInfo = sourceDict[@"customInfo"] ? : @"";
        }
        QYCommodityInfo *commodityInfo = nil;
        if (commodityInfoDict && [commodityInfoDict isKindOfClass:[NSDictionary class]]) {
            commodityInfo = [self getCommodityInfoWithDict:commodityInfoDict];
        }
        NSMutableArray<QYButtonInfo *> *buttonInfoArray = [NSMutableArray arrayWithCapacity:buttonInfoList.count];
        if (buttonInfoList.count) {
            [buttonInfoList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QYButtonInfo *buttonInfo = [QYButtonInfo new];
                buttonInfo.buttonId = obj[@"buttonId"];
                buttonInfo.title = obj[@"title"] ? : @"";
                buttonInfo.userData = obj[@"userData"];
                [buttonInfoArray addObject:buttonInfo];
            }];
        }
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = sessionTitle;
        sessionViewController.groupId = groupId;
        sessionViewController.staffId = staffId;
        sessionViewController.robotId = robotId;
        sessionViewController.vipLevel = vipLevel;
        sessionViewController.openRobotInShuntMode = openRobotInShuntMode;
        sessionViewController.commonQuestionTemplateId = commonQuestionTemplateId;
        sessionViewController.source = source;
        sessionViewController.commodityInfo = commodityInfo;
        sessionViewController.buttonInfoArray = [buttonInfoArray copy];
        sessionViewController.buttonClickBlock = ^(QYButtonInfo *action) {
            if (self.buttonClickCallbackEvent) {
                self.buttonClickCallbackEvent(@{@"buttonId": action.buttonId ? : @"",
                                                @"title": action.title ? : @"",
                                                @"userData": action.userData ? : @""});
            }
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
        self.nav = nav;
        if (self.navBackgroundColor) {
            nav.navigationBar.barTintColor = self.navBackgroundColor;
        }
        sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.viewBackButtonText ? : @"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onTapBack:)];
        if (self.viewBackButtonColor) {
            sessionViewController.navigationItem.leftBarButtonItem.tintColor = self.viewBackButtonColor;
        }
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        result(nil);
    }
    else if ([@"sendCommodityInfo" isEqualToString:call.method]) {
        NSDictionary *commodityDict = arguments[@"commodityInfo"];
        if (commodityDict && [commodityDict isKindOfClass:[NSDictionary class]]) {
            QYCommodityInfo *commodityInfo = [self getCommodityInfoWithDict:commodityDict];
            [[[QYSDK sharedSDK] sessionViewController] sendCommodityInfo:commodityInfo];
        }
        result(nil);
    }
    else if ([@"sendSelectedCommodityInfo" isEqualToString:call.method]) {
        NSDictionary *selectedCommodityDict = arguments[@"selectedCommodityInfo"];
        if (selectedCommodityDict && [selectedCommodityDict isKindOfClass:[NSDictionary class]]) {
            QYSelectedCommodityInfo *selectedCommodityInfo = [QYSelectedCommodityInfo new];
            selectedCommodityInfo.target = selectedCommodityDict[@"target"] ? : @"";
            selectedCommodityInfo.params = selectedCommodityDict[@"params"] ? : @"";
            selectedCommodityInfo.p_status = selectedCommodityDict[@"p_status"] ? : @"";
            selectedCommodityInfo.p_img = selectedCommodityDict[@"p_img"] ? : @"";
            selectedCommodityInfo.p_name = selectedCommodityDict[@"p_name"] ? : @"";
            selectedCommodityInfo.p_price = selectedCommodityDict[@"p_price"] ? : @"";
            selectedCommodityInfo.p_count = selectedCommodityDict[@"p_count"] ? : @"";
            selectedCommodityInfo.p_stock = selectedCommodityDict[@"p_stock"] ? : @"";
            [[[QYSDK sharedSDK] sessionViewController] sendSelectedCommodityInfo:selectedCommodityInfo];
        }
        result(nil);
    }
    else if ([@"setCustomUIConfig" isEqualToString:call.method]) {
        [self setCustomUIConfigWithDict:arguments];
        result(nil);
    }
    else if ([@"restoreCustomUIConfigToDefault" isEqualToString:call.method]) {
        [[[QYSDK sharedSDK] customUIConfig] restoreToDefault];
        result(nil);
    }
    else if ([@"setDeactivateAudioSessionAfterComplete" isEqualToString:call.method]) {
        BOOL deactivate = [arguments[@"deactivate"] boolValue];
        [[[QYSDK sharedSDK] customActionConfig] setDeactivateAudioSessionAfterComplete:deactivate];
        result(nil);
    }
    else if ([@"getUnreadCount" isEqualToString:call.method]) {
        result(@([[QYSDK sharedSDK] conversationManager].allUnreadCount));
    }
    else if ([@"clearUnreadCount" isEqualToString:call.method]) {
        [[[QYSDK sharedSDK] conversationManager] clearUnreadCount];
        result(nil);
    }
    else if ([@"getSessionList" isEqualToString:call.method]) {
        NSArray<QYSessionInfo *> *sessionList = [[[QYSDK sharedSDK] conversationManager] getSessionList];
        NSMutableArray *sessionArray = [NSMutableArray arrayWithCapacity:sessionList.count];
        [sessionList enumerateObjectsUsingBlock:^(QYSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [sessionArray addObject:@{@"lastMessageText": obj.lastMessageText ? : @"",
                                      @"lastMessageType": @(obj.lastMessageType),
                                      @"unreadCount": @(obj.unreadCount),
                                      @"status": @(obj.status),
                                      @"lastMessageTimeStamp": @(obj.lastMessageTimeStamp),
                                      @"hasTrashWords": @(obj.hasTrashWords)
                                      }];
        }];
        result(sessionArray);
    }
    else if ([@"setUserInfo" isEqualToString:call.method]) {
        NSString *userId = arguments[@"userId"];
        NSArray *dataArray = arguments[@"data"];
        if (userId.length || dataArray.count) {
            QYUserInfo *userInfo = [QYUserInfo new];
            userInfo.userId = userId;
            userInfo.data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil] encoding:NSUTF8StringEncoding];
            [[QYSDK sharedSDK] setUserInfo:userInfo];
        }
        result(nil);
    }
    else if ([@"setAuthToken" isEqualToString:call.method]) {
        NSString *authToken = arguments[@"authToken"];
        if (authToken.length) {
            [[QYSDK sharedSDK] setAuthToken:authToken];
        }
        result(nil);
    }
    else if ([@"setUserInfoWithVerificationResultCallback" isEqualToString:call.method]) {
        NSString *userId = arguments[@"userId"];
        NSString *data = arguments[@"data"];
        if (userId.length || data.length) {
            QYUserInfo *userInfo = [QYUserInfo new];
            userInfo.userId = userId;
            userInfo.data = data;
            [[QYSDK sharedSDK] setUserInfo:userInfo authTokenVerificationResultBlock:^(BOOL isSuccess) {
                result(@(isSuccess));
            }];
        } else {
            result([FlutterError errorWithCode:@"" message:@"参数错误" details: nil]);
        }
    }
    else if ([@"getPushMessage" isEqualToString:call.method]) {
        NSString *messageId = arguments[@"messageId"];
        if (messageId.length) {
            [[QYSDK sharedSDK] getPushMessage:messageId];
        }
        result(nil);
    }
    else if ([@"registerPushMessageNotificationCallback" isEqualToString:call.method]) {
        [[QYSDK sharedSDK] registerPushMessageNotification:^(QYPushMessage *message) {
            result(@{@"type": @(message.type),
                     @"headImageUrl": message.headImageUrl ? : @"",
                     @"actionText": message.actionText ? : @"",
                     @"actionUrl": message.actionUrl ? : @"",
                     @"text": message.text ? : @"",
                     @"richText": message.richText ? : @"",
                     @"imageUrl": message.imageUrl ? : @"",
                     @"time": @(message.time)
                     });
        }];
    }
    else if ([@"getappKey" isEqualToString:call.method]) {
        result([[QYSDK sharedSDK] appKey]);
    }
    else if ([@"cleanResourceCacheCallback" isEqualToString:call.method]) {
        [[QYSDK sharedSDK] cleanResourceCacheWithBlock:^(NSError *error) {
            if (error) {
                result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code] message:error.localizedDescription details:error.userInfo]);
            }
        }];
    }
    else if ([@"trackHistory" isEqualToString:call.method]) {
        NSString *title = arguments[@"title"] ? : @"";
        BOOL enterOrOut = [arguments[@"enterOrOut"] boolValue];
        NSString *key = arguments[@"key"] ? : @"";
        [[QYSDK sharedSDK] trackHistory:title enterOrOut:enterOrOut key:key];
        result(nil);
    }
    else if ([@"getQiyuLogPath" isEqualToString:call.method]) {
        result([[QYSDK sharedSDK]qiyuLogPath]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


#pragma mark - FlutterStreamHandler

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    if (![arguments isKindOfClass:[NSString class]]) {
        return [FlutterError errorWithCode:@"" message:@"arguments需要传入字符串！" details:nil];
    }
    if ([arguments isEqualToString:@"onButtonClickCallback"]) {
        self.buttonClickCallbackEvent = [events copy];
    }
    else if ([arguments isEqualToString:@"onURLClickCallback"]) {
        self.onURLClickCallbackEvent = [events copy];
        [[QYSDK sharedSDK] customActionConfig].linkClickBlock = ^(NSString *linkAddress) {
            if (self.onURLClickCallbackEvent) {
                self.onURLClickCallbackEvent(linkAddress);
            }
        };
    }
    else if ([arguments isEqualToString:@"onBotClickCallback"]) {
        self.onBotClickCallbackEvent = [events copy];
        [[QYSDK sharedSDK] customActionConfig].botClick = ^(NSString *target, NSString *params) {
            if (self.onBotClickCallbackEvent) {
                self.onBotClickCallbackEvent(@{@"target": target ? : @"",
                                                @"params": params ? : @""});
            }
        };
    }
    else if ([arguments isEqualToString:@"onQuitWaitingCallback"]) {
        self.onQuitWaitingCallbackEvent = [events copy];
        [[[QYSDK sharedSDK] customActionConfig] showQuitWaiting:^(QuitWaitingType quitType) {
            if (self.onQuitWaitingCallbackEvent) {
                self.onQuitWaitingCallbackEvent(@(quitType));
            }
        }];
    }
    else if ([arguments isEqualToString:@"onPushMessageClickCallback"]) {
        self.onPushMessageClickCallbackEvent = [events copy];
        [[QYSDK sharedSDK] customActionConfig].pushMessageClick = ^(NSString *linkAddress) {
            if (self.onPushMessageClickCallbackEvent) {
                self.onPushMessageClickCallbackEvent(linkAddress);
            }
        };
    }
    else if ([arguments isEqualToString:@"onBotCustomInfoCallback"]) {
        self.onBotCustomInfoCallbackEvent = [events copy];
        [[QYSDK sharedSDK] customActionConfig].showBotCustomInfoBlock = ^(NSArray *array) {
            if (self.onBotCustomInfoCallbackEvent) {
                self.onBotCustomInfoCallbackEvent(array);
            }
        };
    }
    else if ([arguments isEqualToString:@"onUnreadCountChanged"]) {
        [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
        self.unreadCountChangedEvent = [events copy];
    }
    else if ([arguments isEqualToString:@"onSessionListChanged"]) {
        [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
        self.sessionListChangedEvent = [events copy];
    }
    else if ([arguments isEqualToString:@"onReceiveMessage"]) {
        [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
        self.receiveMessageEvent = [events copy];
    }
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    if (arguments[@"onButtonClickCallback"]) {
        self.buttonClickCallbackEvent = nil;
    }
    else if (arguments[@"onURLClickCallback"]) {
        self.onURLClickCallbackEvent = nil;
    }
    else if (arguments[@"onBotClickCallback"]) {
        self.onBotClickCallbackEvent = nil;
    }
    else if (arguments[@"onQuitWaitingCallback"]) {
        self.onQuitWaitingCallbackEvent = nil;
    }
    else if (arguments[@"onPushMessageClickCallback"]) {
        self.onPushMessageClickCallbackEvent = nil;
    }
    else if (arguments[@"onBotCustomInfoCallback"]) {
        self.onBotCustomInfoCallbackEvent = nil;
    }
    else if (arguments[@"onUnreadCountChanged"]) {
        self.unreadCountChangedEvent = nil;
    }
    else if (arguments[@"onSessionListChanged"]) {
        self.sessionListChangedEvent = nil;
    }
    else if (arguments[@"onReceiveMessage"]) {
        self.receiveMessageEvent = nil;
    }
    return nil;
}

#pragma mark - AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

#pragma mark - Events & Action

- (void)onTapBack:(id)sender {
    [self.nav dismissViewControllerAnimated:YES completion:^{
        self.nav = nil;
    }];
}

#pragma mark - QYConversationManagerDelegate

- (void)onUnreadCountChanged:(NSInteger)count {
    if (self.unreadCountChangedEvent) {
        self.unreadCountChangedEvent(@(count));
    }
}

- (void)onSessionListChanged:(NSArray<QYSessionInfo *> *)sessionList {
    if (self.sessionListChangedEvent) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:sessionList.count];
        [sessionList enumerateObjectsUsingBlock:^(QYSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:@{@"lastMessageText": obj.lastMessageText ? : @"",
                               @"lastMessageType": @(obj.lastMessageType),
                               @"unreadCount": @(obj.unreadCount),
                               @"status": @(obj.status),
                               @"lastMessageTimeStamp": @(obj.lastMessageTimeStamp),
                               @"hasTrashWords": @(obj.hasTrashWords)}];
        }];
        self.sessionListChangedEvent(array);
    }
}

- (void)onReceiveMessage:(QYMessageInfo *)message {
    if (self.receiveMessageEvent) {
        self.receiveMessageEvent(@{@"text": message.text ? : @"",
                                   @"type": @(message.type),
                                   @"timeStamp": @(message.timeStamp)});
    }
}

#pragma mark - Private Methods

- (QYCommodityInfo *)getCommodityInfoWithDict:(NSDictionary *)commodityInfoDict {
    QYCommodityInfo *commodityInfo = [QYCommodityInfo new];
    commodityInfo.title = commodityInfoDict[@"title"] ? : @"";
    commodityInfo.desc = commodityInfoDict[@"desc"] ? : @"";
    commodityInfo.pictureUrlString = commodityInfoDict[@"pictureUrlString"] ? : @"";
    commodityInfo.urlString = commodityInfoDict[@"urlString"] ? : @"";
    commodityInfo.note = commodityInfoDict[@"note"] ? : @"";
    commodityInfo.show = [commodityInfoDict[@"show"] boolValue] ? : NO;
    NSArray<NSDictionary *> *tagsList = commodityInfoDict[@"tagsArray"];
    if (tagsList.count) {
        NSMutableArray<QYCommodityTag *> *tagsArray = [NSMutableArray arrayWithCapacity:tagsList.count];
        [tagsList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QYCommodityTag *tag = [QYCommodityTag new];
            tag.label = obj[@"label"] ? : @"";
            tag.url = obj[@"url"] ? : @"";
            tag.focusIframe = obj[@"focusIframe"] ? : @"";
            tag.data = obj[@"data"] ? : @"";
            [tagsArray addObject:tag];
        }];
        commodityInfo.tagsArray = [tagsArray copy];
    }
    commodityInfo.tagsString = commodityInfoDict[@"tagsString"] ? : @"";
    commodityInfo.isCustom = [commodityInfoDict[@"isCustom"] boolValue] ? : NO;
    commodityInfo.sendByUser = [commodityInfoDict[@"sendByUser"] boolValue] ? : NO;
    commodityInfo.actionText = commodityInfoDict[@"actionText"] ? : @"";
    commodityInfo.actionTextColor = [self colorFromString:commodityInfoDict[@"actionTextColor"] ? : @""];
    commodityInfo.ext = commodityInfoDict[@"ext"] ? : @"";
    
    return commodityInfo;
}

- (void)setCustomUIConfigWithDict:(NSDictionary *)arguments {
    if (arguments[@"navBackgroundColor"]) {
        self.navBackgroundColor = [self colorFromString:arguments[@"navBackgroundColor"] ? : @""];
    }
    if (arguments[@"viewBackButtonText"]) {
        self.viewBackButtonText = arguments[@"viewBackButtonText"] ? : @"返回";
    }
    if (arguments[@"viewBackButtonColor"]) {
        self.viewBackButtonColor = [self colorFromString:arguments[@"viewBackButtonColor"] ? : @""];
    }
    if (arguments[@"sessionTipTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [self colorFromString:arguments[@"sessionTipTextColor"] ? : @""];
    }
    if (arguments[@"sessionTipTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipTextFontSize = [arguments[@"sessionTipTextFontSize"] floatValue];
    }
    if (arguments[@"sessionTipBackgroundColor"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = [self colorFromString:arguments[@"sessionTipBackgroundColor"] ? : @""];
    }
    if (arguments[@"customMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [self colorFromString:arguments[@"customMessageTextColor"] ? : @""];
    }
    if (arguments[@"customMessageHyperLinkColor"]) {
        [[QYSDK sharedSDK] customUIConfig].customMessageHyperLinkColor = [self colorFromString:arguments[@"customMessageHyperLinkColor"] ? : @""];
    }
    if (arguments[@"customMessageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].customMessageTextFontSize = [arguments[@"customMessageTextFontSize"] floatValue];
    }
    if (arguments[@"serviceMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [self colorFromString:arguments[@"serviceMessageTextColor"] ? : @""];
    }
    if (arguments[@"serviceMessageHyperLinkColor"]) {
        [[QYSDK sharedSDK] customUIConfig].serviceMessageHyperLinkColor = [self colorFromString:arguments[@"serviceMessageHyperLinkColor"] ? : @""];
    }
    if (arguments[@"serviceMessageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextFontSize = [arguments[@"serviceMessageTextFontSize"] floatValue];
    }
    if (arguments[@"tipMessageTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = [self colorFromString:arguments[@"tipMessageTextColor"] ? : @""];
    }
    if (arguments[@"tipMessageTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].tipMessageTextFontSize = [arguments[@"tipMessageTextFontSize"] floatValue];
    }
    if (arguments[@"inputTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].inputTextColor = [self colorFromString:arguments[@"inputTextColor"] ? : @""];
    }
    if (arguments[@"inputTextFontSize"]) {
        [[QYSDK sharedSDK] customUIConfig].inputTextFontSize = [arguments[@"inputTextFontSize"] floatValue];
    }
    if (arguments[@"sessionBackgroundImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"sessionBackgroundImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].sessionBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    if (arguments[@"customerHeadImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"customerHeadImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"serviceHeadImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"serviceHeadImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"customerMessageBubbleNormalImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"customerMessageBubbleNormalImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"customerMessageBubblePressedImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"customerMessageBubblePressedImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"serviceMessageBubbleNormalImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"serviceMessageBubbleNormalImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"serviceMessageBubblePressedImage"]) {
        NSString *assetPath = [_registrar lookupKeyForAsset:arguments[@"serviceMessageBubblePressedImage"] ? : @""];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        if (imagePath.length) {
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if (arguments[@"actionButtonTextColor"]) {
        [[QYSDK sharedSDK] customUIConfig].actionButtonTextColor = [self colorFromString:arguments[@"sessionTipTextColor"] ? : @""];
    }
    if (arguments[@"actionButtonBorderColor"]) {
        [[QYSDK sharedSDK] customUIConfig].actionButtonBorderColor = [self colorFromString:arguments[@"sessionTipTextColor"] ? : @""];
    }
    if (arguments[@"sessionMessageSpacing"]) {
        [[QYSDK sharedSDK] customUIConfig].sessionMessageSpacing = [arguments[@"sessionMessageSpacing"] floatValue];
    }
    if (arguments[@"showHeadImage"]) {
        [[QYSDK sharedSDK] customUIConfig].showHeadImage = [arguments[@"showHeadImage"] boolValue];
    }
    if (arguments[@"rightBarButtonItemColorBlackOrWhite"]) {
        [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = [arguments[@"rightBarButtonItemColorBlackOrWhite"] boolValue];
    }
    if (arguments[@"showAudioEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showAudioEntry = [arguments[@"showAudioEntry"] boolValue];
    }
    if (arguments[@"showAudioEntryInRobotMode"]) {
        [[QYSDK sharedSDK] customUIConfig].showAudioEntryInRobotMode = [arguments[@"showAudioEntryInRobotMode"] boolValue];
    }
    if (arguments[@"showEmoticonEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showEmoticonEntry = [arguments[@"showEmoticonEntry"] boolValue];
    }
    if (arguments[@"showImageEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showImageEntry = [arguments[@"showImageEntry"] boolValue];
    }
    if (arguments[@"autoShowKeyboard"]) {
        [[QYSDK sharedSDK] customUIConfig].autoShowKeyboard = [arguments[@"autoShowKeyboard"] boolValue];
    }
    if (arguments[@"bottomMargin"]) {
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = [arguments[@"bottomMargin"] floatValue];
    }
    if (arguments[@"showCloseSessionEntry"]) {
        [[QYSDK sharedSDK] customUIConfig].showCloseSessionEntry = [arguments[@"showCloseSessionEntry"] boolValue];
    }
    if (arguments[@"bypassDisplayMode"]) {
        [[QYSDK sharedSDK] customUIConfig].bypassDisplayMode = [arguments[@"bypassDisplayMode"] integerValue];
    }
}


#pragma mark - Public Methods

- (UIColor *)colorFromString:(NSString*)string
{
    //convert to lowercase
    string = [string lowercaseString];
    
    //try hex
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    switch ([string length])
    {
        case 0:
        {
            string = @"00000000";
            break;
        }
        case 3:
        {
            NSString *red = [string substringWithRange:NSMakeRange(0, 1)];
            NSString *green = [string substringWithRange:NSMakeRange(1, 1)];
            NSString *blue = [string substringWithRange:NSMakeRange(2, 1)];
            string = [NSString stringWithFormat:@"%1$@%1$@%2$@%2$@%3$@%3$@ff", red, green, blue];
            break;
        }
        case 6:
        {
            string = [string stringByAppendingString:@"ff"];
            break;
        }
        case 8:
        {
            //do nothing
            break;
        }
        default:
        {
            
#ifdef DEBUG
            
            //unsupported format
            NSLog(@"Unsupported color string format: %@", string);
#endif
            return nil;
        }
    }
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&rgba];
    
    CGFloat red = ((rgba & 0xFF000000) >> 24) / 255.0f;
    CGFloat green = ((rgba & 0x00FF0000) >> 16) / 255.0f;
    CGFloat blue = ((rgba & 0x0000FF00) >> 8) / 255.0f;
    CGFloat alpha = (rgba & 0x000000FF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
