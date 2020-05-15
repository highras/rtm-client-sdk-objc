//
//  FPNNAnswer.m
//  Fpnn
//
//  Created by zsl on 2019/11/25.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "FPNNAnswer.h"


@implementation FPNNAnswer
- (instancetype)initWithMessage:(NSDictionary *)message{
    self = [super init];
    if (self) {
        _responseData = message;
    }
    return self;
}

- (instancetype)initWithError:(FPNError*)error{
    self = [super init];
    if (self) {
        _error = error;
    }
    return self;
}

+ (instancetype)answerWithMessage:(NSDictionary*)message{
    return [[self alloc]initWithMessage:message];
}

+ (instancetype)answerWithError:(FPNError*)error{
    return [[self alloc]initWithError:error];
}

+ (instancetype)emptyAnswer{
    return [[self alloc]initWithMessage:@{}];
}
-(void)dealloc{
    //FPNSLog(@"FPNNAnswer dealloc");
}
@end
