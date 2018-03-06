//
//  FPNNAnswerCallback.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/21.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "FPNNCppSDK.hpp"
#import "FPNNAnswer.h"
#import "FPNNMessageConvertor.h"
#import "FPNNAnswerCallback.h"

//-----------------------[ FPNNAnswerCallback ]-----------------------------//
@interface FPNNAnswerCallback ()

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode;

@end

void answerCallbackFuncObj(void* obj, void* fpAnswer, int errorCode) {
    return [(__bridge FPNNAnswerCallback*)obj cppCallback:fpAnswer errorCode:errorCode];
}

@implementation FPNNAnswerCallback

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cppCallback = answerCallbackFuncObj;
    }
    return self;
}

- (void)onAnswer:(NSDictionary*)payload
{
}

- (void)onException:(int)errorCode payload:(NSDictionary*)payload
{
}

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode
{
    if (rawAnswer == NULL)
    {
        [self onException:errorCode payload:nil];
        return;
    }
    
    fpnn::FPAnswerPtr cppAnswer = *((fpnn::FPAnswerPtr*)rawAnswer);
    FPNNAnswer* answer = [FPNNMessageConvertor convertFPAnswer:&cppAnswer];
    
    if (errorCode == fpnn::FPNN_EC_OK)
    {
        if (answer.errorAnswer == NO)
            [self onAnswer:answer.payload];
        else        //-- For convert error.
            [self onException:fpnn::FPNN_EC_CORE_DECODING payload:answer.payload];
    }
    else
        [self onException:errorCode payload:answer.payload];
}

@end

//-----------------------[ FPNNAnswerBlockCallback ]-----------------------------//
@interface FPNNAnswerBlockCallback ()

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode;

@end


void answerBlockCallbackFuncObj(void* obj, void* fpAnswer, int errorCode) {
    return [(__bridge FPNNAnswerBlockCallback*)obj cppCallback:fpAnswer errorCode:errorCode];
}

typedef void(^FPAnswerCallbackBlock)(int errorCode, NSDictionary* payload);

@implementation FPNNAnswerBlockCallback
{
    FPAnswerCallbackBlock _block;
}

- (instancetype)initWithBlock:(void(^)(int errorCode, NSDictionary* payload))block
{
    self = [super init];
    if (self)
    {
        _block = block;
        self.cppCallback = answerBlockCallbackFuncObj;
    }
    return self;
}

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode
{
    FPNNAnswer* answer = nil;
    if (rawAnswer)
    {
        fpnn::FPAnswerPtr cppAnswer = *((fpnn::FPAnswerPtr*)rawAnswer);
        answer = [FPNNMessageConvertor convertFPAnswer:&cppAnswer];
        
        if (errorCode == fpnn::FPNN_EC_OK && answer.errorAnswer)      //-- For convert error.
            errorCode = fpnn::FPNN_EC_CORE_DECODING;
    }
    
    _block(errorCode, answer ? answer.payload : nil);
}

@end


//-----------------------[ FPNNSyncAnswerCallback ]-----------------------------//
@interface FPNNSyncAnswerCallback ()

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode;

@end

void syncAnswerCallbackFuncObj(void* obj, void* fpAnswer, int errorCode) {
    return [(__bridge FPNNSyncAnswerCallback*)obj cppCallback:fpAnswer errorCode:errorCode];
}

@implementation FPNNSyncAnswerCallback
{
    NSCondition* _condition;
    FPNNAnswer* _answer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _answer = nil;
        _condition = [[NSCondition alloc] init];
        self.cppCallback = syncAnswerCallbackFuncObj;
    }
    return self;
}

- (void)cppCallback:(void*)rawAnswer errorCode:(int)errorCode
{
    FPNNAnswer *answer;
    if (rawAnswer)
    {
        fpnn::FPAnswerPtr cppAnswer = *((fpnn::FPAnswerPtr*)rawAnswer);
        answer = [FPNNMessageConvertor convertFPAnswer:&cppAnswer];
    }
    else
        answer = [FPNNAnswer answerWithErrorCode:errorCode];
    
    [_condition lock];
    _answer = answer;
    [_condition signal];
    [_condition unlock];
}

- (FPNNAnswer*)getAnswer
{
    FPNNAnswer* answer;
    
    [_condition lock];
    while (_answer == nil)
        [_condition wait];
    
    answer = _answer;
    [_condition unlock];
    
    return answer;
}

@end

