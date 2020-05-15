//
//  FPNNIAsyncAnswer.h
//  Fpnn
//
//  Created by zsl on 2019/11/25.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FPNNAnswer ,FPNNTCPClient,FPNError;
NS_ASSUME_NONNULL_BEGIN

@interface FPNNAsyncAnswer : NSObject

@property(nonatomic,strong)NSDictionary * answerMessage;
@property(nonatomic,strong)FPNError * error;
//调用初始化 会hook 处理耗时操作 具体超时时间由服务端设定
- (instancetype _Nullable)initWithClient:(FPNNTCPClient * _Nonnull)client;
- (instancetype _Nullable)initWithClient:(FPNNTCPClient * _Nonnull)client answerMessage:(NSDictionary*)message;
- (instancetype _Nullable)initWithClient:(FPNNTCPClient * _Nonnull)client answer:(FPNNAnswer*)answer;
+ (instancetype _Nullable)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client;
+ (instancetype _Nullable)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client answerMessage:(NSDictionary*)message;
+ (instancetype _Nullable)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client answer:(FPNNAnswer*)answer;
- (BOOL)sendAnswerMessage;


- (instancetype _Nullable)initWithClient:(FPNNTCPClient * _Nonnull)client error:(FPNError*)error;
+ (instancetype _Nullable)asyncAnswerWithClient:(FPNNTCPClient * _Nonnull)client error:(FPNError*)error;
- (BOOL)sendErrorAnswerMessage;


- (BOOL)sendEmptyAnswerMessage;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
