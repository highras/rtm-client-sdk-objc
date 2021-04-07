//
//  FPNNTCPClient.h
//  Fpnn
//
//  Created by zsl on 2019/11/22.
//  Copyright © 2019 FunPlus. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FPNNCallBackDefinition.h"
#import "FPNNProtocol.h"

@class FPNNQuest,FPNNAnswer,FPNNCallBackHandler,FPNNAsyncAnswer;
NS_ASSUME_NONNULL_BEGIN
@interface FPNNTCPClient : NSObject

@property (nonatomic,strong) NSString * ocFpnnSdkVersion;
@property (nonatomic,assign) int questTimeout;
@property (nonatomic,assign) BOOL autoReconnect;//默认YES 发送操作时 如果为未连接 会自动连接后发送  非断开后自动重新连接

@property (nonatomic,readonly,assign) BOOL isDisconnected;
@property (nonatomic,readonly,assign) BOOL isConnected;
@property (nonatomic,readonly,strong) NSString * connectedHost;
@property (nonatomic,readonly,assign) int connectedPort;

@property (nonatomic,readonly,strong)NSString *  _Nullable pid;//Rtm专用 传pid
//两种使用方式 同时使用block会在delegate前调用
@property (nonatomic,assign)id <FPNNProtocol> _Nullable delegate;
@property (nonatomic,copy)FPNNConnectionSuccessCallBack connectionSuccessCallBack;
@property (nonatomic,copy)FPNNConnectionCloseCallBack connectionCloseCallBack;
@property (nonatomic,copy)FPNNListenAndReplyCallBack listenAndReplyCallBack;

- (instancetype _Nullable)initWithEndpoint:(NSString * _Nonnull)endpoint pid:(NSString *)pid;
//- (instancetype _Nullable)initWithHost:(NSString * _Nonnull)host port:(int)port;

+ (instancetype _Nullable)clientWithEndpoint:(NSString * _Nonnull)endpoint pid:(NSString *)pid;;
//+ (instancetype _Nullable)clientWithHost:(NSString * _Nonnull)host port:(int)port;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end





@interface FPNNTCPClient (Send)

- (FPNNAnswer *_Nullable)sendQuest:(NSString * _Nonnull)method
                  message:(NSDictionary *)message;

- (FPNNAnswer *_Nullable)sendQuest:(NSString * _Nonnull)method
                  message:(NSDictionary *)message
                  timeout:(int)timeout;

- (FPNNAnswer *_Nullable)sendQuest:(FPNNQuest * _Nonnull)quest;


- (FPNNAnswer *_Nullable)sendQuest:(FPNNQuest * _Nonnull)quest
                  timeout:(int)timeout;


- (BOOL)sendQuest:(NSString * _Nonnull)method
          message:(NSDictionary *)message
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback;

- (BOOL)sendQuest:(NSString * _Nonnull)method
          message:(NSDictionary * )message
          timeout:(int)timeout
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback;

- (BOOL)sendQuest:(FPNNQuest * _Nonnull)quest
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback;

- (BOOL)sendQuest:(FPNNQuest * _Nonnull)quest
          timeout:(int)timeout
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback;

@end



@interface FPNNTCPClient (Connect)

- (BOOL)connect;
- (BOOL)reconnect;
- (void)closeConnect;

@end



@interface FPNNTCPClient (Encryptor)

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;//ecc
- (BOOL)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

@end

NS_ASSUME_NONNULL_END

