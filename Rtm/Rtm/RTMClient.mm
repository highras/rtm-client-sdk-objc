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
@property(nonatomic,strong)dispatch_source_t loginTimeoutTimer;
@property(nonatomic,copy)NSString * whichEndpoint;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * language;
@property (nonatomic,strong)NSDictionary * attribute;
@property (nonatomic,copy)RTMLoginSuccessCallBack loginSuccess;
@property (nonatomic,copy)RTMLoginFailCallBack loginFail;
@property(nonatomic,assign)RTMClientConnectStatus connectStatus;
@property(nonatomic,assign)int loginTimeout;//which + auth 总计  超过则fail回调

//which
@property (nonatomic,strong)FPNNTCPClient * whichClient;

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

//
//@property(nonatomic,strong)NSDate * toBacKGroudTime;

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
    
    
    if (endpoint == nil || endpoint.length == 0 || projectId == 0 || userId == 0) {
        FPNSLog(@"rtm init client invalid parameter");
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
- (instancetype)initWithEndpoint:(NSString * _Nonnull)endpoint
                       projectId:(int64_t)projectId
                          userId:(int64_t)userId
                        delegate:(id<RTMProtocol>)delegate
                          config:(RTMClientConfig *)config
                     autoRelogin:(BOOL)autoRelogin{
    
    self = [super init];
    
   
    if (self) {
        
        _netStatus = RTMClientNetStatusNoDetection;
        _whichEndpoint = endpoint;
        _projectId = projectId;
        _userId = userId;
        _config = config;
        _autoRelogin = autoRelogin;
        _sdkVersion = @"2.1.2";
        _apiVersion = @"2.6.1";
        _reloginNum = 0;
        _connectStatus = RTMClientConnectStatusConnectClosed;
        _delegate = delegate;
        _messageId = 0;
        _fileClientCache = [[NSCache alloc]init];
        _fileClientCache.countLimit = 5;
        
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
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        
    }
    
    return self;
    
}
-(void)didBecomeActive{
//    NSLog(@"didBecomeActivedidBecomeActive  %ld",(long)self.currentConnectStatus);
    @synchronized (self) {
        if (self.netStatus == RTMClientNetStatusReachableWifi && self.authFinish && self.currentConnectStatus == RTMClientConnectStatusConnected) {
        NSString * currentWifiAddress = [self getIPAddress];
        if ([self.wifiAddress isEqualToString:currentWifiAddress] == NO && [currentWifiAddress isEqualToString:@"error"] == NO) {
//                NSLog(@"wifi 切换  %@",currentWifiAddress);
                self.isOverlookFpnnCloseCallBack = YES;
                self.wifiAddress =  currentWifiAddress;
                [self _closeConnectHandle:NO];
                [self _getDelegateToRelogin];
            }
            
        }
    }
    
}
//-(void)didEnterBackground{
//    NSLog(@"didEnterBackground");
////    self.toBacKGroudTime = [NSDate date];
////    float f = self.toBacKGroudTime.timeIntervalSinceNow;
////    if (-ceil(f) >= 120) {
////        if (self.autoRelogin) {
////            [self _closeConnectHandle:NO];
////            [self _reLogin];
////        }else{
////            [self _closeConnectHandle:YES];
////        }
////    }
//}

- (void)loginWithToken:(NSString * _Nonnull)token
              language:(NSString * _Nullable)language
             attribute:(NSDictionary * _Nullable)attribute
               timeout:(int)timeout
               success:(RTMLoginSuccessCallBack)loginSuccess
           connectFail:(RTMLoginFailCallBack)loginFail{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if (self.connectStatus != RTMClientConnectStatusConnectClosed) {
                FPNSLog(@"rtm loginWithToken error , client is connected or connecting");
                return;
            }
            
            
            if ([self.delegate respondsToSelector:@selector(rtmReloginCompleted:reloginCount:reloginResult:error:)] == NO ||
                [self.delegate respondsToSelector:@selector(rtmReloginWillStart:reloginCount:)] == NO)  {
                FPNSLog(@"rtm loginWithToken error , no implement RTMProtocol required delegate methods");
                return;
            }
            
            if (token == nil || token.length == 0) {
                FPNSLog(@"rtm loginWithToken error , invalid token");
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
                
            [self _toLogin:YES];
        
    });

    
        
}
-(void)_toLogin:(BOOL)isLogin{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"%s  %@",__FUNCTION__ ,[NSThread currentThread]);
        @synchronized (self) {
            self.connectStatus = RTMClientConnectStatusConnecting;
        }
//            NSLog(@"_toLogin_toLogin");
            if (self.authEndPoint == nil) {
                [self _whichRequest];
            }else{
                [self _authRequest];
            }
       // }
        
    });
    
    if (isLogin) {

        __block BOOL isImmediateRun = NO;
        uint64_t interval = self.loginTimeout * NSEC_PER_SEC;
        dispatch_queue_t loginTimeoutTimerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                if (self.loginTimeoutTimer == nil) {
                    @synchronized (self) {

                        self.loginTimeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, loginTimeoutTimerQueue);
                        dispatch_source_set_timer(self.loginTimeoutTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
                        __weak RTMClient *blockSelf = self;
                        dispatch_source_set_event_handler(self.loginTimeoutTimer, ^(){
                            if (isImmediateRun == NO) {
                                isImmediateRun = YES;
                            }else{
                                [blockSelf _checkLoginIsFinish];
                            }

                        });
                        dispatch_resume(self.loginTimeoutTimer);

                    }
                }

            }
    
    
}


-(void)_checkLoginIsFinish{
    @synchronized (self) {
        if (self.authFinish == NO && self.connectStatus == RTMClientConnectStatusConnecting) {
                [_whichClient closeConnect];
                [_authClient closeConnect];
            if (self.loginFail) {
                //超时
                self.loginFail([FPNError errorWithEx:@"FPNN_EC_CORE_TIMEOUT" code:20003]);
                self.loginFail = nil;
                self.loginSuccess = nil;
                if (self.loginTimeoutTimer) {
                    dispatch_cancel(self.loginTimeoutTimer);
                    self.loginTimeoutTimer = nil;
                }
                
            }
        
        }
    }
}
- (void)_whichRequest{
        
        NSMutableDictionary * whichQuestDic = [NSMutableDictionary dictionary];
            [whichQuestDic setValue:@"rtmGated" forKey:@"what"];
            if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
                [whichQuestDic setValue:@"ipv6" forKey:@"addrType"];
            }
            
            FPNNQuest * quest = [FPNNQuest questWithMethod:@"which"
                                                   message:whichQuestDic
                                                    twoWay:YES];
            
                @rtmWeakify(self);
                BOOL result = [self.whichClient sendQuest:quest
                                                  timeout:self.loginTimeout
                                                  success:^(NSDictionary * _Nullable data) {
                    
                    @rtmStrongify(self);
//                    @synchronized (self) {
                        
                        NSString * endPoint = data[@"endpoint"];
                        if (endPoint == nil || endPoint.length == 0) {
                            
                            @synchronized (self) {
                                self.connectStatus = RTMClientConnectStatusConnectClosed;
                                if (self.loginFail) {
                                    self.loginFail([FPNError errorWithEx:@"RTM_EC_UNKNOWN_ERROR" code:200999]);
                                    self.loginFail = nil;
                                    self.loginSuccess = nil;
                                    if (self.loginTimeoutTimer) {
                                        dispatch_cancel(self.loginTimeoutTimer);
                                        self.loginTimeoutTimer = nil;
                                    }
                                }
                            }
                            
                            
                        }else{
                            
//                            [self.whichClient closeConnect];
//                            self.whichClient = nil;
                            if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
                                endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
                            }
                            self.authEndPoint = endPoint;
                            [self _authRequest];
                            
                        }
                        
//                    }
//                    NSLog(@"which %@",data);
                    
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    @rtmStrongify(self);
                    @synchronized (self) {
                        self.connectStatus = RTMClientConnectStatusConnectClosed;
//                        [self.whichClient closeConnect];
                        if (self.loginFail) {
                            self.loginFail(error);
                            self.loginFail = nil;
                            self.loginSuccess = nil;
                            if (self.loginTimeoutTimer) {
                                dispatch_cancel(self.loginTimeoutTimer);
                                self.loginTimeoutTimer = nil;
                            }
                        }
                    }
                    
                    
                }];
                
                
                //无网络
                if (result == NO) {
//                    NSLog(@"无网络which %@",[NSThread currentThread]);
                    self.connectStatus = RTMClientConnectStatusConnectClosed;
//                    [self.whichClient closeConnect];
                    
                    @synchronized (self) {
                        if (self.loginFail) {
                            self.loginFail([FPNError errorWithEx:@"FPNN_EC_CORE_INVALID_CONNECTION" code:20012]);
                            self.loginFail = nil;
                            self.loginSuccess = nil;
                            if (self.loginTimeoutTimer) {
                                dispatch_cancel(self.loginTimeoutTimer);
                                self.loginTimeoutTimer = nil;
                            }
                        }
                    }
                    
                    
                }
    
}
- (void)_authRequest{

            NSMutableDictionary * authQuestDic = [NSMutableDictionary dictionary];
            [authQuestDic setValue:@(_projectId) forKey:@"pid"];
            [authQuestDic setValue:@(_userId) forKey:@"uid"];
            [authQuestDic setValue:_token forKey:@"token"];
            [authQuestDic setValue:_language forKey:@"lang"];
            [authQuestDic setValue:_attribute forKey:@"attrs"];
            
            FPNNQuest * quest = [FPNNQuest questWithMethod:@"auth"
                                                   message:authQuestDic
                                                    twoWay:YES];
            @rtmWeakify(self);
            BOOL result = [self.authClient sendQuest:quest
                                             timeout:self.loginTimeout
                                             success:^(NSDictionary * _Nullable data) {
                
        //        NSLog(@"auth %@",data);
                @rtmStrongify(self);
                
                @synchronized (self) {
                    
                    if ([data[@"ok"] boolValue]) {
                                    
                                    @synchronized (self) {
                                        self.connectStatus = RTMClientConnectStatusConnected;
                                        self.reloginNum = 0;
                                    }
//                        NSLog(@"self.authFinishself.authFinish   %d",self.authFinish);
                                    if (self.authFinish) {//重连
//                                        NSLog(@"重连登录成功");
                                        @synchronized (self) {
                                            self.lastPingTime = [NSDate date];
                                            self.authFinish = YES;
                                            [self _reloginComplete:nil];
                                        }
                                        
                                        
                                    }else{//登录
//                                        NSLog(@"常规登录成功");
                                        @synchronized (self) {
                                            self.authFinish = YES;
                                            if (self.loginTimeoutTimer) {
                                                dispatch_cancel(self.loginTimeoutTimer);
                                                self.loginTimeoutTimer = nil;
                                                
                                            }
                                            if (self.loginSuccess) {
                                                self.loginSuccess();
                                                self.loginSuccess = nil;
                                                self.loginFail = nil;
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                    
                                
                            
                                }else{//多点登录
                                    NSString * endPoint = data[@"gate"];
                                    if (endPoint == nil || endPoint.length == 0) {//token invalid
                                       
                                        @synchronized (self) {
                                            self.connectStatus = RTMClientConnectStatusConnected;
                                        }

                                        
                                        if (self.authFinish) {//重连
//                                            NSLog(@"多点登录  重连");
                                            @synchronized (self) {
                                                self.authFinish = NO;
                                            }
                                            
                                            [self _closeConnectHandle:NO];
//                                            NSLog(@"多点登录  重连111111");

                                            [self _reloginComplete:[FPNError errorWithEx:@"RTM_EC_INVALID_AUTH_TOEKN" code:200027]];
                                            [self _byeCloseConnect:YES];
                                            
                                        }else{
                                            
                                            
                                            [self _closeConnectHandle:NO];
                                            @synchronized (self) {
                                                if (self.loginFail) {
    //                                                NSLog(@"多点登录  重连2222222");
                                                    self.loginFail([FPNError errorWithEx:@"RTM_EC_INVALID_AUTH_TOEKN" code:200027]);
                                                    self.loginFail = nil;
                                                    self.loginSuccess = nil;
                                                    if (self.loginTimeoutTimer) {
                                                        dispatch_cancel(self.loginTimeoutTimer);
                                                        self.loginTimeoutTimer = nil;
                                                    }
                                                }
                                            }
                                            
                                        }
                                                      
                                        
                                    }else{
                    //                    NSLog(@"多点登录  正常连");
                                        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
                                            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
                                        }
                                        
                                        @synchronized (self) {
                                            self.authEndPoint = endPoint;
                                            [self.authClient closeConnect];
                                            self.authClient = nil;
                                        }
                                          
                                        [self _authRequest];
                                        
                                    }
                                    
                                }
                    
                }
                    
                
            } fail:^(FPNError * _Nullable error) {
                
                
//                NSLog(@"ail:^(FPNError * _Nullable error) {ail:^(FPNError * _Nullable error) {");
                @rtmStrongify(self);
                
                @synchronized (self) {
                    
                    self.connectStatus = RTMClientConnectStatusConnectClosed;
                    [self.authClient closeConnect];//没有网络
                    
                    if (self.authFinish) {//重连
                        [self _reloginComplete:error];
                        [self _reLogin];
                        
                    }else{

                        @synchronized (self) {
                            if (self.loginTimeoutTimer) {
                                dispatch_cancel(self.loginTimeoutTimer);
                                self.loginTimeoutTimer = nil;
                            }
                            if (self.loginFail) {

                                self.loginFail(error);
                                self.loginFail = nil;
                                self.loginSuccess = nil;
                                if (self.loginTimeoutTimer) {
                                    dispatch_cancel(self.loginTimeoutTimer);
                                    self.loginTimeoutTimer = nil;
                                }
                            }
                        }
                        
                    }
                }
                
                
                
            }];
            
            //无网络
            if (result == NO) {
                @synchronized (self) {
                    
                
                self.connectStatus = RTMClientConnectStatusConnectClosed;
                [self.authClient closeConnect];
                
                if (self.authFinish) {
                    //重连失败回调
                    [self _reloginComplete:[FPNError errorWithEx:@"FPNN_EC_CORE_INVALID_CONNECTION" code:20012]];
                    [self _reLogin];
                }else{
                    
                    if (self.loginTimeoutTimer) {
                        @synchronized (self) {
                            dispatch_cancel(self.loginTimeoutTimer);
                            self.loginTimeoutTimer = nil;
                        }

                    }
                    if (self.loginFail) {
                        self.loginFail([FPNError errorWithEx:@"FPNN_EC_CORE_INVALID_CONNECTION" code:20012]);
                        self.loginFail = nil;
                        self.loginSuccess = nil;
                        if (self.loginTimeoutTimer) {
                            dispatch_cancel(self.loginTimeoutTimer);
                            self.loginTimeoutTimer = nil;
                        }
                    }
                }
                  
                }
                
            }
    
    
}


-(void)_reLogin{
    @synchronized (self) {
        if (self.autoRelogin && self.authFinish) {
            [self _getDelegateToRelogin];
        }
    }
}
-(void)_getDelegateToRelogin{
    
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
                              [self _toLogin:NO];
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
    if ([self.delegate respondsToSelector:@selector(rtmReloginCompleted:reloginCount:reloginResult:error:)]) {
        [self.delegate rtmReloginCompleted:self
                              reloginCount:self.reloginNum
                             reloginResult:(error == nil ? YES : NO)
                                     error:error];
    }
}


-(void)_closeConnectHandle:(BOOL)needNotification{
    

    @synchronized (self) {
        self.connectStatus = RTMClientConnectStatusConnectClosed;
        if (needNotification == YES) {
            self.authFinish = NO;
        }
//        NSLog(@"-(void)_closeConnectHandle:(BOOL)needNotification{");
        [self _notificationClose : needNotification];
    }
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"bye" message:nil twoWay:YES];
//    FPNNAnswer * an = [self.usingClient sendQuest:quest
//                        timeout:2];

    
    
    
    //    [self offLineWithTimeout:2 success:^{
    //
    ////        NSLog(@"offLineWithTimeoutsuccesssuccess");
    //        dispatch_semaphore_signal(sema);
    //
    //    } fail:^(FPNError * _Nullable error) {
    //
    ////        NSLog(@"offLineWithTimeoutFPNErrorFPNErrorFPNError");
    //        dispatch_semaphore_signal(sema);
    //
    //    }];
    //
    //    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
-(void)_notificationClose:(BOOL)needNotification{
    
//    NSLog(@")_notificationClose:(BOOL)needNotification{");
    
    [_whichClient closeConnect];
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

    if (self.connectStatus != RTMClientConnectStatusConnectClosed) {
        @synchronized (self) {
            self.isOverlookFpnnCloseCallBack = YES;
            [self _closeConnectHandle:YES];
        }
    }
    
    
}
-(void)_byeCloseConnect:(BOOL)updateAuthFinish{
    @synchronized (self) {

        self.authFinish = NO;
        if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
            [self.delegate rtmConnectClose:self];
        }
    
    
        
    }
}

- (void)_netChange:(NSNotification *)noti{

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
    [RTMNetworkReachabilityShare sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_netChange:) name:RTMNetworkReachabilityShareDidChangeNotification object:nil];
}
- (NSString *)getIPAddress{
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
    FPNetworkReachabilityManager *manager = [FPNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}
-(BOOL)_getIsValidNet{
    if (self.netStatus == RTMClientNetStatusReachableWifi || self.netStatus == RTMClientNetStatusReachableViaWWAN) {
        return YES;
    }else{
        return NO;
    }
}

-(void)_startPingMonitor{
    
        [self _cancelPingTimer];
        if (self.connectStatus == RTMClientConnectStatusConnected) {

            uint64_t interval = 1 * NSEC_PER_SEC;
            dispatch_queue_t pingTimerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            if (self.pingTimer == nil) {
                @synchronized (self) {
                
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
    
    if (self.connectStatus == RTMClientConnectStatusConnected) {
        float f = self.lastPingTime.timeIntervalSinceNow;
//        FPNSLog(@"距离上次收到 ping 间隔 %f",-ceil(f));
        if (-ceil(f) < 60) {

        }else{
            
            @synchronized (self) {
                if (self.currentConnectStatus == RTMClientConnectStatusConnected) {
                    self.connectStatus = RTMClientConnectStatusConnectClosed;
                    self.isOverlookFpnnCloseCallBack = YES;
                    if (self.autoRelogin) {
//                        NSLog(@"_isTimeoutPing %@",[NSThread currentThread]);
                        [self _closeConnectHandle:NO];
                        [self _reLogin];
                    }else{
//                         NSLog(@"_~~~~~isTimeoutPing %@",[NSThread currentThread]);
                        [self _closeConnectHandle:YES];
                    }
                }
                
            }
        }

    }
        
}
-(void)_cancelPingTimer{
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


//-(void)setUsingClient:(FPNNTCPClient *)usingClient{
//    _usingClient = usingClient;
//}
-(void)setAuthFinish:(BOOL)authFinish{
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
    
//    NSLog(@"%s  %@",__FUNCTION__,[NSThread currentThread]);
//    NSLog(@"原网络%ld  现在网络%ld",(long)_netStatus,(long)netStatus);
    @synchronized (self) {
        
    
    if (_netStatus == RTMClientNetStatusNoDetection && netStatus != RTMClientNetStatusNone) {
//        NSLog(@"检测到网络");
        @synchronized (self) {
            _netStatus = netStatus;
        }
        return;
    }
    
    if (netStatus == RTMClientNetStatusNone || netStatus == RTMClientNetStatusNoDetection) {
//        NSLog(@"setNetStatus  无网络  %ld  %d",(long)self.connectStatus,self.authFinish);
        @synchronized (self) {
            if (self.connectStatus != RTMClientConnectStatusConnectClosed && self.authFinish == YES) {
            
//                NSLog(@"setNetStatus:(RTMClientNetStatus)netStatus{");
                self.isOverlookFpnnCloseCallBack = YES;
                [self _notificationClose:YES];
            }
            
            
        }
    }
    
    if ([self _getIsValidNet] && _netStatus != netStatus && netStatus != RTMClientNetStatusNone && self.authFinish == YES) {
        //4G <=> WIFI
        @synchronized (self) {
//            NSLog(@"~~~4G <=> WIFI  %ld",(long)self.currentConnectStatus);
            if (self.authFinish && self.currentConnectStatus == RTMClientConnectStatusConnected) {
                self.isOverlookFpnnCloseCallBack = YES;
                [self _closeConnectHandle:NO];
//                NSLog(@"4G <=> WIFI");
                [self _getDelegateToRelogin];
            }
             
        }
       
    }
    
    if ((_netStatus == RTMClientNetStatusNone || _netStatus == RTMClientNetStatusNoDetection) && (netStatus == RTMClientNetStatusReachableWifi || netStatus == RTMClientNetStatusReachableViaWWAN) && self.authFinish == YES) {
//        NSLog(@"无网络 -》 有网络");
        @synchronized (self) {
            
            _netStatus = netStatus;
                     
        }
        [self _reLogin];
    }
        
    @synchronized (self) {
                      
        _netStatus = netStatus;
                 
    }
        
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

-(FPNNTCPClient*)whichClient{
    
        
        if (_whichClient == nil && self.whichEndpoint != nil) {
//            @synchronized (self) {
                
                _whichClient = [FPNNTCPClient clientWithEndpoint:self.whichEndpoint];
//            }
        }
        return _whichClient;
        
    
    
}
-(FPNNTCPClient*)authClient{
    
        if (_authClient == nil && self.authEndPoint != nil) {
            @synchronized (self) {
            _authClient = [FPNNTCPClient clientWithEndpoint:self.authEndPoint];
            @rtmWeakify(self);
            _authClient.connectionSuccessCallBack = ^{

                
            };
            
            _authClient.connectionCloseCallBack = ^{
//                NSLog(@"connectionCloseCallBackconnectionCloseCallBack%@",[NSThread currentThread]);
                @rtmStrongify(self);
                @synchronized (self) {
//                    NSLog(@"connectionCloseCallBackconnectionCloseCallBackconnectionCloseCallBack  %@  %ld",[NSThread currentThread],(long)self.currentConnectStatus);
                    if (self.connectStatus == RTMClientConnectStatusConnected) {
//                        NSLog(@"connectionCloseCallBack RTMClientConnectStatusConnected");
                        if (self.isOverlookFpnnCloseCallBack) {
                            @synchronized (self) {
//                                NSLog(@"connectionCloseCallBack self.isOverlookFpnnCloseCallBack = NO;");
                                self.isOverlookFpnnCloseCallBack = NO;
                            }
                        }else{
                            //gai && self.connectStatus != RTMClientConnectStatusConnectClosed
                            if (self.authFinish && self.autoRelogin) {
//                                NSLog(@"self.authFinish && self.autoRelogin && self.connectStatus != RTMClientConnectStatusConnectClosed) 2222");
                                @synchronized (self) {
                                    [self _notificationClose:NO];
                                    [self _getDelegateToRelogin];
                                }
                                
                            }else{
//                                NSLog(@"connectionCloseCallBack if (self.authFinish) {");
                                if (self.authFinish) {
//                                    NSLog(@"connectionCloseCallBack [self _byeCloseConnect:YES];");
                                    [self _byeCloseConnect:YES];
                                }
                                
                            }
                        }
                        
                    }else{
//                        NSLog(@"connectionCloseCallBack else");
                        @synchronized (self) {
                            self.isOverlookFpnnCloseCallBack = NO;
                        }
                    }
                    
                    
                }


            };
            
                
            _authClient.listenAndReplyCallBack = ^FPNNAnswer * _Nullable(NSDictionary * _Nullable data, NSString * _Nullable method) {
                
                FPNSLog(@"listenAndReplyCallBack %@ %@",method,data);
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
//                        NSLog(@"kickoutkickoutkickout");

                        if (self.connectStatus == RTMClientConnectStatusConnected) {
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
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    

                    [self messageShareCenter:data method:method];

                    
                    
//                });
                
                
                return [RTMAnswer emptyAnswer];
                
                
                
                
            };
                
                }
            
        }
        return _authClient;
        
    
    
}
-(void)dealloc{
    FPNSLog(@"RTMClient dealloc");
//    [_authClient closeConnect];
//    [_whichClient closeConnect];
//    _authClient = nil;
//    _whichClient = nil;
    [self _cancelPingTimer];
    if (self.loginTimeoutTimer) {
        dispatch_cancel(self.loginTimeoutTimer);
        self.loginTimeoutTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSThread sleepForTimeInterval:0.2];
}
@end






