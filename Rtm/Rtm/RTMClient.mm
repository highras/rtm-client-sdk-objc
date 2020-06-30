//
//  RTMClient.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#import "RTMClientManger.h"
#import "RTMClient.h"
#import "RTMIPv6Adapter.h"
#import "Fpnn.h"
#import "FPNError.h"
#import "RTMClient+User.h"
#import <objc/runtime.h>
#import "RTMAudioTools.h"


//#define IOS_CELLULAR    @"pdp_ip0"
//#define IOS_WIFI        @"en0"
//#define IOS_VPN         @"utun0"
//#define IP_ADDR_IPv4    @"ipv4"
//#define IP_ADDR_IPv6    @"ipv6"
//#import <ifaddrs.h>
//#import <arpa/inet.h>
//#import <net/if.h>

@interface RTMClient()

@property(nonatomic,strong)FPNNTCPClient * rtmGatedClient;
@property(nonatomic,strong)NSString * rtmGatedEndPoint;

@property(nonatomic,strong)FPNNTCPClient * authClient;
@property(nonatomic,strong)NSString * authEndPoint;

@property(nonatomic,strong)FPNNTCPClient * usingClient;

@property(nonatomic,copy)RTMConnectSuccessCallBack connectSuccessBlock;
@property(nonatomic,copy)RTMConnectFailCallBack connectFailBlock;
@property(nonatomic,strong)NSMutableDictionary * gatedQuestDic;
@property(nonatomic,assign)BOOL authFinish;

@property(nonatomic,strong)NSCache * fileClientCache;
@property(nonatomic,strong)dispatch_source_t pingTimer;
@property(nonatomic,strong)NSDate * lastPingTime;

@property(nonatomic,strong)NSCache * messageDuplicatedCache;

@property(nonatomic,assign)long long  messageId;

@property(nonatomic,assign)RTMClientStatus connectStatus;
@end

@implementation RTMClient
#pragma mark init
- (void)_defaultSettings{
//    _clientStatus = RTMConnectClose;
    _sdkVersion = @"2.0.1";
    _apiVersion = @"2.1.0";
    _connectStatus = RTMConnectClose;
    _sendQuestTimeout = 30;
//    _version = nil;
    _lang = nil;
    _attrs = nil;
    _os = nil;
    _addrType = nil;
    _proto = nil;
    _fileClientCache = [[NSCache alloc]init];
    _fileClientCache.countLimit = 5;
    _messageDuplicatedCache = [[NSCache alloc]init];
    _messageDuplicatedCache.countLimit = 10000;
    _messageId = [[NSDate date] timeIntervalSince1970] * 1000 * 1000;
    
    //....
}
- (BOOL)_initializeExceptionHandle{
    if (_rtmGatedEndPoint == nil || _pid == 0 || _uid == 0 || _token == nil) {
        return NO;
    }
    return YES;
}
- (instancetype _Nullable)initWithEndpoint:(NSString * _Nonnull)endpoint pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token{
    self = [super init];
    if (self) {
        
        _rtmGatedEndPoint = endpoint;
        _pid = pid;
        _uid = uid;
        _token = token;
        
        if ([self _initializeExceptionHandle]) {
            [self _defaultSettings];
        }else{
            FPNSLog(@"rtm initClient invalid parameter");
            return nil;
        }

        ((void* (*)(id, SEL,RTMClient*))[[RTMClientManger shareInstance] methodForSelector:NSSelectorFromString(@"addRecordClient:")])([RTMClientManger shareInstance], NSSelectorFromString(@"addRecordClient:"),self);
        
    }
    return self;
}
- (instancetype _Nullable)initWithHost:(NSString * _Nonnull)host port:(int)port pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token{
    self = [super init];
    if (self) {
        
        _rtmGatedEndPoint = [NSString stringWithFormat:@"%@:%d",host,port];;
        _pid = pid;
        _uid = uid;
        _token = token;
        
        if ([self _initializeExceptionHandle]) {
            [self _defaultSettings];
        }else{
            FPNSLog(@"rtm initClient invalid parameter");
            return nil;
        }
        
        ((void* (*)(id, SEL,RTMClient*))[[RTMClientManger shareInstance] methodForSelector:NSSelectorFromString(@"addRecordClient:")])([RTMClientManger shareInstance], NSSelectorFromString(@"addRecordClient:"),self);
    }
    return self;
}
+ (instancetype _Nullable)clientWithEndpoint:(NSString * _Nonnull)endpoint pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token{
    return [[self alloc]initWithEndpoint:endpoint pid:pid uid:uid token:token];
}
+ (instancetype _Nullable)clientWithHost:(NSString * _Nonnull)host port:(int)port pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token{
    return [[self alloc]initWithHost:host port:port pid:pid uid:uid token:token];
}

#pragma mark Handle
- (void)verifyConnectSuccess:(RTMConnectSuccessCallBack)success connectFali:(RTMConnectFailCallBack)fail{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
        @synchronized (self) {
            
            self.connectSuccessBlock = success;
            self.connectFailBlock = fail;
            self.connectStatus = RTMConnecting;
        
            self.gatedQuestDic = [NSMutableDictionary dictionary];
            [self.gatedQuestDic setValue:@"rtmGated" forKey:@"what"];
            if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
                [self.gatedQuestDic setValue:@"ipv6" forKey:@"addrType"];
            }else{
                [self.gatedQuestDic setValue:self.addrType forKey:@"addrType"];
            }
            [self.gatedQuestDic setValue:self.proto forKey:@"proto"];
//            [self.gatedQuestDic setValue:self.apiVersion forKey:@"version"];
        
        }
        
        [self _rtmGatedQuestHandle];
        
    });
    
}


-(void)_rtmGatedAllQuestHandle{
    @synchronized (self) {
        self.rtmGatedClient = [FPNNTCPClient clientWithEndpoint:_rtmGatedEndPoint];
    }
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"whichall" message:_gatedQuestDic twoWay:YES];
    @rtmWeakify(self);
    BOOL result = [self.rtmGatedClient sendQuest:quest timeout:self.sendQuestTimeout success:^(NSDictionary * _Nullable data) {
        @rtmStrongify(self);
        NSArray * endpointsArray = data[@"endpoints"];
        if (RTMNullString(endpointsArray.firstObject) == NO) {
            
            [self.rtmGatedClient closeConnect];
            
            @synchronized (self) {
                self.authEndPoint = endpointsArray.firstObject;
                self.rtmGatedClient = nil;
            }
            [self _authQuestHandle];
                
        }else{
            
            @synchronized (self) {
                self.connectStatus = RTMConnectFail;
            }
            FPNError * error = [FPNError errorWithEx:@"method whichall quest , answer endpoint is nil" code:300000];
            if (self.connectFailBlock) {
                self.connectFailBlock(error);
            }
            [self.rtmGatedClient closeConnect];
                
        }
        
    } fail:^(FPNError * _Nullable error) {
        
        @rtmStrongify(self);
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [self.rtmGatedClient closeConnect];
        
    }];
    
    
    //无网络
    if (result == NO) {
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        FPNError * error = [FPNError errorWithEx:@"method whichall network error" code:300003];
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [_authClient closeConnect];
    }
}

-(void)_rtmGatedQuestHandle{
    @synchronized (self) {
        self.rtmGatedClient = [FPNNTCPClient clientWithEndpoint:_rtmGatedEndPoint];
    }
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"which" message:_gatedQuestDic twoWay:YES];
    @rtmWeakify(self);
    BOOL result = [self.rtmGatedClient sendQuest:quest timeout:self.sendQuestTimeout success:^(NSDictionary * _Nullable data) {
        @rtmStrongify(self);
//        NSLog(@"%@",data);
        NSString * endPoint = data[@"endpoint"];
        if (RTMNullString(endPoint) == NO) {
            
            [self.rtmGatedClient closeConnect];
            @synchronized (self) {
                self.authEndPoint = endPoint;
                self.rtmGatedClient = nil;
            }
            
            [self _authQuestHandle];
            
        }else{
            
            [self _rtmGatedAllQuestHandle];
            
        }
    } fail:^(FPNError * _Nullable error) {
        
        @rtmStrongify(self);
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [self.rtmGatedClient closeConnect];
        
    }];
    
    
    //无网络
    if (result == NO) {
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        FPNError * error = [FPNError errorWithEx:@"method which network error" code:300002];
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [_authClient closeConnect];
    }
}
-(void)_authQuestHandle{
    
    NSMutableDictionary * questDic = [NSMutableDictionary dictionary];
    [questDic setValue:@(_pid) forKey:@"pid"];
    [questDic setValue:@(_uid) forKey:@"uid"];
    [questDic setValue:_token forKey:@"token"];
    [questDic setValue:_sdkVersion forKey:@"version"];
    [questDic setValue:_lang forKey:@"lang"];
    [questDic setValue:_attrs forKey:@"attrs"];
    [questDic setValue:_os forKey:@"os"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"auth" message:questDic twoWay:YES];
    @rtmWeakify(self);
    BOOL result = [self.authClient sendQuest:quest timeout:self.sendQuestTimeout success:^(NSDictionary * _Nullable data) {
        @rtmStrongify(self);
        
            if ([data[@"ok"] boolValue]) {
                @synchronized (self) {
                    self.connectStatus = RTMConnected;
                    self.authFinish = YES;
                    self.usingClient = self.authClient;
                }
                self.usingClient.connectionSuccessCallBack();
                if (self.connectSuccessBlock) {
                    self.connectSuccessBlock(data);
                }
                
            }else{
                
                NSString * endPoint = data[@"gate"];
                if (RTMNullString(endPoint) == NO) {
                    @synchronized (self) {
                        self.authFinish = NO;
                        self.authEndPoint = endPoint;
                        [self.authClient closeConnect];
                        self.authClient = nil;
                    }
                    [self _authQuestHandle];
                }else{
                    @synchronized (self) {
                        self.connectStatus = RTMConnectFail;
                    }
                    FPNError * error = [FPNError errorWithEx:@"method auth quest , answer gate is nil" code:300001];
                    if (self.connectFailBlock) {
                        self.connectFailBlock(error);
                    }
                    [self.authClient closeConnect];

                }
                
            }
        
    } fail:^(FPNError * _Nullable error) {
        @rtmStrongify(self);
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [self.authClient closeConnect];
    }];
    
    //无网络
    if (result == NO) {
        @synchronized (self) {
            self.connectStatus = RTMConnectFail;
        }
        FPNError * error = [FPNError errorWithEx:@"method auth network error" code:300004];
        if (self.connectFailBlock) {
            self.connectFailBlock(error);
        }
        [_authClient closeConnect];
    }
}
- (void)closeConnect{
    
    if (self.connectStatus == RTMConnected) {
        [self offLineWithTimeout:_sendQuestTimeout tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
        
        } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
            
        }];
        sleep(1);
        [self.usingClient closeConnect];
        [self _cancelPingTimer];
    }
    
}
- (void)reconnect{
    
//    if (self.clientStatus == RTMConnectFail || self.clientStatus == RTMConnectClose) {
        
//        [_usingClient closeConnect];
    
        [self closeConnect];
        
        @synchronized (self) {
            self.authFinish = NO;
            self.connectStatus = RTMConnectClose;
            [self.rtmGatedClient closeConnect];
            [self.authClient closeConnect];
            self.rtmGatedClient = nil;
            self.authClient = nil;
            self.usingClient = nil;
        }
        
        [self _cancelPingTimer];
        [self _rtmGatedQuestHandle];
        
//    }
}
#pragma mark get set

//-(FPNNTCPClient*)rtmGatedClient{
//
//    @synchronized (self) {
//        _rtmGatedClient = [FPNNTCPClient clientWithEndpoint:_rtmGatedEndPoint];
//    }
//    return _rtmGatedClient;
//}
-(FPNNTCPClient*)authClient{
    @synchronized (self) {
        
        if (self.authFinish == NO && _authClient == nil) {
                _authClient = [FPNNTCPClient clientWithEndpoint:self.authEndPoint];
                @rtmWeakify(self);
                _authClient.connectionSuccessCallBack = ^{
                    @rtmStrongify(self);
                    
                    if (self.authFinish) {
                        
        //                if (self.connectStateSuccessBlock) {
        //                    self.connectStateSuccessBlock();
        //                }
                        
                        if ([self.delegate respondsToSelector:@selector(rtmConnectStateSuccess:)]) {
                            [self.delegate rtmConnectStateSuccess:self];
                        }
                        @synchronized (self) {
                            self.lastPingTime = [NSDate date];
                        }
                        if (self.pingTimer == nil) {
                            [self _startKeepTime];
                        }
                        
                    }
                };
                _authClient.connectionCloseCallBack = ^{
                    @rtmStrongify(self);
                    
                    if (self.authFinish) {
                        
        //                if (self.connectstateCloseBlock) {
        //                    self.connectstateCloseBlock();
        //                }
                        
                        @synchronized (self) {
                            self.connectStatus = RTMConnectClose;
                        }
                        [self _cancelPingTimer];
                        
                        if ([self.delegate respondsToSelector:@selector(rtmConnectstateClose:)]) {
                            [self.delegate rtmConnectstateClose:self];
                        }
                        
                    }
                };
                _authClient.listenAndReplyCallBack = ^FPNNAnswer * _Nullable(NSDictionary * _Nullable data, NSString * _Nullable method) {
                    @rtmStrongify(self);
//                    NSLog(@"listenAndReplyCallBack   %@",method);
                    if ([method isEqualToString:@"ping"]) {
                        @synchronized (self) {
                            self.lastPingTime = [NSDate date];
                        }
//                        if (self.pingTimer == nil) {
//                            [self _startKeepTime];
//                        }
                        return [RTMAnswer emptyAnswer];
                    }
                    
                    
                    
                    if ([method isEqualToString:@"pushmsg"]) {
                        
                        if ([self _duplicatedPushMsgFilter:method data:data] == NO) {
                            
                            int mtype = [[data objectForKey:@"mtype"] intValue];
                            if (mtype == 30) {
                                //chat 文字
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveP2PMessageChat:data:)]) {
                                    [self.delegate rtmReceiveP2PMessageChat:self data:data];
                                }
                                
                            }else if(mtype == 31){
                                //chat 语音
                                if (data == nil) {
                                    return [RTMAnswer emptyAnswer];
                                }
                                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
                                NSData * resultData = [RTMAudioTools audioDataRemoveHeader:[data objectForKey:@"msg"]];//去掉头的 音频数据
                                if (resultData == nil) {
                                    return [RTMAnswer emptyAnswer];
                                }else{
                                    [dic setValue:resultData forKey:@"msg"];
                                    if ([self.delegate respondsToSelector:@selector(rtmReceiveP2PAudioChat:data:)]) {
                                        [self.delegate rtmReceiveP2PAudioChat:self data:dic];
                                    }
                                }
                                
                                
                            }else if(mtype == 32){
                                //chat cmd
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveP2PCmdChat:data:)]) {
                                    [self.delegate rtmReceiveP2PCmdChat:self data:data];
                                }
                                
                            }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
                                //文件
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveP2PFileData:data:)]) {
                                    [self.delegate rtmReceiveP2PFileData:self data:data];
                                }
                                
                            }else{
                                //normal message
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveP2PData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
                                    
                                    [self.delegate rtmReceiveP2PData:self data:data];
                                    
                                }else if([self.delegate respondsToSelector:@selector(rtmReceiveP2PBinaryData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSData class]]){
                                    
                                    [self.delegate rtmReceiveP2PBinaryData:self data:data];
                                    
                                }
                                
                            }
                            
                        }
                            
                           
                        return [RTMAnswer emptyAnswer];
                            
                        
                    }
                    
                    
                    
                    if ([method isEqualToString:@"pushgroupmsg"]) {
                        
                        if ([self _duplicatedPushGroupMsgFilter:method data:data] == NO) {
                            int mtype = [[data objectForKey:@"mtype"] intValue];
                            if (mtype == 30) {
                                //chat 文字
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveGroupMessageChat:data:)]) {
                                    [self.delegate rtmReceiveGroupMessageChat:self data:data];
                                }
                                
                            }else if(mtype == 31){
                                //chat 语音
                                
                                if (data == nil) {
                                    return [RTMAnswer emptyAnswer];
                                }
                                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
                                NSData * resultData = [RTMAudioTools audioDataRemoveHeader:[data objectForKey:@"msg"]];//去掉头的 音频数据
                                if (resultData == nil) {
                                    
                                    return [RTMAnswer emptyAnswer];
                                    
                                }else{
                                    
                                    [dic setValue:resultData forKey:@"msg"];
                                    if ([self.delegate respondsToSelector:@selector(rtmReceiveGroupAudioChat:data:)]) {
                                        [self.delegate rtmReceiveGroupAudioChat:self data:dic];
                                    }
                                }
                                
                            }else if(mtype == 32){
                                //chat cmd
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveGroupCmdChat:data:)]) {
                                    [self.delegate rtmReceiveGroupCmdChat:self data:data];
                                }
                                
                            }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
                                //file
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveGroupFileData:data:)]) {
                                    [self.delegate rtmReceiveGroupFileData:self data:data];
                                }
                                
                            }else{
                                //normal
                                
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveGroupData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
                                    
                                    [self.delegate rtmReceiveGroupData:self data:data];
                                    
                                }else if([self.delegate respondsToSelector:@selector(rtmReceiveGroupBinaryData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSData class]]){
                                    
                                    [self.delegate rtmReceiveGroupBinaryData:self data:data];
                                    
                                }
                                
                            }
                            
                        }
                        
                        return [RTMAnswer emptyAnswer];;
                        
                    }
                    
                    if ([method isEqualToString:@"pushroommsg"]) {
                        
                        if ([self _duplicatedPushRoomMsgFilter:method data:data] == NO) {
                            
                            int mtype = [[data objectForKey:@"mtype"] intValue];
                            if (mtype == 30) {
                                //chat 文字
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveRoomMessageChat:data:)]) {
                                    [self.delegate rtmReceiveRoomMessageChat:self data:data];
                                }
                                
                            }else if(mtype == 31){
                                //chat 语音
                                if (data == nil) {
                                    return [RTMAnswer emptyAnswer];
                                }
                                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
                                NSData * resultData = [RTMAudioTools audioDataRemoveHeader:[data objectForKey:@"msg"]];//去掉头的 音频数据
                                if (resultData == nil) {
                                    
                                    return [RTMAnswer emptyAnswer];
                                    
                                }else{
                                    
                                    [dic setValue:resultData forKey:@"msg"];
                                    if ([self.delegate respondsToSelector:@selector(rtmReceiveRoomAudioChat:data:)]) {
                                        [self.delegate rtmReceiveRoomAudioChat:self data:dic];
                                    }
                                    
                                }
                                
                                
                            }else if(mtype == 32){
                                //chat cmd
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveRoomCmdChat:data:)]) {
                                    [self.delegate rtmReceiveRoomCmdChat:self data:data];
                                }
                                
                            }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
                                //file
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveRoomFileData:data:)]) {
                                    [self.delegate rtmReceiveRoomFileData:self data:data];
                                }
                                
                            }else{
                                //normal
                                
                    
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveRoomData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
                                    
                                    [self.delegate rtmReceiveRoomData:self data:data];
                                    
                                }else if([self.delegate respondsToSelector:@selector(rtmReceiveRoomBinaryData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSData class]]){
                                    
                                    [self.delegate rtmReceiveRoomBinaryData:self data:data];
                                    
                                }
                                
                                
                            }
                            
                        }
                            
                           
                        return [RTMAnswer emptyAnswer];;
                            
                        
                    }
                    
                    if ([method isEqualToString:@"pushbroadcastmsg"]) {
                        
                        if ([self _duplicatedPushBroadcastMsgFilter:method data:data] == NO) {
                            
                            int mtype = [[data objectForKey:@"mtype"] intValue];
                            if (mtype == 30) {
                                //chat 文字
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastMessageChat:data:)]) {
                                    [self.delegate rtmReceiveBroadcastMessageChat:self data:data];
                                }
                                
                            }else if(mtype == 31){
                                //chat 语音
                                if (data == nil) {
                                    return [RTMAnswer emptyAnswer];
                                }
                                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
                                NSData * resultData = [RTMAudioTools audioDataRemoveHeader:[data objectForKey:@"msg"]];//去掉头的 音频数据
                                if (resultData == nil) {
                                    
                                    return [RTMAnswer emptyAnswer];
                                    
                                }else{
                                    
                                    [dic setValue:resultData forKey:@"msg"];
                                    if ([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastAudioChat:data:)]) {
                                        [self.delegate rtmReceiveBroadcastAudioChat:self data:dic];
                                    }
                                    
                                }
                                
                                
                            }else if(mtype == 32){
                                //chat cmd
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastCmdChat:data:)]) {
                                    [self.delegate rtmReceiveBroadcastCmdChat:self data:data];
                                }
                                
                            }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
                                //file
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastFileData:data:)]) {
                                    [self.delegate rtmReceiveBroadcastFileData:self data:data];
                                }
                                
                            }else{
                                //normal
                                
                                if ([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
                                    
                                    [self.delegate rtmReceiveBroadcastData:self data:data];
                                    
                                }else if([self.delegate respondsToSelector:@selector(rtmReceiveBroadcastBinaryData:data:)] && [[data objectForKey:@"msg"] isKindOfClass:[NSData class]]){
                                    
                                    [self.delegate rtmReceiveBroadcastBinaryData:self data:data];
                                    
                                }
                                
                            }
                            
                        }
                            
                        return [RTMAnswer emptyAnswer];;
                        
                    }
                    
                    if ([method isEqualToString:@"kickoutroom"]) {
                        if ([self.delegate respondsToSelector:@selector(rtmRoomKickoutData:data:)]) {
                            [self.delegate rtmRoomKickoutData:self data:data];
                        }
                        return [RTMAnswer emptyAnswer];
                    }
                    
                    if ([method isEqualToString:@"kickout"]) {
                        [self.usingClient closeConnect];
                        if ([self.delegate respondsToSelector:@selector(rtmKickout:)]) {
                            [self.delegate rtmKickout:self];
                        }
                        return nil;//one way
                    }



        //            if (self.listenAndReplyMessageCallBack) {
        //                return self.listenAndReplyMessageCallBack(data, method);
        //            }
        //
        //            if ([self.delegate respondsToSelector:@selector(rtmListenAndReplyMessage:data:method:)]) {
        //                return [self.delegate rtmListenAndReplyMessage:self data:data method:method];
        //            }
                    
                    
                    return nil;
                };
            }
    }
    
    return _authClient;
}
-(BOOL)_duplicatedPushMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@",self.pid,self.uid,method,[data objectForKey:@"mid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
    
}
-(BOOL)_duplicatedPushGroupMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@-%@",self.pid,self.uid,method,[data objectForKey:@"mid"],[data objectForKey:@"gid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
    
}
-(BOOL)_duplicatedPushRoomMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@-%@",self.pid,self.uid,method,[data objectForKey:@"mid"],[data objectForKey:@"rid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
    
}
-(BOOL)_duplicatedPushBroadcastMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@",self.pid,self.uid,method,[data objectForKey:@"mid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
    
}
-(BOOL)_isExistMessage:(NSString*)msgCacheKey{
    
    @synchronized (self) {
        
        if ([self.messageDuplicatedCache objectForKey:msgCacheKey] == nil) {
            [self.messageDuplicatedCache setObject:@(YES) forKey:msgCacheKey];
            return NO;
        }else{
            return YES;
        }
        
    }
    
}
-(void)_startKeepTime{
    
   
    [self _cancelPingTimer];
//    FPNSLog(@"启动计时器");
        
    
    @synchronized (self) {
        
        if (self.connectStatus == RTMConnected) {
            
            uint64_t interval = 10 * NSEC_PER_SEC;
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
    
    if (self.connectStatus == RTMConnected) {
        
//        int interval = [self _numberOfDaysWithFromDate:self.lastPingTime];
        float f = self.lastPingTime.timeIntervalSinceNow;
//        FPNSLog(@"距离上次收到 ping 间隔 %f",-ceil(f));
        if (-ceil(f) < 19) {
            
        }else{
//            NSLog(@"断开");
            [self _cancelPingTimer];
            [self closeConnect];
//            [_usingClient closeConnect];
        }
        
    }
        
}
//- (int)_numberOfDaysWithFromDate:(NSDate *)fromDate{
//    return fromDate.timeIntervalSinceNow;
//}
-(void)_cancelPingTimer{
    @synchronized (self) {
        
        if (self.pingTimer) {
            dispatch_cancel(self.pingTimer);
            self.pingTimer = nil;
        }
        
    }
}
-(long long)_getMessageId{
    long long _resultId = _messageId;
    @synchronized (self) {
        _resultId = _messageId++;
    }
    return _resultId;
}
-(RTMClientStatus)clientStatus{
    return _connectStatus;
}
-(BOOL)isDisconnected{
    return _usingClient.isDisconnected;
}
-(BOOL)isConnected{
    return _usingClient.isConnected;
}
-(NSString *)connectedHost{
    return _usingClient.connectedHost;
}
-(int)connectedPort{
    return _usingClient.connectedPort;
}
-(void)setNilValueForKey:(NSString *)key{
    //不重写 kvc 设置常量为nil 会return
}
-(void)dealloc{
    [self.usingClient closeConnect];
    self.usingClient = nil;
    [self _cancelPingTimer];
//    FPNSLog(@"client dealloc");
}

//+ (BOOL)isIpv6{
//    NSArray *searchArray =
//    @[ IOS_VPN @"/" IP_ADDR_IPv6,
//       IOS_VPN @"/" IP_ADDR_IPv4,
//       IOS_WIFI @"/" IP_ADDR_IPv6,
//       IOS_WIFI @"/" IP_ADDR_IPv4,
//       IOS_CELLULAR @"/" IP_ADDR_IPv6,
//       IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//
//    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
//
//    __block BOOL isIpv6 = NO;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     {
//
//         NSLog(@"---%@---%@---",key, addresses[key] );
//
//         if ([key rangeOfString:@"ipv6"].length > 0  && ![[NSString stringWithFormat:@"%@",addresses[key]] hasPrefix:@"(null)"] ) {
//             NSLog(@"====");
//             if ( ![addresses[key] hasPrefix:@"fe80"]) {
//                 isIpv6 = YES;
//             }
//         }
//
//      } ];
//
//    return isIpv6;
//}
//
//
//+ (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                NSString *type;
//                if(addr->sin_family == AF_INET) {
//                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv4;
//
//                        NSLog(@"ipv4 %@",name);
//                    }
//                } else {
//                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv6;
//                        NSLog(@"ipv6 %@",name);
//
//                    }
//                }
//                if(type) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    return [addresses count] ? addresses : nil;
//}

@end
