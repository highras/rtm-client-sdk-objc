//
//  RTMAsyncAnswer.h
//  Rtm
//
//  Created by zsl on 2019/12/18.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "FPNNAsyncAnswer.h"
#import "RTMClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMAsyncAnswer : FPNNAsyncAnswer
//RTM暂时不需要 没有暴露出去
- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client;
- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client answerMessage:(NSDictionary*)message;
- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client answer:(RTMAnswer*)answer;
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client;
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client answerMessage:(NSDictionary*)message;
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client answer:(RTMAnswer*)answer;
- (BOOL)sendAnswerMessage;

- (instancetype _Nullable)initWithClient:(RTMClient * _Nonnull)client error:(FPNError*)error;
+ (instancetype _Nullable)asyncAnswerWithClient:(RTMClient * _Nonnull)client error:(FPNError*)error;
- (BOOL)sendErrorAnswerMessage;

- (BOOL)sendEmptyAnswerMessage;

@end





NS_ASSUME_NONNULL_END
