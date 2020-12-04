//
//  FPNNTCPClient.m
//  Fpnn
//
//  Created by zsl on 2019/11/22.
//  Copyright © 2019 FunPlus. All rights reserved.
//
//#include "FPNNCppSDK.hpp"

#include "TCPClient.h"
#import "FPNNCallBackHandler.h"
#import "FPNNTCPClient.h"
#import "FPNNQuest.h"
#import "FPNNAsyncAnswer.h"
#import "FPNNAnswer.h"
@interface FPNNTCPClient()
//{
//    int _questTimeout;
//    BOOL _autoReconnect;
//    //fpnn::TCPClientPtr  _client;
//}
@property(nonatomic,assign)fpnn::TCPClientPtr client;
@property(nonatomic,assign)FPNNCppConnectionListenPtr listenCall;

@end


@implementation FPNNTCPClient

#pragma mark init

- (void)_initDefaultParameters{
    _autoReconnect = YES;
    _ocFpnnSdkVersion = @"2.0.0";
}
- (instancetype)initWithEndpoint:(NSString *)endpoint{
    
   
    if (endpoint == nil) {
        FPNSLog(@"fpnn FPNNTCPClient init error. Please input valid endpoint");
        return nil;
    }
    
    self = [super init];
    if (self) {
        [self _initDefaultParameters];
        _client = fpnn::TCPClient::createClient(endpoint.UTF8String, _autoReconnect == YES ? true : false);
    }
    return self;
}

- (instancetype)initWithHost:(NSString *)host port:(int)port{
    
    if (host == nil) {
        FPNSLog(@"fpnn FPNNTCPClient init error. Please input valid host");
        return nil;
    }
    
    self = [super init];
    if (self) {
        [self _initDefaultParameters];
        _client = fpnn::TCPClient::createClient(host.UTF8String, port,_autoReconnect == YES ? true : false);
        
    }
    return self;
}

+ (instancetype)clientWithEndpoint:(NSString *)endpoint{
    return [[self alloc] initWithEndpoint:endpoint];
}

+ (instancetype)clientWithHost:(NSString *)host port:(int)port{
    return [[self alloc] initWithHost:host port:port];
}

#pragma mark get set

- (void *)getPrivateClient{
    void * clientPoint = &_client;
    return clientPoint;
}

- (void *)getPrivatelistenCall{
    void * listenPoint = &_listenCall;
    return listenPoint;
}

- (void)setQuestTimeout:(int)questTimeout{
    _questTimeout = questTimeout;
    if (_client != nil) {
        _client->setQuestTimeout(questTimeout);
    }
}

- (void)setAutoReconnect:(BOOL)autoReconnect{
    _autoReconnect = autoReconnect;
    if (_client != nil) {
        _client->setAutoReconnect(autoReconnect == YES ? true : false);
    }
}
-(void)setNilValueForKey:(NSString *)key{
    //不重写 kvc 设置常量为nil 会return
}

-(void)dealloc{
    _client.reset();
    _client = nullptr;
//    if (_client == nullptr) {
//        NSLog(@"析构析构析构");
//    }else{
//        NSLog(@"没有没有没有析构析构析构");
//    }
    FPNSLog(@"FPNNTCPClient dealloc");
}


@end
