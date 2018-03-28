//
//  RTMClient.h
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMEventHandlerDelegate.h"

@class FPNNQuest;
@class FPNNAnswer;

enum RTMClientStatus
{
    RTM_Closed,
    RTM_QueryRTMGatedAddress,
    RTM_ConnectingToRTMGate,
    RTM_Authing,
    RTM_AuthFailed,
    RTM_Connected,
};

@interface RTMClient : NSObject

@property (nonatomic) int questTimeout;     //-- In seconds
@property (readonly, nonatomic) enum RTMClientStatus status;
@property (strong, nonatomic) id<RTMEventHandlerDelegate> eventHandler;

//-----------[ Constructors Functions ]----------------//

//------ Work with standard flow
- (instancetype)initWithDispatcherEndpoint:(NSString*)endpoint andCluster:(NSString*)cluster;
- (instancetype)initWithDispatcherHost:(NSString*)host port:(int)port andCluster:(NSString*)cluster;

+ (instancetype)rtmClientWithDispatcherEndpoint:(NSString*)endpoint andCluster:(NSString*)cluster;
+ (instancetype)rtmClientWithDispatcherHost:(NSString*)host port:(int)port andCluster:(NSString*)cluster;

//------ Direct connect to RtmGated

- (instancetype)initWithRtmGatedEndpoint:(NSString*)endpoint;
- (instancetype)initWithRtmGatedHost:(NSString*)host andPort:(int)port;

+ (instancetype)rtmClientWithRtmGatedEndpoint:(NSString*)endpoint;
+ (instancetype)rtmClientWithRtmGatedHost:(NSString*)host andPort:(int)port;

//-----------[ Configure Functions ]----------------//

- (void)enableAutoAuthForProject:(int)projectId user:(int64_t)uid token:(NSString*)token receiveUnreadNotification:(BOOL)recvUnread;

- (void)disableAutoAuth;

//-----------[ Encryption Configure Functions ]----------------//

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

//-----------[ Connect & close Functions ]----------------//

//-- if eventHandler is nil, must fail.
- (BOOL)connectTo:(int)projectId byUser:(int64_t)uid withToken:(NSString*)token receiveUnreadNotification:(BOOL)receive;

- (void)close;

//-----------[ Help Functions ]----------------//

- (int64_t)genNewId;
- (void)releaseAllResources;

//-----------[ Internal Message Functions ]----------------//

- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest withTimeout:(int)timeout;
- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout;

//============================[ RTM Gated Functions ]============================//
//-----------------[ bye ]-----------------//
- (BOOL)bye:(int)timeout;
- (BOOL)bye;
- (BOOL)byeWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)byeWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//============================[ Internal Functions ]============================//
/*
 All functions in this section just used in SDK internal, cannot be called out of SDK.
 */

- (void)internalClose;      //-- MUST in async mode.
- (void)internalConnetionWillCloseEvent:(int64_t)connectionId closedByError:(BOOL)closedByError;
- (void)internalCompleteFilesAPIQuest:(FPNNQuest*)quest;

@end
