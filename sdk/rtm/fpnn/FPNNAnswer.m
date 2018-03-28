//
//  FPNNAnswer.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNAnswer.h"

@implementation FPNNAnswer

- (instancetype)initEmptyAnswer
{
    self = [super init];
    if (self)
    {
        _errorAnswer = NO;
    }
    return self;
}

- (instancetype)initWithPayload:(NSDictionary*)payload
{
    self = [super initWithPayload:payload];
    if (self)
    {
        _errorAnswer = NO;
    }
    return self;
}

- (instancetype)initWithErrorCode:(int)errorCode
{
    NSMutableDictionary* payload = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:errorCode] forKey:@"code"];
    
    self = [super initWithPayload:payload];
    if (self)
    {
        _errorAnswer = YES;
    }
    return self;
}
- (instancetype)initWithErrorCode:(int)errorCode andDescription:(NSString*)message
{
    NSMutableDictionary* payload = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:errorCode], @"code", message, @"ex", nil];
    
    self = [super initWithPayload:payload];
    if (self)
    {
        _errorAnswer = YES;
    }
    return self;
}

+ (instancetype)emptyAnswer
{
    return [[FPNNAnswer alloc] initEmptyAnswer];
}

+ (instancetype)answerWithPayload:(NSDictionary*)payload
{
    return [[FPNNAnswer alloc] initWithPayload:payload];
}

+ (instancetype)answerWithErrorCode:(int)errorCode
{
    return [[FPNNAnswer alloc] initWithErrorCode:errorCode];
}

+ (instancetype)answerWithErrorCode:(int)errorCode andDescription:(NSString*)message
{
    return [[FPNNAnswer alloc] initWithErrorCode:errorCode andDescription:message];
}

@end
