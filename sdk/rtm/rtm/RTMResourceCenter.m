//
//  RTMResourceCenter.m
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"
#import "RTMResourceCenter.h"

static const int fileGateKeptSeconds = 10 * 60;
static const int defaultPingIntervalSeconds = 20;
static RTMResourceCenter* _center = nil;

//==========================================//
//--         RTM File Gate Info           --//
//==========================================//
@interface FileGateInfo : NSObject

@property (strong, nonatomic) FPNNTCPClient* fileGate;
@property (nonatomic) int64_t lastTaskExpireSeconds;

- (instancetype)initWithEndpoint:(NSString*)endpoint andTaskTimeoutSeconds:(int)timeout;
- (void)updateWithNewTaskTimeout:(int)timeout;

@end

@implementation FileGateInfo

- (instancetype)initWithEndpoint:(NSString*)endpoint andTaskTimeoutSeconds:(int)timeout
{
    self = [super init];
    if (self)
    {
        _fileGate = [FPNNTCPClient clientWithEndpoint:endpoint];
        _lastTaskExpireSeconds = [NSDate date].timeIntervalSince1970 + timeout;
    }
    return self;
}

- (void)updateWithNewTaskTimeout:(int)timeout
{
    int64_t newLastExpire = [NSDate date].timeIntervalSince1970 + timeout;
    if (_lastTaskExpireSeconds < newLastExpire)
        _lastTaskExpireSeconds = newLastExpire;
}

@end


//==========================================//
//--           RTM CLient Info            --//
//==========================================//
@interface RTMClientInfo : NSObject

@property (strong, nonatomic) RTMClient* client;
@property (nonatomic) int64_t lastPingTime;
@property (nonatomic) int refCount;

- (instancetype)initWithRTMClient:(RTMClient*)client;

@end

@implementation RTMClientInfo

- (instancetype)initWithRTMClient:(RTMClient*)client
{
    self = [super init];
    if (self)
    {
        _client = client;
        _lastPingTime = 0;
        _refCount = 1;
    }
    return self;
}

@end

//==========================================//
//--         RTM Resource Center          --//
//==========================================//

@implementation RTMResourceCenter
{
    int64_t _clientIdBase;
    NSMutableDictionary<NSString *, FileGateInfo*>* _fileGateCache;
    NSMutableDictionary<NSNumber *, RTMClientInfo*>* _rtmClients;
    NSTimer* _timer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pingInterval = defaultPingIntervalSeconds;
        _clientIdBase = [NSDate date].timeIntervalSince1970;
        _fileGateCache = [NSMutableDictionary<NSString *, FileGateInfo*> dictionary];
        _rtmClients = [NSMutableDictionary<NSNumber *, RTMClientInfo*> dictionary];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(routine) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[super allocWithZone:NULL] init];
    });
    return _center;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RTMResourceCenter instance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [RTMResourceCenter instance];
}

- (void)dealloc
{
    /*
     If exception when App exiting, can call [RTMSDK stop] as a suloation in exit event.
     */
    [_timer invalidate];
}

//----------------------[ biz functions ]-----------------------//

- (FPNNTCPClient*)getFileClientWithEndpoint:(NSString*)endpoint questTimeout:(int)questTimeout
{
    @synchronized(self)
    {
        FileGateInfo* info = [_fileGateCache objectForKey:endpoint];
        if (!info)
        {
            info = [[FileGateInfo alloc] initWithEndpoint:endpoint andTaskTimeoutSeconds:questTimeout];
            [_fileGateCache setValue:info forKey:endpoint];
        }
        else
            [info updateWithNewTaskTimeout:questTimeout];
    
        return info.fileGate;
    }
}

+ (FPNNTCPClient*)getFileClientWithEndpoint:(NSString*)endpoint questTimeout:(int)questTimeout
{
    return [[RTMResourceCenter instance] getFileClientWithEndpoint:endpoint questTimeout:questTimeout];
}

//-- need in @synchronized(self) block
- (void)cleanFileGate
{
    int64_t threshold = [NSDate date].timeIntervalSince1970 - fileGateKeptSeconds;
    NSMutableArray* expiredEndpoints = [NSMutableArray array];
    
    for (NSString* endpoint in _fileGateCache) {
        FileGateInfo* info = [_fileGateCache objectForKey:endpoint];
        
        if (info.lastTaskExpireSeconds <= threshold)
            [expiredEndpoints addObject:endpoint];
    }
    
    for (NSString* endpoint in expiredEndpoints)
    {
        [_fileGateCache removeObjectForKey:endpoint];
    }
}

- (void)registerRTMClient:(RTMClient*)client
{
    NSNumber *clientId = [NSNumber numberWithLongLong:client.clientId];
    
    @synchronized(self)
    {
        RTMClientInfo* info = [_rtmClients objectForKey:clientId];
        if (!info)
        {
            int64_t newClientId = _clientIdBase++;
            client.clientId = newClientId;
            clientId = [NSNumber numberWithLongLong:newClientId];
            
            info = [[RTMClientInfo alloc] initWithRTMClient:client];
            info.refCount = 1;
            [_rtmClients setObject:info forKey:clientId];
        }
        else
            info.refCount += 1;
    }
}

- (void)unregisterRTMClient:(RTMClient*)client
{
    NSNumber *clientId = [NSNumber numberWithLongLong:client.clientId];
    
    @synchronized(self)
    {
        RTMClientInfo* info = [_rtmClients objectForKey:clientId];
        if (info)
        {
            if (info.refCount == 1)
                [_rtmClients removeObjectForKey:clientId];
            else
                info.refCount -= 1;
        }
    }
}

+ (void)registerRTMClient:(RTMClient*)client
{
    return [[RTMResourceCenter instance] registerRTMClient:client];
}

+ (void)unregisterRTMClient:(RTMClient*)client
{
    return [[RTMResourceCenter instance] unregisterRTMClient:client];
}

//-- need in @synchronized(self) block
- (void)RTMClientPing
{
    int64_t curr = [NSDate date].timeIntervalSince1970;
    int64_t threshold = curr - _pingInterval;
    for (NSNumber* clietId in _rtmClients) {
        RTMClientInfo *info = [_rtmClients objectForKey:clietId];
        if (info.lastPingTime <= threshold)
        {
            [info.client pingWithCallbackBlock:^(BOOL done, int errorCode, NSString* errorMessage){}];
            info.lastPingTime = curr;
        }
    }
}

- (void)routine
{
    /*
     If exception when App exiting, can call [RTMSDK stop] as a suloation in exit event.
     */
    
    @synchronized(self)
    {
        [self RTMClientPing];
        [self cleanFileGate];
    }
}

@end
