//
//  FPNNTCPClient.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPNNAnswer;
@class FPNNAnswerCallback;
@class FPNNQuestProcessor;
@class FPNNQuest;


@interface FPNNTCPClient : NSObject

@property (readonly, nonatomic) BOOL connected;
@property (readonly, strong, nonatomic) NSString *endpoint;

@property (nonatomic) int questTimeout;     //-- In seconds
@property (nonatomic) BOOL autoReconnect;

//-----------[ Constructors Functions ]----------------//

+ (instancetype)clientWithEndpoint:(NSString*)endpoint;
+ (instancetype)clientWithHost:(NSString*)host andPort:(int)port;

- (instancetype)initWithEndpoint:(NSString*)endpoint autoReconnection:(BOOL)autoReconnect;
- (instancetype)initWithHost:(NSString*)host andPort:(int)port autoReconnection:(BOOL)autoReconnect;


//-----------[ Encryption Configure Functions ]----------------//

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (BOOL)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

//-----------[ Original Sending Functions ]----------------//

- (FPNNAnswer*)sendQuest:(NSString*)method withPayload:(NSDictionary*)params;
- (FPNNAnswer*)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withTimeout:(int)timeout;
- (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallback:(FPNNAnswerCallback*)callback;
- (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout;
- (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block;
- (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout;

- (void)sendNotify:(NSString*)method withPayload:(NSDictionary*)params;

//-----------[ Sending Functions ]----------------//

- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest;
- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest withTimeout:(int)timeout;
- (BOOL)sendQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback;
- (BOOL)sendQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout;
- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block;
- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout;

//-----------[ Connection Operation Functions ]----------------//

- (BOOL)connect;
- (BOOL)reconnect;
- (void)close;

//-----------[ Configure Functions ]----------------//
/*
 !!! Very Important !!!
 
    If call setQuestProcessor() function, the functions setConnectedCallback() & setConnectionWillCloseCallback()
 will be invalidated.
    In this case, if want to set the connection events, please override the connection event functions for the
 subclass of FPNNQuestProcessor.
 */
- (void)setConnectedCallback:(void(^)(void))block;
- (void)setConnectionWillCloseCallback:(void(^)(BOOL closeByError))block;
- (void)setQuestProcessor:(FPNNQuestProcessor *)questProcessor;

@end
