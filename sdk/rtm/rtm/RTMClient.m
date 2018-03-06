//
//  RTMClient.m
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "../fpnn/FPNNSDK.h"
#import "RTMResourceCenter.h"
#import "RTMQuestProcessor.h"
#import "RTMClient.h"

//==========================================//
//--              Auth Info               --//
//==========================================//
@interface AuthInfo : NSObject

@property (nonatomic) int pid;
@property (nonatomic) int64_t uid;
@property (nonatomic) BOOL autoAuth;
@property (strong, nonatomic) NSString* token;
@property (nonatomic) BOOL receiveUnreadNotification;

- (void)reset;

@end

@implementation AuthInfo

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self reset];
    }
    return self;
}

- (void)reset
{
    _pid = 0;
    _uid = 0;
    _autoAuth = NO;
    _token = nil;
    _receiveUnreadNotification = YES;
}

@end

//==========================================//
//--           Encryption Info            --//
//==========================================//

@interface EncryptionInfo : NSObject

@property (strong, nonatomic) NSString* curve;
@property (strong, nonatomic) NSData* publicKey;
@property (strong, nonatomic) NSData* derData;
@property (strong, nonatomic) NSData* pemData;
@property (strong, nonatomic) NSString* derFilePath;
@property (strong, nonatomic) NSString* pemFilePath;

@property (nonatomic) BOOL packageMode;
@property (nonatomic) BOOL reinforce;

- (void)reset;
- (void)prepareTCPClient:(FPNNTCPClient*)client;

@end

@implementation EncryptionInfo

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self reset];
    }
    return self;
}

- (void)reset
{
    _curve = nil;
    _publicKey = nil;
    
    _derData = nil;
    _pemData = nil;
    _derFilePath = nil;
    _pemFilePath = nil;
    
    _packageMode = YES;
    _reinforce = NO;
}

- (void)prepareTCPClient:(FPNNTCPClient*)client
{
    if (_curve && _publicKey)
    {
        [client enableEncryptorWithCurve:_curve serverPublicKey:_publicKey packageMode:_packageMode withReinforce:_reinforce];
        return;
    }
    
    if (_derData)
    {
        [client enableEncryptorByDerData:_derData packageMode:_packageMode withReinforce:_reinforce];
        return;
    }
    
    if (_pemData)
    {
        [client enableEncryptorByPemData:_pemData packageMode:_packageMode withReinforce:_reinforce];
        return;
    }
    
    if (_derFilePath)
    {
        [client enableEncryptorByDerFile:_derFilePath packageMode:_packageMode withReinforce:_reinforce];
        return;
    }
    
    if (_pemFilePath)
    {
        [client enableEncryptorByPemFile:_pemFilePath packageMode:_packageMode withReinforce:_reinforce];
        return;
    }
}

@end

//==========================================//
//--          Quest Cache Unit            --//
//==========================================//

@interface RTMQuestCacheUnit : NSObject

@property (strong, nonatomic) FPNNQuest* quest;
@property (strong, nonatomic) FPNNAnswerCallback* callback;
@property (nonatomic) int questTimeout;
@property (nonatomic) NSTimeInterval cacheTimeFrom1970;
@property (nonatomic) int errorCode;

@end

@implementation RTMQuestCacheUnit

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _quest = nil;
        _callback = nil;
        _questTimeout = 0;
        _cacheTimeFrom1970 = [NSDate date].timeIntervalSince1970;
        _errorCode = FPNN_EC_OK;
    }
    return self;
}

@end

//==========================================//
//--              RTM Client              --//
//==========================================//

@implementation RTMClient
{
    enum RTMClientStatus _status;
    int64_t _currConnectionId;
    
    FPNNTCPClient* _dispatch;
    FPNNTCPClient* _rtmGated;

    NSString* _rtmGatedName;
    NSString* _rtmGatedEndpoint;
    AuthInfo* _authInfo;
    EncryptionInfo* _encryptionInfo;
    
    int64_t _idBase;
    NSLock* _idGenLock;
    NSMutableArray* _questCache;
}

//-----------[ Constructors Functions ]----------------//

- (void)defaultInit
{
    _clientId = 0;
    _questTimeout = 0;
    _status = RTM_Closed;
    _eventHandler = nil;
    
    _currConnectionId = 0;
    
    _dispatch = nil;
    _rtmGated = nil;
    
    _rtmGatedName = nil;
    _rtmGatedEndpoint = nil;
    _authInfo = [[AuthInfo alloc] init];
    _encryptionInfo = nil;
    
    _idBase = [NSDate date].timeIntervalSince1970;
    _idGenLock = [[NSLock alloc] init];
    _questCache = [NSMutableArray array];
}

- (void)buildRTMGatedName:(NSString*)cluster
{
    if (cluster != nil && [cluster length] > 0)
        _rtmGatedName = [NSString stringWithFormat:@"rtmGated@%@", cluster];
    else
        _rtmGatedName = @"rtmGated";
}

//------ Work with standard flow
- (instancetype)initWithDispatcherEndpoint:(NSString*)endpoint andCluster:(NSString*)cluster
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
        [self buildRTMGatedName:cluster];
        _dispatch = [FPNNTCPClient clientWithEndpoint:endpoint];
    }
    return self;
}
- (instancetype)initWithDispatcherHost:(NSString*)host port:(int)port andCluster:(NSString*)cluster
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
        [self buildRTMGatedName:cluster];
        _dispatch = [FPNNTCPClient clientWithHost:host andPort:port];
    }
    return self;
}

+ (instancetype)rtmClientWithDispatcherEndpoint:(NSString*)endpoint andCluster:(NSString*)cluster
{
    return [[RTMClient alloc] initWithDispatcherEndpoint:endpoint andCluster:cluster];
}
+ (instancetype)rtmClientWithDispatcherHost:(NSString*)host port:(int)port andCluster:(NSString*)cluster
{
    return [[RTMClient alloc] initWithDispatcherHost:host port:port andCluster:cluster];
}

//------ Direct connect to RtmGated

- (instancetype)initWithRtmGatedEndpoint:(NSString*)endpoint
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
        _rtmGatedEndpoint = endpoint;
    }
    return self;
}
- (instancetype)initWithRtmGatedHost:(NSString*)host andPort:(int)port
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
        _rtmGatedEndpoint = [NSString stringWithFormat:@"%@:%d", host, port];
    }
    return self;
}

+ (instancetype)rtmClientWithRtmGatedEndpoint:(NSString*)endpoint
{
    return [[RTMClient alloc] initWithRtmGatedEndpoint:endpoint];
}
+ (instancetype)rtmClientWithRtmGatedHost:(NSString*)host andPort:(int)port
{
    return [[RTMClient alloc] initWithRtmGatedHost:host andPort:port];
}

//-----------[ Configure Functions ]----------------//

- (enum RTMClientStatus)status
{
    @synchronized(self)
    {
        return _status;
    }
}

- (void)enableAutoAuthForProject:(int)projectId user:(int64_t)uid token:(NSString*)token receiveUnreadNotification:(BOOL)recvUnread
{
    _authInfo.pid = projectId;
    _authInfo.uid = uid;
    _authInfo.token = token;
    _authInfo.receiveUnreadNotification = recvUnread;
    _authInfo.autoAuth = YES;
}

- (void)disableAutoAuth
{
    //[_authInfo reset];
    _authInfo.autoAuth = NO;
}

+ (void)setPingInterval:(int)intervalInSeconds
{
    [RTMResourceCenter instance].pingInterval = intervalInSeconds;
}

//-----------[ Encryption Configure Functions ]----------------//

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    _encryptionInfo = [[EncryptionInfo alloc] init];
    
    _encryptionInfo.curve = curve;
    _encryptionInfo.publicKey = publicKey;
    _encryptionInfo.packageMode = packageMode;
    _encryptionInfo.reinforce = reinforce;
}
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    _encryptionInfo = [[EncryptionInfo alloc] init];
    
    _encryptionInfo.derData = derData;
    _encryptionInfo.packageMode = packageMode;
    _encryptionInfo.reinforce = reinforce;
}
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    _encryptionInfo = [[EncryptionInfo alloc] init];
    
    _encryptionInfo.pemData = pemData;
    _encryptionInfo.packageMode = packageMode;
    _encryptionInfo.reinforce = reinforce;
}
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    _encryptionInfo = [[EncryptionInfo alloc] init];
    
    _encryptionInfo.derFilePath = derFilePath;
    _encryptionInfo.packageMode = packageMode;
    _encryptionInfo.reinforce = reinforce;
}
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    _encryptionInfo = [[EncryptionInfo alloc] init];
    
    _encryptionInfo.pemFilePath = pemFilePath;
    _encryptionInfo.packageMode = packageMode;
    _encryptionInfo.reinforce = reinforce;
}

//-----------[ Connect & close Functions ]----------------//

- (void)prepareDispatchClient
{
    if (_questTimeout)
        _dispatch.questTimeout = _questTimeout;
    
    if (_encryptionInfo)
        [_encryptionInfo prepareTCPClient:_dispatch];
}

- (void)prepareRTMGatedClient:(int64_t)newConnectionId
{
    if (!_rtmGated)
        _rtmGated = [[FPNNTCPClient alloc] initWithEndpoint:_rtmGatedEndpoint autoReconnection:NO];
    
    if (_questTimeout)
        _rtmGated.questTimeout = _questTimeout;
    
    if (_encryptionInfo)
        [_encryptionInfo prepareTCPClient:_rtmGated];
    
    RTMQuestProcessor* questProcessor = [[RTMQuestProcessor alloc] init];
    questProcessor.connectionId = newConnectionId;
    questProcessor.eventHandler = _eventHandler;
    [questProcessor prepareForNewConnection:self];
    [_rtmGated setQuestProcessor:questProcessor];
}

- (BOOL)fetchRTMGatedAddress
{
    [self prepareDispatchClient];
    
    FPNNQuest* quest = [FPNNQuest quest:@"which"];
    [quest param:@"what" value:_rtmGatedName];
    
    return [_dispatch sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        if (errorCode == FPNN_EC_OK)
        {
            NSString* endpoint = (NSString*)[payload objectForKey:@"endpoint"];
            _rtmGated = [[FPNNTCPClient alloc] initWithEndpoint:endpoint autoReconnection:NO];
            
            [self connectAndAuth];
        }
        else
        {
            NSString* errorInfo = nil;
            if (payload)
            {
                NSString* ex = (NSString*)[payload objectForKey:@"ex"];
                errorInfo = [NSString stringWithFormat:@"Fetch RTM Gate address failed. %@", ex];
            }
            else
                errorInfo = @"Fetch RTM Gate address failed.";
            
            [self internalRTMConnectFailedFinally:RTM_Closed errorCode:errorCode message:errorInfo launchAuthCallback:YES];
        }
    }];
}

- (void)connectAndAuth
{
    int64_t newConnId = [self genNewId];
    
    @synchronized(self)
    {
        _status = RTM_ConnectingToRTMGate;
        _currConnectionId = newConnId;
    }
 
    [self prepareRTMGatedClient:newConnId];
    
    if (![_rtmGated connect])
    {
        [self internalRTMConnectFailedFinally:RTM_Closed errorCode:FPNN_EC_CORE_INVALID_CONNECTION message:@"Connect to RTM Gate failed." launchAuthCallback:YES];
        return;
    }
    
    @synchronized(self)
    {
        _status = RTM_Authing;
    }
    
    //----- send auth quest -----//
    FPNNQuest* quest = [FPNNQuest quest:@"auth"];
    [quest param:@"pid" value:[NSNumber numberWithInt:_authInfo.pid]];
    [quest param:@"uid" value:[NSNumber numberWithLongLong:_authInfo.uid]];
    [quest param:@"token" value:_authInfo.token];
    [quest param:@"unread" value:[NSNumber numberWithBool:_authInfo.receiveUnreadNotification]];
    
    BOOL status = [_rtmGated sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        if (errorCode == FPNN_EC_OK)
        {
            NSNumber* result = (NSNumber*)[payload objectForKey:@"ok"];
            if ([result boolValue])
            {
                [self internalAuthSuccesseded];
            }
            else
            {
                [self internalRTMConnectFailedFinally:RTM_AuthFailed errorCode:FPNN_EC_OK message:@"Auth failed." launchAuthCallback:NO];
                
                if([_eventHandler respondsToSelector:@selector(auth:)])
                    [_eventHandler auth:NO];
            }
        }
        else
        {
            NSString* errorInfo = nil;
            if (payload)
            {
                NSString* ex = (NSString*)[payload objectForKey:@"ex"];
                errorInfo = [NSString stringWithFormat:@"Auth exception. %@", ex];
            }
            else
                errorInfo = @"Auth exception.";
            
            [self internalRTMConnectFailedFinally:RTM_Closed errorCode:errorCode message:errorInfo launchAuthCallback:YES];
        }
    }];
    
    if (!status)
    {
        [self internalRTMConnectFailedFinally:RTM_Closed errorCode:FPNN_EC_CORE_INVALID_CONNECTION message:@"Send auth quest failed." launchAuthCallback:YES];
    }
}

- (void)internalRTMConnectFailedFinally:(enum RTMClientStatus)status errorCode:(int)errorCode message:(NSString*)message launchAuthCallback:(BOOL)launchAuthCallback
{
    @synchronized(self)
    {
        _rtmGated = nil;
        _status = status;
        _currConnectionId = 0;
    }
    
    if (launchAuthCallback)
        if([_eventHandler respondsToSelector:@selector(authException:withMessage:)])
            [_eventHandler authException:errorCode withMessage:message];
    
    
    [self cleanQuestCache];
}

- (void)internalAuthSuccesseded
{
    if([_eventHandler respondsToSelector:@selector(auth:)])
        [_eventHandler auth:YES];
    
    [RTMResourceCenter registerRTMClient:self];
    
    NSMutableArray* failedQuestCache;
    @synchronized(self)
    {
        _status = RTM_Connected;
        failedQuestCache = [self sendCachedQuest];
    }
    [self cleanQuestCache:failedQuestCache];
}

- (BOOL)internalConnect
{
    return [self connectTo:_authInfo.pid byUser:_authInfo.uid withToken:_authInfo.token receiveUnreadNotification:_authInfo.receiveUnreadNotification];
}

- (BOOL)connectTo:(int)projectId byUser:(int64_t)uid withToken:(NSString*)token receiveUnreadNotification:(BOOL)receive
{
    if (_eventHandler == nil || token == nil)
        return NO;
    
    @synchronized(self)
    {
        if (_status != RTM_Closed && _status != RTM_AuthFailed)
            return NO;
        
        if (_dispatch)
            _status = RTM_QueryRTMGatedAddress;
        else
            _status = RTM_ConnectingToRTMGate;
    }
    
    _authInfo.pid = projectId;
    _authInfo.uid = uid;
    _authInfo.token = token;
    _authInfo.receiveUnreadNotification = receive;
    _authInfo.autoAuth = NO;
    
    if (_dispatch)
    {
        BOOL status = [self fetchRTMGatedAddress];
        if (status)
            return YES;
        else
        {
            @synchronized(self)
            {
                _status = RTM_Closed;
            }
            return NO;
        }
    }
    else
    {
        [self connectAndAuth];
        return YES;
    }
}

- (void)close
{
    [self bye];
}

//-----------[ Help Functions ]----------------//

- (int64_t)genNewId
{
    int64_t idnumber;
    
    [_idGenLock lock];
    idnumber = _idBase++;
    [_idGenLock unlock];
    
    return idnumber;
}

- (void)releaseAllResources
{
    _dispatch = nil;
    _rtmGated = nil;
    _eventHandler = nil;
}

//-- in @synchronized(self){...} block
- (void)cacheQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout
{
    RTMQuestCacheUnit* qcu = [[RTMQuestCacheUnit alloc] init];
    qcu.quest = quest;
    qcu.callback = callback;
    qcu.questTimeout = timeout;
    
    [_questCache addObject:qcu];
}

//-- in @synchronized(self){...} block, return failed qcu
- (NSMutableArray*)sendCachedQuest
{
    NSMutableArray* failedCache = [NSMutableArray array];
    
    int curr = [NSDate date].timeIntervalSince1970;
    
    for (RTMQuestCacheUnit* qcu in _questCache) {
        int diff = curr - qcu.cacheTimeFrom1970;
        if (diff >= qcu.questTimeout)
        {
            qcu.errorCode = FPNN_EC_CORE_TIMEOUT;
            [failedCache addObject:qcu];
        }
        else
        {
            BOOL status = [_rtmGated sendQuest:qcu.quest withCallback:qcu.callback timeout:(qcu.questTimeout - diff)];
            if (!status)
            {
                qcu.errorCode = FPNN_EC_CORE_SEND_ERROR;
                [failedCache addObject:qcu];
            }
        }
    }
    
    return failedCache;
}

//-- out @synchronized(self){...} block
- (void)cleanQuestCache
{
    NSMutableArray* questCache;
    @synchronized(self)
    {
        if ([_questCache count])
        {
            questCache = _questCache;
            _questCache = [NSMutableArray array];
        }
        else
            return;
    }
    [self cleanQuestCache:questCache];
}

- (void)cleanQuestCache:(NSMutableArray*)questCache
{
    for (RTMQuestCacheUnit* qcu in questCache) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [qcu.callback onException:qcu.errorCode payload:nil];
        });
    }
}

//-----------[ Message Functions ]----------------//

- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest withTimeout:(int)timeout
{
    FPNNSyncAnswerCallback* callback = [[FPNNSyncAnswerCallback alloc] init];
    BOOL status = [self sendQuest:quest withCallback:callback timeout:timeout];
    if (status)
        return [callback getAnswer];
    else
        return [[FPNNAnswer alloc] initWithErrorCode:FPNN_EC_CORE_SEND_ERROR andDescription:@"Unknown sending error." withRaiser:@"Objective-C SDK"];
}

- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout
{
    FPNNAnswerBlockCallback *callback = [[FPNNAnswerBlockCallback alloc] initWithBlock:block];
    return [self sendQuest:quest withCallback:callback timeout:timeout];
}

- (BOOL)sendQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout
{
    BOOL needReConnect = NO;
    
    @synchronized(self)
    {
        if (_status == RTM_Closed || _status == RTM_AuthFailed)
        {
            if (_authInfo.autoAuth)
                needReConnect = YES;
            else
                return NO;
        }
        else if (_status == RTM_Connected)
            return [_rtmGated sendQuest:quest withCallback:callback timeout:timeout];
        else
        {
            [self cacheQuest:quest withCallback:callback timeout:timeout];
            return YES;
        }
    }
    
    if (needReConnect)
    {
        BOOL status = [self internalConnect];
        if (status)
        {
            @synchronized(self)
            {
                if (_status == RTM_Closed || _status == RTM_AuthFailed)
                    return NO;
                else if (_status == RTM_Connected)
                    return [_rtmGated sendQuest:quest withCallback:callback timeout:timeout];
                else
                {
                    [self cacheQuest:quest withCallback:callback timeout:timeout];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

//============================[ RTM Gated Functions ]============================//

//-----------------[ ping ]-----------------//
- (BOOL)ping:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"ping"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)ping
{
    return [self ping:_questTimeout];
}

- (BOOL)pingWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"ping"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)pingWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self pingWithCallbackBlock:block timeout:_questTimeout];
}

//-----------------[ bye ]-----------------//
- (BOOL)bye:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"bye"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)bye
{
    return [self bye:_questTimeout];
}

- (BOOL)byeWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"bye"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)byeWithCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self byeWithCallbackBlock:block timeout:_questTimeout];
}

//============================[ Internal Functions ]============================//
/*
 All functions in this section just used in SDK internal, cannot be called out of SDK.
 */


- (void)internalClose      //-- MUST in async mode.
{
    FPNNTCPClient *client;
    
    @synchronized(self)
    {
        client = _rtmGated;
    }
    
    if (client)
        [client close];
}

- (void)internalConnetionWillCloseEvent:(int64_t)connectionId closedByError:(BOOL)closedByError
{
    [RTMResourceCenter unregisterRTMClient:self];
    
    NSMutableArray* questCache = nil;
    
    @synchronized(self)
    {
        if (_currConnectionId == connectionId)
        {
            _status = RTM_Closed;
            _currConnectionId = 0;
            _rtmGated = nil;
            
            if ([_questCache count])
            {
                questCache = _questCache;
                _questCache = [NSMutableArray array];
            }
        }
        else
            return;
    }
    
    [self cleanQuestCache:questCache];
    
    if([_eventHandler respondsToSelector:@selector(connectionWillClose:)])
        [_eventHandler connectionWillClose:closedByError];
}

- (void)internalCompleteFilesAPIQuest:(FPNNQuest*)quest
{
    [quest param:@"pid" value:[NSNumber numberWithInt:_authInfo.pid]];
    [quest param:@"from" value:[NSNumber numberWithLongLong:_authInfo.uid]];
}

@end
