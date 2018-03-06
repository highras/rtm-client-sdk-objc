//
//  RTMEventHandlerDelegate.h
//  rtm
//
//  Created by 施王兴 on 2018/1/8.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTMEventHandlerDelegate <NSObject>

@required

- (void)bye;
- (void)kickout;

- (void)recvP2PMessage:(int64_t)fromUid mType:(int8_t)mType fType:(int8_t)fType mid:(int64_t)mid message:(NSString*)message attrs:(NSString*)attrs;
- (void)recvGroupMessage:(int64_t)groupId fromUid:(int64_t)fromUid mType:(int8_t)mType fType:(int8_t)fType mid:(int64_t)mid message:(NSString*)message attrs:(NSString*)attrs;
- (void)recvRoomMessage:(int64_t)roomId fromUid:(int64_t)fromUid mType:(int8_t)mType fType:(int8_t)fType mid:(int64_t)mid message:(NSString*)message attrs:(NSString*)attrs;
- (void)recvBroadcastMessage:(int64_t)fromUid mType:(int8_t)mType fType:(int8_t)fType mid:(int64_t)mid message:(NSString*)message attrs:(NSString*)attrs;

- (void)recvTranslatedP2PMessage:(int64_t)fromUid mid:(int64_t)mid originalMid:(int64_t)originalMid message:(NSString*)message;
- (void)recvTranslatedGroupMessage:(int64_t)groupId fromUid:(int64_t)fromUid mid:(int64_t)mid originalMid:(int64_t)originalMid message:(NSString*)message;
- (void)recvTranslatedRoomMessage:(int64_t)roomId fromUid:(int64_t)fromUid mid:(int64_t)mid originalMid:(int64_t)originalMid message:(NSString*)message;
- (void)recvTranslatedBroadcastMessage:(int64_t)fromUid mid:(int64_t)mid originalMid:(int64_t)originalMid message:(NSString*)message;

//-- Array elements is NSNumber, please using [NSNumber longLongValue] to get ids.
- (void)unreadMessageStatus:(NSArray*)uidOfUnreadP2PMessages uidOfUnreadGroupMessages:(NSArray*)uidOfUnreadGroupMessages haveUnreadBroadcastMessages:(BOOL)haveUnreadBroadcastMessages;

@optional

- (void)auth:(BOOL)successful;
- (void)authException:(int)errorCode withMessage:(NSString*)message;
- (void)connectionWillClose:(BOOL)closeByError;

@end
