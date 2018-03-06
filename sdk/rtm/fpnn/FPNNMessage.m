//
//  FPNNMessage.m
//  fpnn
//
//  Created by 施王兴 on 2017/12/28.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNMessage.h"

@implementation FPNNMessage

+ (instancetype)message
{
    return [[FPNNMessage alloc] init];
}

+ (instancetype)messageWithPayload:(NSDictionary*)payload
{
    return [[FPNNMessage alloc] initWithPayload:payload];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _payload = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithPayload:(NSDictionary*)payload
{
    self = [super init];
    if (self)
    {
        if ([payload isKindOfClass:[NSMutableDictionary class]])
            _payload = (NSMutableDictionary*)payload;
        else
            _payload = [NSMutableDictionary dictionaryWithDictionary:payload];
    }
    return self;
}

- (void)param:(NSString*)key value:(NSObject*)value
{
    [_payload setValue:value forKey:key];
}

- (NSObject*)get:(NSString*)key default:(NSObject*)value
{
    NSObject* data = [_payload objectForKey:key];
    return (data != nil) ? data : value;
}

- (NSObject*)get:(NSString*)key
{
    return [_payload objectForKey:key];
}

@end
