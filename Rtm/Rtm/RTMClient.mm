//
//  RTMClient.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "RTMClient.h"
#import "RTMIPv6Adapter.h"
#import "Fpnn.h"
#import "FPNError.h"
#import "RTMClient+User.h"
#import <objc/runtime.h>
#import "RTMAudioTools.h"
#import "FPNetworkReachabilityManager.h"
#import "RTMClient+MessagesManager.h"
#import "RTMNetworkReachabilityShare.h"
#import "RtmErrorLog.h"
typedef NS_ENUM(NSInteger, RTMClientNetStatus){
    RTMClientNetStatusNoDetection = -1,
    RTMClientNetStatusNone = 0,
    RTMClientNetStatusReachableViaWWAN = 1,
    RTMClientNetStatusReachableWifi = 2
};

@interface RTMClient()


//netState
@property(nonatomic,assign)RTMClientNetStatus netStatus;
@property(nonatomic,strong)NSString * wifiAddress;

//relogin
@property(nonatomic,assign)BOOL autoRelogin;  //
@property(nonatomic,assign)int reloginNum;    //

//init
@property(nonatomic,strong)RTMClientConfig * config;

//login
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * language;
@property (nonatomic,strong)NSDictionary * attribute;
@property (nonatomic,copy)RTMLoginSuccessCallBack loginSuccess;
@property (nonatomic,copy)RTMLoginFailCallBack loginFail;
@property(nonatomic,assign)RTMClientConnectStatus connectStatus;
@property(nonatomic,assign)int loginTimeout;//auth 总计  超过则fail回调

//auth
@property(nonatomic,strong)FPNNTCPClient * authClient;
@property(nonatomic,strong)NSString * authEndPoint;
@property(nonatomic,assign)BOOL authFinish;//auth登录成功后 为YES

//ping
@property(nonatomic,strong)dispatch_source_t pingTimer;
@property(nonatomic,strong)NSDate * lastPingTime;

//file
@property(nonatomic,strong)NSCache * fileClientCache;

//duplicate message
@property(nonatomic,strong)NSCache * messageDuplicatedCache;

//messageId
@property(nonatomic,assign)int64_t  messageId;

//是否触发 fpn close回调标识 kickout  切网   bye   主动close 飞行模式 不处理close回调   只有ping超时2分钟处理
@property(nonatomic,assign)BOOL isOverlookFpnnCloseCallBack;
@end

@implementation RTMClient


+ (nullable instancetype)clientWithEndpoint:(nonnull NSString * )endpoint
                                  projectId:(int64_t)projectId
                                     userId:(int64_t)userId
                                   delegate:(id<RTMProtocol>)delegate
                                     config:(nullable RTMClientConfig *)config
                                autoRelogin:(BOOL)autoRelogin{
    
    FPNSLog(@"%s",__FUNCTION__);
    if (endpoint == nil || endpoint.length == 0 || projectId == 0 || userId == 0) {
        FPNSLog(@"rtm init client invalid parameter");
        RtmFpnnErrorLog(([NSString stringWithFormat:@"rtm init client invalid parameter  (pid:%lld)",projectId]))
        return nil;
    }
    
    RTMClient * client = [[RTMClient alloc] initWithEndpoint:endpoint
                                                   projectId:projectId
                                                      userId:userId
                                                    delegate:delegate
                                                      config:config
                                                 autoRelogin:autoRelogin];
   
    return client;
    
}
+(NSString*)getSdkVersion{
    return @"iOS_2.7.0";
}
- (instancetype)initWithEndpoint:(NSString * _Nonnull)endpoint
                       projectId:(int64_t)projectId
                          userId:(int64_t)userId
                        delegate:(id<RTMProtocol>)delegate
                          config:(RTMClientConfig *)config
                     autoRelogin:(BOOL)autoRelogin{
    
    FPNSLog(@"%s",__FUNCTION__);
    self = [super init];
    if (self) {
        
        _netStatus = RTMClientNetStatusNoDetection;
        _authEndPoint = endpoint;
        _projectId = projectId;
        _userId = userId;
        _config = config;
        _autoRelogin = autoRelogin;
        _sdkVersion = @"iOS_2.7.0";
        _apiVersion = @"2.7.0";
        _reloginNum = 0;
        _connectStatus = RTMClientConnectStatusConnectClosed;
        _delegate = delegate;
        _messageId = 0;
        _fileClientCache = [[NSCache alloc]init];
        _fileClientCache.countLimit = 10;
        
        if (config == nil) {
            
            RTMClientConfig * config = [RTMClientConfig new];
            config.sendQuestTimeout = 30;
            config.fileQuestTimeout = 60;
            config.translateTimeout = 120;
            _clientConfig = config;
            
        }else{
            
            _clientConfig = config;
            if (_clientConfig.sendQuestTimeout <= 0 ) {
                _clientConfig.sendQuestTimeout = 30;
            }
            if (_clientConfig.fileQuestTimeout <= 0 ) {
                _clientConfig.fileQuestTimeout = 60;
            }
            if (_clientConfig.translateTimeout <= 0 ) {
                _clientConfig.translateTimeout = 120;
            }
            
        }
        
        [self _startNetMonitor];
        [RtmErrorLog registerClient:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        
    }
    
    return self;
    
}
//-(void)didEnterBackground{
//    NSLog(@"didEnterBackgrounddidEnterBackgrounddidEnterBackground");
//}
-(void)didBecomeActive{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        if (self.netStatus == RTMClientNetStatusReachableWifi && self.authFinish && self.currentConnectStatus == RTMClientConnectStatusConnected) {
        NSString * currentWifiAddress = [self getIPAddress];
        if ([self.wifiAddress isEqualToString:currentWifiAddress] == NO && [currentWifiAddress isEqualToString:@"error"] == NO) {
//                NSLog(@"wifi 切换  %@",currentWifiAddress);
                [self.fileClientCache removeAllObjects];
                self.isOverlookFpnnCloseCallBack = YES;
                self.wifiAddress =  currentWifiAddress;
                [self _closeConnectHandle:NO];
                [self _getDelegateToRelogin];
            }
            
        }
    }
    
}
- (void)loginWithToken:(NSString * _Nonnull)token
              language:(NSString * _Nullable)language
             attribute:(NSDictionary * _Nullable)attribute
               timeout:(int)timeout
               success:(RTMLoginSuccessCallBack)loginSuccess
           connectFail:(RTMLoginFailCallBack)loginFail{
    
    FPNSLog(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @synchronized (self) {
            if (self.connectStatus != RTMClientConnectStatusConnectClosed) {
                FPNSLog(@"rtm loginWithToken error , client is connected or connecting");
                RtmFpnnErrorLog(([NSString stringWithFormat:@"rtm loginWithToken error , client is connected or connecting  (pid:%lld)",self.projectId]))
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(rtmReloginCompleted:reloginCount:reloginResult:error:)] == NO ||
                [self.delegate respondsToSelector:@selector(rtmReloginWillStart:reloginCount:)] == NO)  {
                FPNSLog(@"rtm loginWithToken error , no implement RTMProtocol required delegate methods");
                RtmFpnnErrorLog(([NSString stringWithFormat:@"rtm loginWithToken error , no implement RTMProtocol required delegate methods  (pid:%lld)",self.projectId]))
                return;
            }
            
            if (token == nil || token.length == 0) {
                if (loginFail) {
                    loginFail([FPNError errorWithEx:@"RTM_EC_INVALID_AUTH_TOEKN" code:200027]);
                }
                FPNSLog(@"rtm loginWithToken error , invalid token");
                RtmFpnnErrorLog(([NSString stringWithFormat:@"rtm loginWithToken error , invalid token  (pid:%lld)",self.projectId]))
                return;
            }
            
        
            self.token = token;
            self.language = language;
            self.loginSuccess = loginSuccess;
            self.loginFail = loginFail;
            self.loginTimeout = timeout;
            self.attribute = attribute;
            self.authFinish = NO;
            self.isOverlookFpnnCloseCallBack = NO;
            if (self.loginTimeout <= 0) {
                self.loginTimeout = 30;
            }
                
        }
        
            [self _toAuth];
        
    });
  
}
-(void)_toAuth{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        self.connectStatus = RTMClientConnectStatusConnecting;
    }
    [self _authRequest];
    
}
- (void)_authRequest{
    FPNSLog(@"%s",__FUNCTION__);
    @rtmWeakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
        
        NSMutableDictionary * authQuestDic = [NSMutableDictionary dictionary];
        [authQuestDic setValue:@(self->_projectId) forKey:@"pid"];
        [authQuestDic setValue:@(self->_userId) forKey:@"uid"];
        [authQuestDic setValue:self->_token forKey:@"token"];
        [authQuestDic setValue:self->_language forKey:@"lang"];
        [authQuestDic setValue:self->_attribute forKey:@"attrs"];
        [authQuestDic setValue:self->_sdkVersion forKey:@"version"];
        
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"auth"
                                               message:authQuestDic
                                                twoWay:YES];
        BOOL result = [self.authClient sendQuest:quest
                                         timeout:self.loginTimeout
                                         success:^(NSDictionary * _Nullable data) {
            
            FPNSLog(@"auth %@",data);
            @rtmStrongify(self);
            
            @synchronized (self) {
                
                //OK 1 成功  0 token 无效
                if ([data[@"ok"] boolValue]) {
                    
                    self.connectStatus = RTMClientConnectStatusConnected;
                    self.reloginNum = 0;
                    
                    if (self.authFinish) {//重连
                        FPNSLog(@"重连登录成功");
                        self.lastPingTime = [NSDate date];
                        self.authFinish = YES;
                        [self _reloginComplete:nil];
                        
                    }else{//登录
                        FPNSLog(@"常规登录成功");
                        self.authFinish = YES;
                        if (self.loginSuccess) {
                            self.loginSuccess();
                            self.loginSuccess = nil;
                            self.loginFail = nil;
                        }
                    }
                    
                    
                }else{//ok 0  token无效
                    
                    if (self.authFinish) {
                        //重连 token无效
                        FPNSLog(@"重连token无效");
                        self.authFinish = NO;
                        [self _closeConnectHandle:NO];
                        [self _reloginComplete:[FPNError errorWithEx:@"RTM_EC_INVALID_AUTH_TOEKN" code:200027]];
                        [self _byeCloseConnect:YES];
                        
                    }else{
                        //登录token无效
                        FPNSLog(@"登录token无效");
                        [self _closeConnectHandle:NO];
                        if (self.loginFail) {
                            self.loginFail([FPNError errorWithEx:@"RTM_EC_INVALID_AUTH_TOEKN" code:200027]);
                            self.loginFail = nil;
                            self.loginSuccess = nil;
                        }
                    }
   
                }
            }
                                

        } fail:^(FPNError * _Nullable error) {
            
            @rtmStrongify(self);
            @synchronized (self) {
                self.connectStatus = RTMClientConnectStatusConnectClosed;
                [self.authClient closeConnect];
                
                if (self.authFinish) {
                    //重连
                    FPNSLog(@"重连错误");
                    [self _reloginComplete:error];
                    [self _reLogin];
                    
                }else{
                    //登录
                    FPNSLog(@"登录错误");
                    if (self.loginFail) {
                        self.loginFail(error);
                        self.loginFail = nil;
                        self.loginSuccess = nil;
                    }
                    
                }
            }
            
        }];
        
        //无网络
        if (result == NO) {
            @synchronized (self) {

               
                self.connectStatus = RTMClientConnectStatusConnectClosed;
                [self.authClient closeConnect];
                
                NSString * errorLog = [NSString stringWithFormat:@"AuthRequest FPNN_EC_CORE_INVALID_CONNECTION  endpoint = %@  ip = %@  port = %d   ipv4 = %d ",self.authEndPoint,
                                       [self.authClient getIp],
                                       [self.authClient getPort],
                                       [self.authClient isIpv4]];
                if (self.authFinish) {
                    //重连
                    FPNSLog(@"重连无网络");
                    [self _reloginComplete:[FPNError errorWithEx:errorLog code:20012]];
                    [self _reLogin];
                    
                }else{
                    //登录
                    FPNSLog(@"登录无网络");
                    if (self.loginFail) {
                        self.loginFail([FPNError errorWithEx:errorLog code:20012]);
                        self.loginFail = nil;
                        self.loginSuccess = nil;
                    }
                }
            }
        }
        
    });
            
}

-(void)_reLogin{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        if (self.autoRelogin && self.authFinish) {
            [self _getDelegateToRelogin];
        }
    }
}

-(void)_getDelegateToRelogin{
    FPNSLog(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            
            if (self.netStatus != RTMClientNetStatusNone) {
                     self.reloginNum = self.reloginNum + 1;
                     BOOL result = [self.delegate rtmReloginWillStart:self reloginCount:self.reloginNum];
                     if (result) {
                         self.connectStatus = RTMClientConnectStatusConnecting;
                         if (self.reloginNum != 1) {
                             [NSThread sleepForTimeInterval:1];
                         }
                         [self _toAuth];
                         
                     }else{
                         self.authFinish = NO;
                         self.connectStatus = RTMClientConnectStatusConnectClosed;
                         if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
                             [self.delegate rtmConnectClose:self];
                         }
                     
                     }
             }else{
                 
                 if (self.authFinish == YES && self.connectStatus != RTMClientConnectStatusConnectClosed) {
                     self.connectStatus = RTMClientConnectStatusConnectClosed;
                     if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
                         [self.delegate rtmConnectClose:self];
                     }
                 }
                     
            }
           
        }
        
    });
}

-(void)_reloginComplete:(FPNError*)error{
    FPNSLog(@"%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(rtmReloginCompleted:reloginCount:reloginResult:error:)]) {
        [self.delegate rtmReloginCompleted:self
                              reloginCount:self.reloginNum
                             reloginResult:(error == nil ? YES : NO)
                                     error:error];
    }
}

-(void)_closeConnectHandle:(BOOL)needNotification{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        self.connectStatus = RTMClientConnectStatusConnectClosed;
        if (needNotification == YES) {
            self.authFinish = NO;
        }
        [self _notificationClose : needNotification];
    }
}

-(void)_notificationClose:(BOOL)needNotification{
    FPNSLog(@"%s",__FUNCTION__);
    [_authClient closeConnect];
    //offline
     @synchronized (self) {
         self.connectStatus = RTMClientConnectStatusConnectClosed;
         [self _cancelPingTimer];
     }
    
    if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)] && needNotification) {
        [self.delegate rtmConnectClose:self];
    }
}

-(void)closeConnect{
    FPNSLog(@"%s",__FUNCTION__);
    if (self.connectStatus != RTMClientConnectStatusConnectClosed) {
        @synchronized (self) {
            //YIN
            
            self.isOverlookFpnnCloseCallBack = YES;
            [self _closeConnectHandle:YES];
        }
    }
}

-(void)_byeCloseConnect:(BOOL)updateAuthFinish{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        self.authFinish = NO;
        if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
            [self.delegate rtmConnectClose:self];
        }
    }
}

- (void)_netChange:(NSNotification *)noti{
    FPNSLog(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([noti.object intValue] == 0) {
            FPNSLog(@"未知网络");
            self.netStatus = RTMClientNetStatusNone;
        }else if ([noti.object intValue] == 1){
            FPNSLog(@"没有网络");
            self.netStatus = RTMClientNetStatusNone;
        }else if ([noti.object intValue] == 2){
            FPNSLog(@"蜂窝网络");
            self.netStatus = RTMClientNetStatusReachableViaWWAN;
        }else if ([noti.object intValue] == 3){
            FPNSLog(@"WIFI网络");
            self.wifiAddress = [self getIPAddress];
            self.netStatus = RTMClientNetStatusReachableWifi;
        }
        
    });
}

-(void)_startNetMonitor{
    FPNSLog(@"%s",__FUNCTION__);
    [RTMNetworkReachabilityShare sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_netChange:) name:RTMNetworkReachabilityShareDidChangeNotification object:nil];
}

- (NSString *)getIPAddress{
    FPNSLog(@"%s",__FUNCTION__);
    NSString *adress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                //check if interface is en0 which is the wifi conection on the iphone
                if ([[NSString stringWithUTF8String:temp_addr ->ifa_name] isEqualToString:@"en0"]) {
                    adress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr -> ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return (adress);
}
-(void)_stopNetMonitor{
    FPNSLog(@"%s",__FUNCTION__);
    FPNetworkReachabilityManager *manager = [FPNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}
-(BOOL)_getIsValidNet{
    FPNSLog(@"%s",__FUNCTION__);
    if (self.netStatus == RTMClientNetStatusReachableWifi || self.netStatus == RTMClientNetStatusReachableViaWWAN) {
        return YES;
    }else{
        return NO;
    }
}

-(void)_startPingMonitor{
    FPNSLog(@"%s",__FUNCTION__);
    [self _cancelPingTimer];
    @synchronized (self) {
        if (self.connectStatus == RTMClientConnectStatusConnected) {
            uint64_t interval = 1 * NSEC_PER_SEC;
            dispatch_queue_t pingTimerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            if (self.pingTimer == nil) {
                self.pingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, pingTimerQueue);
                dispatch_source_set_timer(self.pingTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
                __weak RTMClient *blockSelf = self;
                dispatch_source_set_event_handler(self.pingTimer, ^(){
                    [blockSelf _isTimeoutPing];
                });
                dispatch_resume(self.pingTimer);
            }
        }
    }
}
-(void)_isTimeoutPing{
//    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        if (self.connectStatus == RTMClientConnectStatusConnected) {
            float f = self.lastPingTime.timeIntervalSinceNow;
            
            if (-ceil(f) < 60) {

            }else{

                if (self.currentConnectStatus == RTMClientConnectStatusConnected) {
                    self.connectStatus = RTMClientConnectStatusConnectClosed;
                    self.isOverlookFpnnCloseCallBack = YES;
                    if (self.autoRelogin) {

                        //YIN
//                        NSLog(@"[self closeVoiceClient];22222222");
//                        [self closeVoiceClient];
//                        [self performSelector:@selector(closeVideoClient)];
                        
                        [self _closeConnectHandle:NO];
                        [self _reLogin];
                    }else{

                        [self _closeConnectHandle:YES];
                    }
                }
                
            }
            
            
        }
    }
    
        
}
-(void)_cancelPingTimer{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        if (self.pingTimer) {
            dispatch_cancel(self.pingTimer);
            self.pingTimer = nil;
        }
    }
}
-(int64_t)_getMessageId{
    @synchronized (self) {
        _messageId = _messageId + 1;
        int64_t millisecond = [[NSDate date] timeIntervalSince1970] * 1000;
        return (millisecond << 16) + _messageId;
    }
}
-(void)setAuthFinish:(BOOL)authFinish{
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
        _authFinish = authFinish;
        if (_authFinish == YES) {
            self.lastPingTime = [NSDate date];
            if (self.pingTimer == nil) {
                [self _startPingMonitor];
            }
        }else{
            self.connectStatus = RTMClientConnectStatusConnectClosed;
        }
    }
}
-(void)setNetStatus:(RTMClientNetStatus)netStatus{
    
    FPNSLog(@"%s",__FUNCTION__);
    @synchronized (self) {
            
        if (_netStatus == RTMClientNetStatusNoDetection && netStatus != RTMClientNetStatusNone) {
    //        NSLog(@"检测到网络");
            _netStatus = netStatus;
            return;
        }
        
        if (netStatus == RTMClientNetStatusNone || netStatus == RTMClientNetStatusNoDetection) {
    //        NSLog(@"setNetStatus  无网络  %ld  %d",(long)self.connectStatus,self.authFinish);
            
            if (self.connectStatus != RTMClientConnectStatusConnectClosed && self.authFinish == YES) {
                //YIN
//                NSLog(@"setNetStatus:(RTMClientNetStatus)netStatus{");
                self.isOverlookFpnnCloseCallBack = YES;
                [self _notificationClose:YES];
            }
 
        }
        
        if ([self _getIsValidNet] && _netStatus != netStatus && netStatus != RTMClientNetStatusNone && self.authFinish == YES) {
            //4G <=> WIFI
//
            if (self.authFinish && self.currentConnectStatus == RTMClientConnectStatusConnected) {
                self.isOverlookFpnnCloseCallBack = YES;
                [self _closeConnectHandle:NO];
//                NSLog(@"4G <=> WIFI");
                //YIN
                [self _getDelegateToRelogin];
                
            }
        }
        
        if ((_netStatus == RTMClientNetStatusNone || _netStatus == RTMClientNetStatusNoDetection) && (netStatus == RTMClientNetStatusReachableWifi || netStatus == RTMClientNetStatusReachableViaWWAN) && self.authFinish == YES) {
    //        NSLog(@"无网络 -》 有网络");

            _netStatus = netStatus;
            [self _reLogin];
        }
        
        
        
        _netStatus = netStatus;

    }
    
}
-(RTMClientConnectStatus)currentConnectStatus{
    return self.connectStatus;
}
-(void)setConnectStatus:(RTMClientConnectStatus)connectStatus{
    @synchronized (self) {
        _connectStatus = connectStatus;
        if (_connectStatus == RTMClientConnectStatusConnected) {
            self.isOverlookFpnnCloseCallBack = NO;
        }
    }
}

-(FPNNTCPClient*)authClient{
    
        if (_authClient == nil && self.authEndPoint != nil) {
            @synchronized (self) {
            _authClient = [FPNNTCPClient clientWithEndpoint:self.authEndPoint pid:[NSString stringWithFormat:@"%lld",self.projectId]];

            @rtmWeakify(self);
            _authClient.connectionSuccessCallBack = ^{

                
            };
            
            _authClient.connectionCloseCallBack = ^{
//                NSLog(@"connectionCloseCallBackconnectionCloseCallBack%@",[NSThread currentThread]);
                @rtmStrongify(self);
                @synchronized (self) {
                    [self.fileClientCache removeAllObjects];

                    if (self.connectStatus == RTMClientConnectStatusConnected) {

                        //YIN
                        
  
                        if (self.isOverlookFpnnCloseCallBack) {
                    
                            self.isOverlookFpnnCloseCallBack = NO;
                            
                        }else{
                            //gai && self.connectStatus != RTMClientConnectStatusConnectClosed
                            if (self.authFinish && self.autoRelogin) {
                                [self _notificationClose:NO];
                                [self _getDelegateToRelogin];
  
                            }else{
                                
                                if (self.authFinish) {
                                    [self _byeCloseConnect:YES];
                                }
                                
                            }
                        }
                        
                    }else{
//                        NSLog(@"connectionCloseCallBack else");
                        self.isOverlookFpnnCloseCallBack = NO;
                    }
                    
                    
                }


            };
            
                
            _authClient.listenAndReplyCallBack = ^FPNNAnswer * _Nullable(NSDictionary * _Nullable data, NSString * _Nullable method) {
                
//                FPNSLog(@"listenAndReplyCallBack %@ %@",method,data);
                @rtmStrongify(self);
                
                if ([method isEqualToString:@"ping"]) {
                    if (self.authFinish && self.connectStatus == RTMClientConnectStatusConnected) {
                        self.lastPingTime = [NSDate date];
                    }
                    return [RTMAnswer emptyAnswer];
                }
                            
                if ([method isEqualToString:@"kickoutroom"]) {
                    if ([self.delegate respondsToSelector:@selector(rtmRoomKickoutData:data:)]) {
                        [self.delegate rtmRoomKickoutData:self data:data];
                    }
                    return [RTMAnswer emptyAnswer];
                }
                
                if ([method isEqualToString:@"kickout"]) {
                    
                    @synchronized (self) {

                        if (self.connectStatus == RTMClientConnectStatusConnected) {
                            
                            //YIN
                           
                            self.isOverlookFpnnCloseCallBack = YES;
                            self.authFinish = NO;
                            self.connectStatus = RTMClientConnectStatusConnectClosed;
                            
                            if ([self.delegate respondsToSelector:@selector(rtmKickout:)]) {
                                [self.delegate rtmKickout:self];
                            }
                            
                            [self _byeCloseConnect:YES];
                            
                        }
                    }
                    
                    
                    
                    return nil;//one way
                }
                

                //分发消息
                if ([method isEqualToString:@"pushmsg"] ||
                    [method isEqualToString:@"pushgroupmsg"] ||
                    [method isEqualToString:@"pushroommsg"] ||
                    [method isEqualToString:@"pushbroadcastmsg"]) {
                    [self messageShareCenter:data method:method];
                    
                    return [RTMAnswer emptyAnswer];
                }
                
                
//                NSLog(@"method == %@",method);
                
                
                
                return [RTMAnswer emptyAnswer];
                
                
                
                
            };
                
                }
            
        }
        return _authClient;
        
}
-(void)dealloc{
//    NSLog(@"deallocdeallocdealloc");
//    NSLog(@"RTMClient dealloc");
    [self _cancelPingTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [NSThread sleepForTimeInterval:0.2];
}





@end






