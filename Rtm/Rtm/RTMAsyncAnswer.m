//
//  RTMAsyncAnswer.m
//  Rtm
//
//  Created by zsl on 2019/12/18.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMAsyncAnswer.h"

#define  FPNNClient(client) (FPNNTCPClient*)[client valueForKey:@"usingClient"]

@implementation RTMAsyncAnswer

- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client{
    return [super initWithClient:FPNNClient(client)];
}
- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client answerMessage:(NSDictionary*)message{
    return [super initWithClient:FPNNClient(client) answerMessage:message];
}
- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client answer:(RTMAnswer*)answer{
    return [super initWithClient:FPNNClient(client) answer:(FPNNAnswer*)answer];
}
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client{
    return [super asyncAnswerWithClient:FPNNClient(client)];
}
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client answerMessage:(NSDictionary*)message{
    return [super asyncAnswerWithClient:FPNNClient(client) answerMessage:message];
}
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client answer:(RTMAnswer*)answer{
    return [super asyncAnswerWithClient:FPNNClient(client) answer:(FPNNAnswer*)answer];
}


- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client error:(FPNError*)error{
    return [super initWithClient:FPNNClient(client) error:error];
}
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client error:(FPNError*)error{
    return [super asyncAnswerWithClient:FPNNClient(client) error:error];
}


- (BOOL)sendAnswerMessage{
    return [super sendAnswerMessage];
}
- (BOOL)sendErrorAnswerMessage{
    return [super sendErrorAnswerMessage];
}
- (BOOL)sendEmptyAnswerMessage{
    return [super sendEmptyAnswerMessage];
}
@end
