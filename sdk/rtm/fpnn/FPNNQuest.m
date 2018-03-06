//
//  FPNNQuest.m
//  fpnn
//
//  Created by 施王兴 on 2017/12/28.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNQuest.h"

@implementation FPNNQuest

+ (instancetype)quest:(NSString*)method
{
    return [[FPNNQuest alloc] init:method];
}
+ (instancetype)quest:(NSString*)method withPayload:(NSDictionary*)payload
{
    return [[FPNNQuest alloc] init:method withPayload:payload];
}

+ (instancetype)oneWayQuest:(NSString*)method
{
    return [[FPNNQuest alloc] initOneWayQuest:method];
}
+ (instancetype)oneWayQuest:(NSString*)method withPayload:(NSDictionary*)payload
{
    return [[FPNNQuest alloc] initOneWayQuest:method withPayload:payload];
}


- (instancetype)init:(NSString*)method
{
    self = [super init];
    if (self)
    {
        _twoway = YES;
        _method = method;
    }
    return self;
}
- (instancetype)init:(NSString*)method withPayload:(NSDictionary*)payload
{
    self = [super initWithPayload:payload];
    if (self)
    {
        _twoway = YES;
        _method = method;
    }
    return self;
}

- (instancetype)initOneWayQuest:(NSString*)method
{
    self = [super init];
    if (self)
    {
        _twoway = NO;
        _method = method;
    }
    return self;
}
- (instancetype)initOneWayQuest:(NSString*)method withPayload:(NSDictionary*)payload
{
    self = [super initWithPayload:payload];
    if (self)
    {
        _twoway = NO;
        _method = method;
    }
    return self;
}

@end
