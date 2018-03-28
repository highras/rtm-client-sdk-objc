//
//  FPNNMessageConvertor.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/20.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "FPNNCppSDK.hpp"
#include "PayloadDictionaryBuildDelegate.hpp"
#import "PayloadDictionaryBuilder.h"
#import "FPNNAnswer.h"
#import "FPNNMessageConvertor.h"

@implementation FPNNMessageConvertor

+ (NSDictionary*)convertFPQuest:(const void*)quest
{
    const fpnn::FPQuestPtr cppQuest = *((const fpnn::FPQuestPtr*)quest);
    const std::string& cppPayload = cppQuest->payload();
    
    PayloadDictionaryBuilder* ocBuilder = [[PayloadDictionaryBuilder alloc] init];
    PayloadDictionaryBuildDelegate msgVisitor((__bridge void*)ocBuilder,
                                   ocBuilder.actionFunc,
                                   ocBuilder.addPositiveIntFunc,
                                   ocBuilder.addNegativeIntFunc,
                                   ocBuilder.addFloatFunc,
                                   ocBuilder.addDoubleFunc,
                                   ocBuilder.addStringFunc,
                                               ocBuilder.addBinaryFunc);
    
    std::size_t off = 0;
    if (msgpack::parse(cppPayload.c_str(), cppPayload.length(), off, msgVisitor) == false)
        return nil;
    
    if (!ocBuilder.buildFinish)
        return nil;
    
    return ocBuilder.payload;
}

+ (FPNNAnswer*)convertFPAnswer:(const void*)answer
{
    const fpnn::FPAnswerPtr cppAnswer = *((const fpnn::FPAnswerPtr*)answer);
    if (cppAnswer->status() != 0)
    {
        fpnn::FPAReader ar(cppAnswer);
        int code = (int)ar.getInt("code", fpnn::FPNN_EC_CORE_UNKNOWN_ERROR);
        std::string ex = ar.getString("ex");
        
        return [FPNNAnswer answerWithErrorCode:code andDescription:[NSString stringWithUTF8String:ex.c_str()]];
    }
    
    const std::string& cppPayload = cppAnswer->payload();
    
    PayloadDictionaryBuilder* ocBuilder = [[PayloadDictionaryBuilder alloc] init];
    PayloadDictionaryBuildDelegate msgVisitor((__bridge void*)ocBuilder,
                                              ocBuilder.actionFunc,
                                              ocBuilder.addPositiveIntFunc,
                                              ocBuilder.addNegativeIntFunc,
                                              ocBuilder.addFloatFunc,
                                              ocBuilder.addDoubleFunc,
                                              ocBuilder.addStringFunc,
                                              ocBuilder.addBinaryFunc);
    
    std::size_t off = 0;
    if (msgpack::parse(cppPayload.c_str(), cppPayload.length(), off, msgVisitor) == false)
        return [FPNNAnswer answerWithErrorCode:fpnn::FPNN_EC_CORE_DECODING andDescription:@"Convert answer payload to Objective-C failed. Visitor error."];
    
    if (!ocBuilder.buildFinish)
        return [FPNNAnswer answerWithErrorCode:fpnn::FPNN_EC_CORE_DECODING andDescription:@"Convert answer payload to Objective-C failed. Uncompleted data."];
    
    return [FPNNAnswer answerWithPayload:ocBuilder.payload];
}

@end
