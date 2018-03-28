//
//  RTMQuestProcessor.m
//  rtm
//
//  Created by 施王兴 on 2018/1/8.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"
#import "RTMDuplicatedMessageFilter.h"
#import "RTMQuestProcessor.h"

@implementation RTMQuestProcessor
{
    RTMClient* _rtmClient;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectionId = 0;
        _eventHandler = nil;
        _rtmClient = nil;
    }
    return self;
}

- (void)prepareForNewConnection:(RTMClient*)client
{
    _rtmClient = client;
}

- (void)resetRTMClientReference
{
    _rtmClient = nil;
}

- (void)connectionWillClose:(BOOL)closeByError
{
    if (_rtmClient)
    {
        [_rtmClient internalConnetionWillCloseEvent:_connectionId closedByError:closeByError];
        [self resetRTMClientReference];
    }
}

- (FPNNAnswer*)kickout:(NSDictionary*)params
{
    if (_eventHandler)
        [_eventHandler kickout];
    
    if (_rtmClient)
        [_rtmClient internalClose];
    
    return nil;
}

- (FPNNAnswer*)kickoutroom:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* roomId = (NSNumber*)[params objectForKey:@"rid"];
        [_eventHandler roomKickout:roomId.longLongValue];
    }
    return nil;
}

- (FPNNAnswer*)pushmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mType = (NSNumber*)[params objectForKey:@"mtype"];
        NSNumber* fType = (NSNumber*)[params objectForKey:@"ftype"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        NSString* attrs = (NSString*)[params objectForKey:@"attrs"];
        
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterP2PMessage:midc from:uid])
            return nil;
        
        [_eventHandler recvP2PMessage:uid mType:mType.charValue fType:fType.charValue mid:midc message:msg attrs:attrs];
    }
    return nil;
}

- (FPNNAnswer*)pushgroupmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* gid = (NSNumber*)[params objectForKey:@"gid"];
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mType = (NSNumber*)[params objectForKey:@"mtype"];
        NSNumber* fType = (NSNumber*)[params objectForKey:@"ftype"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        NSString* attrs = (NSString*)[params objectForKey:@"attrs"];
        
        int64_t groupId = gid.longLongValue;
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterGroupMessage:midc from:uid inGroup:groupId])
            return nil;
        
        [_eventHandler recvGroupMessage:groupId fromUid:uid mType:mType.charValue fType:fType.charValue mid:midc message:msg attrs:attrs];
    }
    return nil;
}

- (FPNNAnswer*)pushroommsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* rid = (NSNumber*)[params objectForKey:@"rid"];
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mType = (NSNumber*)[params objectForKey:@"mtype"];
        NSNumber* fType = (NSNumber*)[params objectForKey:@"ftype"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        NSString* attrs = (NSString*)[params objectForKey:@"attrs"];
        
        int64_t roomId = rid.longLongValue;
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterRoomMessage:midc from:uid inRoom:roomId])
            return nil;
        
        [_eventHandler recvRoomMessage:roomId fromUid:uid mType:mType.charValue fType:fType.charValue mid:midc message:msg attrs:attrs];
    }
    return nil;
}

- (FPNNAnswer*)pushbroadcastmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mType = (NSNumber*)[params objectForKey:@"mtype"];
        NSNumber* fType = (NSNumber*)[params objectForKey:@"ftype"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        NSString* attrs = (NSString*)[params objectForKey:@"attrs"];
        
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterBroadcastMessage:midc from:uid])
            return nil;
        
        [_eventHandler recvBroadcastMessage:uid mType:mType.charValue fType:fType.charValue mid:midc message:msg attrs:attrs];
    }
    return nil;
}

- (FPNNAnswer*)transmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSNumber* omid = (NSNumber*)[params objectForKey:@"omid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterP2PMessage:midc from:uid])
            return nil;
        
        [_eventHandler recvTranslatedP2PMessage:uid mid:midc originalMid:omid.longLongValue message:msg];
    }
    return nil;
}

- (FPNNAnswer*)transgroupmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* gid = (NSNumber*)[params objectForKey:@"gid"];
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSNumber* omid = (NSNumber*)[params objectForKey:@"omid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        
        int64_t groupId = gid.longLongValue;
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterGroupMessage:midc from:uid inGroup:groupId])
            return nil;
        
        [_eventHandler recvTranslatedGroupMessage:groupId fromUid:uid mid:midc originalMid:omid.longLongValue message:msg];
    }
    return nil;
}

- (FPNNAnswer*)transroommsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* rid = (NSNumber*)[params objectForKey:@"rid"];
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSNumber* omid = (NSNumber*)[params objectForKey:@"omid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        
        int64_t roomId = rid.longLongValue;
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterRoomMessage:midc from:uid inRoom:roomId])
            return nil;
        
        [_eventHandler recvTranslatedRoomMessage:roomId fromUid:uid mid:midc originalMid:omid.longLongValue message:msg];
    }
    return nil;
}

- (FPNNAnswer*)transbroadcastmsg:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSNumber* fromUid = (NSNumber*)[params objectForKey:@"from"];
        NSNumber* mid = (NSNumber*)[params objectForKey:@"mid"];
        NSNumber* omid = (NSNumber*)[params objectForKey:@"omid"];
        NSString* msg = (NSString*)[params objectForKey:@"msg"];
        
        int64_t uid = fromUid.longLongValue;
        int64_t midc = mid.longLongValue;
        
        if (![RTMDuplicatedMessageFilter filterBroadcastMessage:midc from:uid])
            return nil;
        
        [_eventHandler recvTranslatedBroadcastMessage:uid mid:midc originalMid:omid.longLongValue message:msg];
    }
    return nil;
}

- (FPNNAnswer*)pushunread:(NSDictionary*)params
{
    [self sendEmptyAnswer];
    if (_eventHandler)
    {
        NSArray* unreadP2PUids = (NSArray*)[params objectForKey:@"p2p"];
        NSArray* unreadGroupGids = (NSArray*)[params objectForKey:@"group"];
        NSNumber* haveBroadcastMessage = (NSNumber*)[params objectForKey:@"bc"];
        
        [_eventHandler unreadMessageStatus:unreadP2PUids uidOfUnreadGroupMessages:unreadGroupGids haveUnreadBroadcastMessages:haveBroadcastMessage.boolValue];
    }
    return nil;
}

- (FPNNAnswer*)ping:(NSDictionary*)params
{
    return [FPNNAnswer emptyAnswer];
}

@end
