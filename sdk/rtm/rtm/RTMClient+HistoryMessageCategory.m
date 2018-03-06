//
//  RTMClient+HistoryMessageCategory.m
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "../fpnn/FPNNSDK.h"
#import "RTMClient+HistoryMessageCategory.h"

@implementation RTMHistroyMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _storeId = 0;
        _senderUid = 0;
        _mType = 0;
        _fType = 0;
        _mid = 0;
        _message = nil;
        _attrs = nil;
        _modifiedTimeSince1970 = 0;
    }
    return self;
}

@end


@implementation RTMP2PHistroyMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _peerUid = 0;
        _direction = RTM_SendAndReceived;
    }
    return self;
}

@end


@implementation RTMHistroyMessageList

@end


@implementation RTMGetHistroyMessageParameters

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _count = 10;
        _orderByDesc = YES;
        _pageIndex = 0;
        _localStroedNewestMid = 0;
        _localStoredStoreId = 0;
        _interestedMTypes = nil;
    }
    return self;
}

@end


@implementation RTMClient (HistoryMessageCategory)

- (RTMHistroyMessageList<RTMHistroyMessage*>*)buildHistroyMessageList:(NSDictionary*)answerPayload
{
    NSNumber* number = nil;
    RTMHistroyMessageList<RTMHistroyMessage*>* result = [[RTMHistroyMessageList<RTMHistroyMessage*> alloc] init];
    number = (NSNumber*)[answerPayload valueForKey:@"num"];
    result.count = number.intValue;
    
    number = (NSNumber*)[answerPayload valueForKey:@"maxid"];
    result.maxStoreId = number.longLongValue;
    
    NSMutableArray<RTMHistroyMessage*>* realArray = [NSMutableArray<RTMHistroyMessage*> array];
    result.messageList = realArray;
    
    NSArray* rawList = (NSArray*)[answerPayload valueForKey:@"msgs"];
    if (rawList)
    {
        for (NSArray* item in rawList) {
            if ([item count] < 8)
                continue;
            
            RTMHistroyMessage* messageUint = [[RTMHistroyMessage alloc] init];
            number = (NSNumber*)[item objectAtIndex:0];
            messageUint.storeId = number.longLongValue;
            number = (NSNumber*)[item objectAtIndex:1];
            messageUint.senderUid = number.longLongValue;
            number = (NSNumber*)[item objectAtIndex:2];
            messageUint.mType = number.charValue;
            number = (NSNumber*)[item objectAtIndex:3];
            messageUint.fType = number.charValue;
            
            number = (NSNumber*)[item objectAtIndex:4];
            messageUint.mid = number.longLongValue;
            messageUint.message = (NSString*)[item objectAtIndex:5];
            messageUint.attrs = (NSString*)[item objectAtIndex:6];
            
            number = (NSNumber*)[item objectAtIndex:7];
            messageUint.modifiedTimeSince1970 = number.longValue;
            
            [realArray addObject:messageUint];
        }
    }
    
    return result;
}

//-----------------[getgroupmsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgroupmsg"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    if (answer.errorAnswer)
        return nil;
    
    return [self buildHistroyMessageList:answer.payload];
}

- (RTMHistroyMessageList<RTMHistroyMessage*>*)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters
{
    return [self getGroupMessage:groupId withParameters:parameters timeout:self.questTimeout];
}

- (BOOL)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgroupmsg"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        RTMHistroyMessageList<RTMHistroyMessage*>* result = nil;
        if (errorCode == FPNN_EC_OK)
            result = [self buildHistroyMessageList:payload];
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(result, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block
{
    return [self getGroupMessage:groupId withParameters:parameters withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getroommsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getroommsg"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    if (answer.errorAnswer)
        return nil;
    
    return [self buildHistroyMessageList:answer.payload];
}

- (RTMHistroyMessageList<RTMHistroyMessage*>*)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters
{
    return [self getRoomMessage:roomId withParameters:parameters timeout:self.questTimeout];
}

- (BOOL)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getroommsg"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        RTMHistroyMessageList<RTMHistroyMessage*>* result = nil;
        if (errorCode == FPNN_EC_OK)
            result = [self buildHistroyMessageList:payload];
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(result, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block
{
    return [self getRoomMessage:roomId withParameters:parameters withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getbroadcastmsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getbroadcastmsg"];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    if (answer.errorAnswer)
        return nil;
    
    return [self buildHistroyMessageList:answer.payload];
}

- (RTMHistroyMessageList<RTMHistroyMessage*>*)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters
{
    return [self getBroadcastMessage:parameters timeout:self.questTimeout];
}

- (BOOL)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getbroadcastmsg"];
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        RTMHistroyMessageList<RTMHistroyMessage*>* result = nil;
        if (errorCode == FPNN_EC_OK)
            result = [self buildHistroyMessageList:payload];
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(result, errorCode, errorMessage);
    } timeout:timeout];
}
- (BOOL)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block
{
    return [self getBroadcastMessage:parameters withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getp2pmsg]-----------------//

- (RTMHistroyMessageList<RTMP2PHistroyMessage*>*)buildP2PHistroyMessageList:(NSDictionary*)answerPayload
{
    NSNumber* number = nil;
    RTMHistroyMessageList<RTMP2PHistroyMessage*>* result = [[RTMHistroyMessageList<RTMP2PHistroyMessage*> alloc] init];
    number = (NSNumber*)[answerPayload valueForKey:@"num"];
    result.count = number.intValue;
    
    number = (NSNumber*)[answerPayload valueForKey:@"maxid"];
    result.maxStoreId = number.longLongValue;
    
    NSMutableArray<RTMP2PHistroyMessage*>* realArray = [NSMutableArray<RTMP2PHistroyMessage*> array];
    result.messageList = realArray;
    
    NSArray* rawList = (NSArray*)[answerPayload valueForKey:@"msgs"];
    if (rawList)
    {
        for (NSArray* item in rawList) {
            if ([item count] < 9)
                continue;
            
            RTMP2PHistroyMessage* messageUint = [[RTMP2PHistroyMessage alloc] init];
            number = (NSNumber*)[item objectAtIndex:0];
            messageUint.storeId = number.longLongValue;
            
            number = (NSNumber*)[item objectAtIndex:1];
            messageUint.senderUid = number.longLongValue;
            messageUint.peerUid = number.longLongValue;
            
            number = (NSNumber*)[item objectAtIndex:2];
            messageUint.direction = number.charValue;
            
            number = (NSNumber*)[item objectAtIndex:3];
            messageUint.mType = number.charValue;
            number = (NSNumber*)[item objectAtIndex:4];
            messageUint.fType = number.charValue;
            
            number = (NSNumber*)[item objectAtIndex:5];
            messageUint.mid = number.longLongValue;
            messageUint.message = (NSString*)[item objectAtIndex:6];
            messageUint.attrs = (NSString*)[item objectAtIndex:7];
            
            number = (NSNumber*)[item objectAtIndex:8];
            messageUint.modifiedTimeSince1970 = number.longValue;
            
            [realArray addObject:messageUint];
        }
    }
    
    return result;
}

- (RTMHistroyMessageList<RTMP2PHistroyMessage*>*)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getp2pmsg"];
    [quest param:@"fromuid" value:[NSNumber numberWithLongLong:fromUid]];
    [quest param:@"direction" value:[NSNumber numberWithInt:direction]];
    
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    if (answer.errorAnswer)
        return nil;
    
    return [self buildP2PHistroyMessageList:answer.payload];
}

- (RTMHistroyMessageList<RTMP2PHistroyMessage*>*)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters
{
    return [self getP2PMessage:fromUid byDirection:direction withParameters:parameters timeout:self.questTimeout];
}

- (BOOL)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMP2PHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getp2pmsg"];
    [quest param:@"fromuid" value:[NSNumber numberWithLongLong:fromUid]];
    [quest param:@"direction" value:[NSNumber numberWithInt:direction]];
    
    [quest param:@"num" value:[NSNumber numberWithInt:parameters.count]];
    [quest param:@"desc" value:[NSNumber numberWithBool:parameters.orderByDesc]];
    [quest param:@"page" value:[NSNumber numberWithInt:parameters.pageIndex]];
    [quest param:@"localmid" value:[NSNumber numberWithLongLong:parameters.localStroedNewestMid]];
    [quest param:@"localid" value:[NSNumber numberWithLongLong:parameters.localStoredStoreId]];
    if (parameters.interestedMTypes)
        [quest param:@"mtypes" value:parameters.interestedMTypes];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        RTMHistroyMessageList<RTMP2PHistroyMessage*>* result = nil;
        if (errorCode == FPNN_EC_OK)
            result = [self buildP2PHistroyMessageList:payload];
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(result, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMP2PHistroyMessage*>* result, int errorCode, NSString* errorMessage))block
{
    return [self getP2PMessage:fromUid byDirection:direction withParameters:parameters withCallbackBlock:block timeout:self.questTimeout];
}

@end
