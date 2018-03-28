//
//  FPNNQuestProcessor.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPQuestProcessorDelegate.hpp"
#import "DictionaryToMsgPackConvertor.h"
#import "FPNNMessageConvertor.h"
#import "FPNNQuestProcessor.h"
#import "FPNNAnswer.h"

@interface FPNNQuestProcessor ()

- (void*)processQuest:(const void*)rawQuest withCppProcessor:(void*)CppProcessor;

@end

void connectedEventFuncObj(void* obj) {
    [(__bridge FPNNQuestProcessor*)obj connected];
}

void connectionCloseEventFuncObj(void* obj, int closedByError) {
    [(__bridge FPNNQuestProcessor*)obj connectionWillClose:(closedByError ? YES : NO)];
}

void* questEventFuncObj(void* obj, const void* rawQuest, void* CppProcessor) {
    return [(__bridge FPNNQuestProcessor*)obj processQuest:rawQuest withCppProcessor:CppProcessor];
}

thread_local FPQuestProcessorDelegate* tl_processor;

@implementation FPNNQuestProcessor

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectedEventCallback = connectedEventFuncObj;
        _closeEventCallback = connectionCloseEventFuncObj;
        _questEventCallback = questEventFuncObj;
    }
    return self;
}

- (void)connected
{
}

- (void)connectionWillClose:(BOOL)closeByError
{
}

- (FPNNAsyncAnswer*)genAsyncAnswer
{
    fpnn::IAsyncAnswerPtr asynAnswer = tl_processor->genAsyncAnswer();
    if (asynAnswer)
    {
        FPNNAsyncAnswer* async = [[FPNNAsyncAnswer alloc] initWithCppAsyncAnswer:&asynAnswer];
        return async;
    }
    else
        return nil;
}

- (void*)processQuest:(const void*)rawQuest withCppProcessor:(void*)CppProcessor
{
    tl_processor = (FPQuestProcessorDelegate*)CppProcessor;
    
    FPNNAnswer* answer = nil;
    const fpnn::FPQuestPtr quest = *((const fpnn::FPQuestPtr*)rawQuest);
    NSString* method = [NSString stringWithUTF8String:quest->method().c_str()];
    
    // - (FPNNAnswer*)<methodName>:(NSDictionary*)params;
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", method]);
    if([self respondsToSelector:sel])
    {
        NSDictionary* params = [FPNNMessageConvertor convertFPQuest:rawQuest];
        if (params)
        {
            typedef FPNNAnswer* (*QuestMethod) (id, SEL, NSDictionary*);
            IMP imp = [self methodForSelector:sel];
            QuestMethod func = (QuestMethod)imp;
            
            answer = func(self, sel, params);
            if (answer)
            {
                //-- do nothing.
            }
            else
                return NULL;
        }
        else
        {
            if (quest->isTwoWay())
                answer = [FPNNAnswer answerWithErrorCode:fpnn::FPNN_EC_CORE_DECODING andDescription:@"Convert quest payload to Objective-C failed."];
        }
    }
    else
    {
        if (quest->isTwoWay())
            answer = [FPNNAnswer answerWithErrorCode:fpnn::FPNN_EC_CORE_UNKNOWN_METHOD];
    }
    
    if (answer)
    {
        //-- fpnnAnswer delete in FPQuestProcessorDelegate::processQuest().
        fpnn::FPAnswerPtr* fpnnAnswer = new fpnn::FPAnswerPtr;
        
        int size = (int)[answer.payload count];
        if (size)
        {
            std::string msgBuf;
            DictionaryToMsgPackConvertor* convertor = [[DictionaryToMsgPackConvertor alloc] init];
            if ([convertor convertFrom:answer.payload toCppString:&msgBuf])
            {
                fpnn::FPAnswerPtr cppAnswer = fpnn::FPAWriter::emptyAnswer(quest);
                cppAnswer->setPayload(msgBuf);
                cppAnswer->setPayloadSize((uint32_t)msgBuf.length());
                *fpnnAnswer = cppAnswer;
            }
            else
                *fpnnAnswer = fpnn::FPAWriter::errorAnswer(quest, fpnn::FPNN_EC_CORE_ENCODING, "Concert answer payload to msgPack failed.", "FPNN Objective-C SDK (Base on C++)");
        }
        else
            *fpnnAnswer = fpnn::FPAWriter::emptyAnswer(quest);
        
        return fpnnAnswer;
    }
    
    return NULL;
}

- (BOOL)sendEmptyAnswer
{
    FPNNAsyncAnswer* async = [self genAsyncAnswer];
    if (async)
        return [async sendEmptyAnswer];
    else
        return NO;
}

- (BOOL)sendAnswer:(FPNNAnswer*)answer
{
    if (!answer)
        return NO;
    
    return [self sendAnswerWithPayload:answer.payload];
}

- (BOOL)sendAnswerWithPayload:(NSDictionary*)payload
{
    FPNNAsyncAnswer* async = [self genAsyncAnswer];
    if (async)
        return [async sendAnswerWithPayload:payload];
    else
        return NO;
}

- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode
{
    FPNNAsyncAnswer* async = [self genAsyncAnswer];
    if (async)
        return [async sendErrorAnswerWithErrorCode:errorCode];
    else
        return NO;
}

- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message
{
    FPNNAsyncAnswer* async = [self genAsyncAnswer];
    if (async)
        return [async sendErrorAnswerWithErrorCode:errorCode andDescription:message];
    else
        return NO;
}

@end
