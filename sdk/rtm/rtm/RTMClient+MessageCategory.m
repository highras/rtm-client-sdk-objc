//
//  RTMClient+MessageCategory.m
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "../fpnn/FPNNSDK.h"
#import "RTMClient+MessageCategory.h"

@implementation RTMTranslationResult

@end

@implementation RTMClient (MessageCategory)

//-----------------[ sendmsg ]-----------------//
- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendmsg"];
    [quest param:@"to" value:[NSNumber numberWithLongLong:toUserId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs
{
    return [self sendMessage:toUserId mType:mType message:message attrs:attrs timeout:self.questTimeout];
}

- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendmsg"];
    [quest param:@"to" value:[NSNumber numberWithLongLong:toUserId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)sendMessage:(int64_t)toUserId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendMessage:toUserId mType:mType message:message attrs:attrs withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendmsgs]-----------------//
- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendmsgs"];
    [quest param:@"tos" value:toUserIds];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs
{
    return [self sendMessages:toUserIds mType:mType message:message attrs:attrs timeout:self.questTimeout];
}

- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendmsgs"];
    [quest param:@"tos" value:toUserIds];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)sendMessages:(NSSet<NSNumber*>*)toUserIds mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendMessages:toUserIds mType:mType message:message attrs:attrs withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendgroupmsg]-----------------//
- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendgroupmsg"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs
{
    return [self sendGroupMessage:groupId mType:mType message:message attrs:attrs timeout:self.questTimeout];
}

- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendgroupmsg"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)sendGroupMessage:(int64_t)groupId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendGroupMessage:groupId mType:mType message:message attrs:attrs withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendroommsg]-----------------//
- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendroommsg"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs
{
    return [self sendRoomMessage:roomId mType:mType message:message attrs:attrs timeout:self.questTimeout];
}

- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    int64_t mid = [self genNewId];
    FPNNQuest* quest = [FPNNQuest quest:@"sendroommsg"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    [quest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
    [quest param:@"mtype" value:[NSNumber numberWithInt:mType]];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)sendRoomMessage:(int64_t)roomId mType:(int8_t)mType message:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendRoomMessage:roomId mType:mType message:message attrs:attrs withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[addfriends]-----------------//
- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addfriends"];
    [quest param:@"friends" value:friendUids];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids
{
    return [self addFriends:friendUids timeout:self.questTimeout];
}

- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addfriends"];
    [quest param:@"friends" value:friendUids];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)addFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self addFriends:friendUids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[delfriends]-----------------//
- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"delfriends"];
    [quest param:@"friends" value:friendUids];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids
{
    return [self deleteFriends:friendUids timeout:self.questTimeout];
}

- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"delfriends"];
    [quest param:@"friends" value:friendUids];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)deleteFriends:(NSSet<NSNumber*>*)friendUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self deleteFriends:friendUids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getfriends]-----------------//
- (NSArray<NSNumber*>*)getFriends:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getfriends"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    NSArray* list = (NSArray*)[answer get:@"uids"];
    if (list)
    {
        NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
        for (NSNumber* uid in list)
            [rev addObject:uid];
        
        return rev;
    }
    else
        return nil;
}

- (NSArray<NSNumber*>*)getFriends
{
    return [self getFriends:self.questTimeout];
}

- (BOOL)getFriendsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* friendUids, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getfriends"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSMutableArray<NSNumber*>* rev = nil;
        if (errorCode == FPNN_EC_OK)
        {
            NSArray* list = (NSArray*)[payload objectForKey:@"uids"];
            NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
            for (NSNumber* uid in list)
                [rev addObject:uid];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(rev, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getFriendsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* friendUids, int errorCode, NSString* errorMessage))block
{
    return [self getFriendsWithCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[addgroupmembers]-----------------//
- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"friends" value:memberUids];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids
{
    return [self addGroupMembers:groupId withMembers:memberUids timeout:self.questTimeout];
}

- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"friends" value:memberUids];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)addGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self addGroupMembers:groupId withMembers:memberUids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[delgroupmembers]-----------------//
- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"delgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"friends" value:memberUids];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids
{
    return [self deleteGroupMembers:groupId withMembers:memberUids timeout:self.questTimeout];
}

- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"delgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    [quest param:@"friends" value:memberUids];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)deleteGroupMembers:(int64_t)groupId withMembers:(NSSet<NSNumber*>*)memberUids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self deleteGroupMembers:groupId withMembers:memberUids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getgroupmembers]-----------------//
- (NSArray<NSNumber*>*)getGroupMembers:(int64_t)groupId timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    NSArray* list = (NSArray*)[answer get:@"uids"];
    if (list)
    {
        NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
        for (NSNumber* uid in list)
            [rev addObject:uid];
        
        return rev;
    }
    else
        return nil;
}

- (NSArray<NSNumber*>*)getGroupMembers:(int64_t)groupId
{
    return [self getGroupMembers:groupId timeout:self.questTimeout];
}

- (BOOL)getGroupMembers:(int64_t)groupId withCallbackBlock:(void(^)(NSArray<NSNumber*>* memberUids, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgroupmembers"];
    [quest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSMutableArray<NSNumber*>* rev = nil;
        if (errorCode == FPNN_EC_OK)
        {
            NSArray* list = (NSArray*)[payload objectForKey:@"uids"];
            NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
            for (NSNumber* uid in list)
                [rev addObject:uid];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(rev, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getGroupMembers:(int64_t)groupId withCallbackBlock:(void(^)(NSArray<NSNumber*>* memberUids, int errorCode, NSString* errorMessage))block
{
    return [self getGroupMembers:groupId withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getusergroups]-----------------//
- (NSArray<NSNumber*>*)getUserGroups:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getusergroups"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    NSArray* list = (NSArray*)[answer get:@"gids"];
    if (list)
    {
        NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
        for (NSNumber* uid in list)
            [rev addObject:uid];
        
        return rev;
    }
    else
        return nil;
}

- (NSArray<NSNumber*>*)getUserGroups
{
    return [self getUserGroups:self.questTimeout];
}

- (BOOL)getUserGroupsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* groupIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getusergroups"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSMutableArray<NSNumber*>* rev = nil;
        if (errorCode == FPNN_EC_OK)
        {
            NSArray* list = (NSArray*)[payload objectForKey:@"gids"];
            NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
            for (NSNumber* uid in list)
                [rev addObject:uid];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(rev, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getUserGroupsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* groupIds, int errorCode, NSString* errorMessage))block
{
    return [self getUserGroupsWithCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[enterroom]-----------------//
- (BOOL)enterRoom:(int64_t)roomId timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"enterroom"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)enterRoom:(int64_t)roomId
{
    return [self enterRoom:roomId timeout:self.questTimeout];
}

- (BOOL)enterRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"enterroom"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)enterRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return[self enterRoom:roomId withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[leaveroom]-----------------//
- (BOOL)leaveRoom:(int64_t)roomId timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"leaveroom"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)leaveRoom:(int64_t)roomId
{
    return [self leaveRoom:roomId timeout:self.questTimeout];
}

- (BOOL)leaveRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"leaveroom"];
    [quest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)leaveRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return[self leaveRoom:roomId withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getuserrooms]-----------------//
- (NSArray<NSNumber*>*)getUserRooms:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getuserrooms"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    NSArray* list = (NSArray*)[answer get:@"rooms"];
    if (list)
    {
        NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
        for (NSNumber* uid in list)
            [rev addObject:uid];
        
        return rev;
    }
    else
        return nil;
}

- (NSArray<NSNumber*>*)getUserRooms
{
    return [self getUserRooms:self.questTimeout];
}

- (BOOL)getUserRoomsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* roomIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getuserrooms"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSMutableArray<NSNumber*>* rev = nil;
        if (errorCode == FPNN_EC_OK)
        {
            NSArray* list = (NSArray*)[payload objectForKey:@"rooms"];
            NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
            for (NSNumber* uid in list)
                [rev addObject:uid];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(rev, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getUserRoomsWithCallbackBlock:(void(^)(NSArray<NSNumber*>* roomIds, int errorCode, NSString* errorMessage))block
{
    return [self getUserRoomsWithCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getonlineusers]-----------------//
- (NSArray<NSNumber*>*)getOnlineUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getonlineusers"];
    [quest param:@"uids" value:uids];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    NSArray* list = (NSArray*)[answer get:@"uids"];
    if (list)
    {
        NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
        for (NSNumber* uid in list)
            [rev addObject:uid];
        
        return rev;
    }
    else
        return nil;
}

- (NSArray<NSNumber*>*)getOnlineUsers:(NSSet<NSNumber*>*)uids
{
    return [self getOnlineUsers:uids timeout:self.questTimeout];
}

- (BOOL)getOnlineUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(NSArray<NSNumber*>* onlineUserIds, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getonlineusers"];
    [quest param:@"uids" value:uids];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSMutableArray<NSNumber*>* rev = nil;
        if (errorCode == FPNN_EC_OK)
        {
            NSArray* list = (NSArray*)[payload objectForKey:@"uids"];
            NSMutableArray<NSNumber*>* rev = [NSMutableArray<NSNumber*> array];
            for (NSNumber* uid in list)
                [rev addObject:uid];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(rev, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getOnlineUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(NSArray<NSNumber*>* onlineUserIds, int errorCode, NSString* errorMessage))block
{
    return [self getOnlineUsers:uids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[setlang]-----------------//
- (BOOL)setTranslationLanguage:(NSString*)language timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setlang"];
    [quest param:@"lang" value:language];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)setTranslationLanguage:(NSString*)language
{
    return [self setTranslationLanguage:language timeout:self.questTimeout];
}

- (BOOL)setTranslationLanguage:(NSString*)language withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setlang"];
    [quest param:@"lang" value:language];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)setTranslationLanguage:(NSString*)language withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self setTranslationLanguage:language withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[translate]-----------------//
- (RTMTranslationResult*)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"translate"];
    [quest param:@"text" value:string];
    [quest param:@"src" value:originalLanguage];
    [quest param:@"dst" value:targetLanguage];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    if (answer.errorAnswer)
        return nil;
    
    RTMTranslationResult* result = [[RTMTranslationResult alloc] init];
    result.originalString = (NSString*)[answer get:@"stext"];
    result.originalLanguage = (NSString*)[answer get:@"src"];
    result.targetString = (NSString*)[answer get:@"dtext"];
    result.targetLanguage = (NSString*)[answer get:@"dst"];
    
    if (result.originalString && result.originalLanguage && result.targetString && result.targetLanguage)
        return result;
    else
        return nil;
}

- (RTMTranslationResult*)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage
{
    return [self translate:string fromLanguage:originalLanguage toLanguage:targetLanguage timeout:self.questTimeout];
}

- (BOOL)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage withCallbackBlock:(void(^)(RTMTranslationResult* result, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"translate"];
    [quest param:@"text" value:string];
    [quest param:@"src" value:originalLanguage];
    [quest param:@"dst" value:targetLanguage];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        RTMTranslationResult* result = nil;
        if (errorCode == FPNN_EC_OK)
        {
            result = [[RTMTranslationResult alloc] init];
            result.originalString = (NSString*)[payload valueForKey:@"stext"];
            result.originalLanguage = (NSString*)[payload valueForKey:@"src"];
            result.targetString = (NSString*)[payload valueForKey:@"dtext"];
            result.targetLanguage = (NSString*)[payload valueForKey:@"dst"];
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(result, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)translate:(NSString*)string fromLanguage:(NSString*)originalLanguage toLanguage:(NSString*)targetLanguage withCallbackBlock:(void(^)(RTMTranslationResult* result, int errorCode, NSString* errorMessage))block
{
    return [self translate:string fromLanguage:originalLanguage toLanguage:targetLanguage withCallbackBlock:block timeout:self.questTimeout];
}

@end
