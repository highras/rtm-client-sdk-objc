//
//  FPNNIAsyncAnswer.m
//  Fpnn
//
//  Created by zsl on 2019/11/25.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#include "TCPClient.h"
#import "FPNNAsyncAnswer.h"
#import "FPNNAnswer.h"
#import "FPNNCallBackHandler.h"
#import "NSDictionary+MsgPack.h"
#import "FPNError.h"


#define ListenWithClient(client) *(FPNNCppConnectionListenPtr*)((void* (*)(id, SEL))[client methodForSelector:NSSelectorFromString(@"getPrivatelistenCall")])(client, NSSelectorFromString(@"getPrivatelistenCall"))

@interface FPNNAsyncAnswer(){
   
    
}
@property(nonatomic,assign)fpnn::IAsyncAnswerPtr asynAnswer;
@property(nonatomic,weak)FPNNTCPClient * client;

@end
//无效
//thread_local FPNNCppConnectionListen * tl_processor;
FPNNCppConnectionListen * tl_processor;

@implementation FPNNAsyncAnswer
- (instancetype)initWithClient:(FPNNTCPClient*)client{
    if (client == nil) {
        FPNSLog(@"fpnn FPNNAsyncAnswer init error. Please input valid client");
        return nil;
    }
    self = [super init];
    if (self) {
        _client = client;
        if ([self _get_tl_processor] == NO) {
            return nil;
        };
    }
    return self;
}

- (instancetype)initWithClient:(FPNNTCPClient * _Nonnull)client answerMessage:(NSDictionary*)message{
    if (client == nil) {
        FPNSLog(@"fpnn FPNNAsyncAnswer init error. Please input valid client");
        return nil;
    }
    self = [super init];
    if (self) {
        _answerMessage = message;
        _client = client;
        if ([self _get_tl_processor] == NO) {
            return nil;
        };
    }
    return self;
}

- (instancetype)initWithClient:(FPNNTCPClient * _Nonnull)client answer:(FPNNAnswer*)answer{
    if (client == nil) {
        FPNSLog(@"fpnn FPNNAsyncAnswer init error. Please input valid client");
        return nil;
    }
    self = [super init];
    if (self) {
        _answerMessage = answer.responseData == nil ? @{} : answer.responseData;
        _client = client;
        if ([self _get_tl_processor] == NO) {
            return nil;
        };
    }
    return self;
}

- (instancetype)initWithClient:(FPNNTCPClient * _Nonnull)client error:(nonnull FPNError *)error{
    if (client == nil) {
        FPNSLog(@"fpnn FPNNAsyncAnswer init error. Please input valid client");
        return nil;
    }
    self = [super init];
    if (self) {
        _client = client;
        _error = error;
        if ([self _get_tl_processor] == NO) {
            return nil;
        };
    }
    return self;
}

+ (instancetype)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client{
    return [[FPNNAsyncAnswer alloc]initWithClient:client];
}

+ (instancetype)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client answerMessage:(NSDictionary*)message{
    return [[FPNNAsyncAnswer alloc]initWithClient:client answerMessage:message];
}

+ (instancetype)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client answer:(FPNNAnswer*)answer{
    return [[FPNNAsyncAnswer alloc]initWithClient:client answer:answer];
}

+ (instancetype)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client error:(nonnull FPNError *)error{
    return [[FPNNAsyncAnswer alloc]initWithClient:client error:error];
}

-(BOOL)_get_tl_processor{
    FPNNCppConnectionListenPtr listen = ListenWithClient(_client);
    tl_processor = listen.get();
    _asynAnswer = tl_processor->genAsyncAnswer();
    if (_asynAnswer == nullptr) {
        FPNSLog(@"fpnn get listenProcessor is fail");
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)sendAnswerMessage{
    
    if (_answerMessage == nil) {
        _answerMessage = @{};
    }
    fpnn::FPAnswerPtr answer = fpnn::FPAWriter::emptyAnswer(_asynAnswer->getQuest());

    std::string msgPackResult = _answerMessage.msgPack;
    if (!msgPackResult.empty()) {
        answer->setPayload(msgPackResult);
        answer->setPayloadSize((uint32_t)msgPackResult.length());
    }else{
        FPNSLog(@"fpnn oc AsyncAnswer encode to cppAnswer is fail");
        return NO;
    }
    
    return (BOOL)_asynAnswer->sendAnswer(answer);
}

- (BOOL)sendEmptyAnswerMessage{
    if (_asynAnswer) {
        return _asynAnswer->sendEmptyAnswer();
    }else{
        return NO;
    }
}

- (BOOL)sendErrorAnswerMessage{
    if (_asynAnswer) {
        NSString * errorMessage = _error.ex == nil ? @"" : _error.ex;
        return _asynAnswer->sendErrorAnswer((int)_error.code,[errorMessage UTF8String]);
    }else{
        return NO;
    }
}

-(void)dealloc{
    //FPNSLog(@"FPNNIAsyncAnswer dealloc");
}

@end

