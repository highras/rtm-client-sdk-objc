//
//  RTMClient+HistoryMessageCategory.h
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"

@interface RTMHistroyMessage : NSObject

@property (nonatomic) int64_t storeId;
@property (nonatomic) int64_t senderUid;
@property (nonatomic) int8_t mType;
@property (nonatomic) int8_t fType;
@property (nonatomic) int64_t mid;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* attrs;
@property (nonatomic) NSTimeInterval modifiedTimeSince1970;

@end

enum RTMMessageDirection
{
    RTM_SendAndReceived = 0,
    RTM_Sent = 1,
    RTM_Received = 2
};

@interface RTMP2PHistroyMessage : RTMHistroyMessage

@property (nonatomic) int64_t peerUid;
@property (nonatomic) enum RTMMessageDirection direction;

@end

@interface RTMHistroyMessageList<__covariant T> : NSObject

@property (nonatomic) int count;
@property (nonatomic) int64_t maxStoreId;
@property (strong, nonatomic) NSArray<T>* messageList;

@end


@interface RTMGetHistroyMessageParameters : NSObject

@property (nonatomic) int count;
@property (nonatomic) BOOL orderByDesc;
@property (nonatomic) int pageIndex;
@property (nonatomic) int64_t localStroedNewestMid;
@property (nonatomic) int64_t localStoredStoreId;
@property (nonatomic, strong) NSSet<NSNumber*>* interestedMTypes;

@end


@interface RTMClient (HistoryMessageCategory)

//-----------------[getgroupmsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout;
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters;
- (BOOL)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getGroupMessage:(int64_t)groupId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block;

//-----------------[getroommsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout;
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters;
- (BOOL)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getRoomMessage:(int64_t)roomId withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block;

//-----------------[getbroadcastmsg]-----------------//
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout;
- (RTMHistroyMessageList<RTMHistroyMessage*>*)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters;
- (BOOL)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getBroadcastMessage:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMHistroyMessage*>* result, int errorCode, NSString* errorMessage))block;

//-----------------[getp2pmsg]-----------------//
- (RTMHistroyMessageList<RTMP2PHistroyMessage*>*)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters timeout:(int)timeout;
- (RTMHistroyMessageList<RTMP2PHistroyMessage*>*)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters;
- (BOOL)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMP2PHistroyMessage*>* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getP2PMessage:(int64_t)fromUid byDirection:(enum RTMMessageDirection)direction withParameters:(RTMGetHistroyMessageParameters*)parameters withCallbackBlock:(void(^)(RTMHistroyMessageList<RTMP2PHistroyMessage*>* result, int errorCode, NSString* errorMessage))block;

@end
