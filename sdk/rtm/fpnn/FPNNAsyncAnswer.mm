//
//  FPNNAsyncAnswer.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/20.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "FPNNCppSDK.hpp"
#import "FPNNMessageConvertor.h"
#import "DictionaryToMsgPackConvertor.h"
#import "FPNNAsyncAnswer.h"

@implementation FPNNAsyncAnswer
{
    fpnn::IAsyncAnswerPtr _asyncAnswer;
}

- (instancetype)initWithCppAsyncAnswer:(void*)ptr
{
    self = [super init];
    if (self)
    {
        _asyncAnswer = *((fpnn::IAsyncAnswerPtr*)ptr);
    }
    return self;
}

- (BOOL)sendEmptyAnswer
{
    return _asyncAnswer->sendEmptyAnswer();
}

- (BOOL)sendAnswer:(FPNNAnswer*)answer
{
    if (!answer)
        return NO;
    
    return [self sendAnswerWithPayload:answer.payload];
}

- (BOOL)sendAnswerWithPayload:(NSDictionary*)payload
{
    int size = (int)[payload count];
    if (size)
    {
        std::string msgBuf;
        DictionaryToMsgPackConvertor* convertor = [[DictionaryToMsgPackConvertor alloc] init];
        if (![convertor convertFrom:payload toCppString:&msgBuf])
            return NO;
        
        fpnn::FPAnswerPtr answer = fpnn::FPAWriter::emptyAnswer(_asyncAnswer->getQuest());
        answer->setPayload(msgBuf);
        answer->setPayloadSize((uint32_t)msgBuf.length());
        
        return _asyncAnswer->sendAnswer(answer);
    }
    else
        return _asyncAnswer->sendEmptyAnswer();
}

- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode
{
    return _asyncAnswer->sendErrorAnswer(errorCode, NULL, NULL);
}

- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message
{
    if (message != nil)
        return _asyncAnswer->sendErrorAnswer(errorCode, [message UTF8String]);
    else
        return _asyncAnswer->sendErrorAnswer(errorCode, NULL, NULL);
}

- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message withRaiser:(NSString*)raiser
{
    char *ex = NULL;
    char *rs = NULL;
    
    if (message)
        ex = (char*)[message UTF8String];
    
    if (raiser)
        rs = (char*)[raiser UTF8String];
    
    return _asyncAnswer->sendErrorAnswer(errorCode, ex, rs);
}

@end
