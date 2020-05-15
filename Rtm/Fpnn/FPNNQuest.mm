//
//  FPNNQuest.m
//  Fpnn
//
//  Created by zsl on 2019/11/22.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#include "TCPClient.h"
#import "FPNNQuest.h"
#import "NSDictionary+MsgPack.h"
@interface FPNNQuest()
@property(nonatomic,assign)fpnn::FPQuestPtr quest;
@end

@implementation FPNNQuest


- (instancetype)initWithMethod:(NSString*)method message:(NSDictionary*)message twoWay:(BOOL)isTwoWay{
    self = [super init];
    if (self) {
        
        
        if (method == nil) {
            FPNSLog(@"fpnn FPNNQuest init error. Please input valid method");
            return nil;
        }
        
        if (message == nil) {
            message = @{};
        }
    
        _twoWay = isTwoWay;
        _message = message;
        _method = method;
        
        _quest = fpnn::FPQWriter::emptyQuest(method.UTF8String,isTwoWay == YES ? false : true);
        std::string msgPackResult = _message.msgPack;
    
        if (!msgPackResult.empty()) {
            _quest->setPayload(msgPackResult);
            _quest->setPayloadSize((uint32_t)msgPackResult.length());
        }else{
            FPNSLog(@"fpnn ocQuest encode to cppQuest fail");
            return nil;
        }
        
        
    }
    return self;
}
+ (instancetype)questWithMethod:(NSString*)method message:(NSDictionary*)message twoWay:(BOOL)isTwoWay{
    return [[self alloc]initWithMethod:method message:message twoWay:isTwoWay];
}

//- (instancetype)initWithMethod:(NSString * _Nonnull)method twoWay:(BOOL)isTwoWay{
//    self = [super init];
//    if (self) {
//
//        if (method == nil) {
//            FPNSLog(@"fpnn FPNNQuest init error. Please input valid method");
//            return nil;
//        }
//
//        _twoWay = isTwoWay;
//        _message = @{};
//        _method = method;
//
//        _quest = fpnn::FPQWriter::emptyQuest(method.UTF8String,isTwoWay == YES ? false : true);
//        std::string msgPackResult = _message.msgPack;
//        if (!msgPackResult.empty()) {
//            _quest->setPayload(msgPackResult);
//            _quest->setPayloadSize((uint32_t)msgPackResult.length());
//        }else{
//            FPNSLog(@"fpnn ocQuest encode to cppQuest fail");
//            return nil;
//        }
//    }
//    return self;
//}
//+ (instancetype)questWithMethod:(NSString * _Nonnull)method twoWay:(BOOL)isTwoWay{
//    return [[self alloc]initWithMethod:method twoWay:isTwoWay];
//}

- (void *)getQuest{
    void * point = &_quest;
    return point;
}

- (void)dealloc{
    //FPNSLog(@"FPNNQuest dealloc");
}
@end



