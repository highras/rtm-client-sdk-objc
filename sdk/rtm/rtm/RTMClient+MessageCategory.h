//
//  RTMClient+MessageCategory.h
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"

@interface RTMTranslationResult : NSObject

@property (strong, nonatomic) NSString* originalString;
@property (strong, nonatomic) NSString* originalLanguage;
@property (strong, nonatomic) NSString* targetString;
@property (strong, nonatomic) NSString* targetLanguage;

@end

@interface RTMClient (MessageCategory)

//-----------------[ sendmsg ]-----------------//
- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout;
- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs;
- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendmsgs]-----------------//
- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout;
- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs;
- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendgroupmsg]-----------------//
- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout;
- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs;
- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendroommsg]-----------------//
- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout;
- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs;
- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[addfriends]-----------------//
- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids timeout:(int)timeout;
- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids;
- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[delfriends]-----------------//
- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids timeout:(int)timeout;
- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids;
- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[getfriends]-----------------//
- (NSArray<NSNumber*>*)getFriends:(int)timeout;
- (NSArray<NSNumber*>*)getFriends;
- (BOOL)getFriendsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* friendUids, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getFriendsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* friendUids, int errorCode, NSString* errorMessage))block;

//-----------------[addgroupmembers]-----------------//
- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids timeout:(int)timeout;
- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids;
- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[delgroupmembers]-----------------//
- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids timeout:(int)timeout;
- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids;
- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[getgroupmembers]-----------------//
- (NSArray<NSNumber*>*)getGroupMembers:(int64_t)groupId timeout:(int)timeout;
- (NSArray<NSNumber*>*)getGroupMembers:(int64_t)groupId;
- (BOOL)getGroupMembers:(int64_t)groupId withCallbackBlock:(void(^)(NSArray<NSNumber*>* memberUids, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getGroupMembers:(int64_t)groupId withCallbackBlock:(void(^)(NSArray<NSNumber*>* memberUids, int errorCode, NSString* errorMessage))block;

//-----------------[getusergroups]-----------------//
- (NSArray<NSNumber*>*)getUserGroups:(int)timeout;
- (NSArray<NSNumber*>*)getUserGroups;
- (BOOL)getUserGroupsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* groupIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getUserGroupsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* groupIds, int errorCode, NSString* errorMessage))block;

//-----------------[enterroom]-----------------//
- (BOOL)enterRoom:(int64_t)roomId timeout:(int)timeout;
- (BOOL)enterRoom:(int64_t)roomId;
- (BOOL)enterRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)enterRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[leaveroom]-----------------//
- (BOOL)leaveRoom:(int64_t)roomId timeout:(int)timeout;
- (BOOL)leaveRoom:(int64_t)roomId;
- (BOOL)leaveRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)leaveRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[getuserrooms]-----------------//
- (NSArray<NSNumber*>*)getUserRooms:(int)timeout;
- (NSArray<NSNumber*>*)getUserRooms;
- (BOOL)getUserRoomsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* roomIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getUserRoomsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* roomIds, int errorCode, NSString* errorMessage))block;

//-----------------[getonlineusers]-----------------//
- (NSArray<NSNumber*>*)getOnlineUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout;
- (NSArray<NSNumber*>*)getOnlineUsers:(NSSet<NSNumber*>*)uids;
- (BOOL)getOnlineUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(NSArray<NSNumber*>* onlineUserIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getOnlineUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(NSArray<NSNumber*>* onlineUserIds, int errorCode, NSString* errorMessage))block;

//-----------------[setlang]-----------------//
- (BOOL)setTranslationLanguage:(NSString*)language timeout:(int)timeout;
- (BOOL)setTranslationLanguage:(NSString*)language;
- (BOOL)setTranslationLanguage:(NSString*)language withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)setTranslationLanguage:(NSString*)language withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[translate]-----------------//
- (RTMTranslationResult*)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage timeout:(int)timeout;
- (RTMTranslationResult*)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage;
- (BOOL)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage withCallbackBlock:(void(^)(RTMTranslationResult* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage withCallbackBlock:(void(^)(RTMTranslationResult* result, int errorCode, NSString* errorMessage))block;

@end
