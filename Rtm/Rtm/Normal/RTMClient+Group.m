//
//  RTMClient+Group.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Group.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAudioTools.h"
#import <Foundation/Foundation.h>
#import "RTMMessageModelConvert.h"
@implementation RTMClient (Group)

-(void)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                  messageType:(NSNumber * _Nonnull)messageType
                      message:(NSString * _Nonnull)message
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    
    messageTypeFilter(messageType.intValue)
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
            sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
            sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
            successCallback(sendAnswer);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
    
    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                            messageType:(NSNumber * _Nonnull)messageType
                                message:(NSString * _Nonnull)message
                                  attrs:(NSString * _Nonnull)attrs
                                timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    messageTypeFilterSync(messageType.intValue)
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}






-(void)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                        messageType:(NSNumber * _Nonnull)messageType
                               data:(NSData * _Nonnull)data
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout
                            success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    messageTypeFilter(messageType.intValue)
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
            sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
            sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
            successCallback(sendAnswer);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
    
    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                                  messageType:(NSNumber * _Nonnull)messageType
                                         data:(NSData * _Nonnull)data
                                        attrs:(NSString * _Nonnull)attrs
                                      timeout:(int)timeout{
    RTMSendAnswer * model = [RTMSendAnswer new];
    messageTypeFilterSync(messageType.intValue)
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
}




-(void)getGroupUnreadWithGroupIds:(NSArray<NSNumber*> * _Nonnull)groupIds
                            mtime:(int64_t)mtime
                     messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                          timeout:(int)timeout
                          success:(void(^)(RTMUnreadAnswer * _Nullable unreadAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupIds forKey:@"gids"];
    [dic setValue:@(mtime) forKey:@"mtime"];
    [dic setValue:messageTypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupunread" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        
        if (successCallback) {
            RTMUnreadAnswer* unreadAnswer  = [RTMUnreadAnswer new];
            unreadAnswer.unreadDictionary = [data objectForKey:@"group"];
            successCallback(unreadAnswer);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}

-(RTMUnreadAnswer *)getGroupUnreadWithGroupIds:(NSArray<NSNumber*> * _Nonnull)groupIds
                                         mtime:(int64_t)mtime
                                  messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                                       timeout:(int)timeout{
    
        RTMUnreadAnswer* model  = [RTMUnreadAnswer new];
        clientConnectStatueVerifySync
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:groupIds forKey:@"gids"];
        [dic setValue:@(mtime) forKey:@"mtime"];
        [dic setValue:messageTypes forKey:@"mtypes"];
        
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupunread" message:dic twoWay:YES];
        FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                           timeout:RTMClientSendQuestTimeout];
        
        if (answer.error == nil) {
            
            model.unreadDictionary = [answer.responseData objectForKey:@"group"];
            
        }else{
            model.error = answer.error;
        }
        
        return model;
    
}




-(void)getGroupHistoryMessageWithGroupId:(NSNumber * _Nonnull)groupId
                                    desc:(BOOL)desc
                                     num:(NSNumber * _Nonnull)num
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber * >* _Nullable)mtypes
                                 timeout:(int)timeout
                                 success:(void(^)(RTMHistory* _Nullable history))successCallback
                                    fail:(RTMAnswerFailCallBack)failCallback{
    
//    messageTypeGetHistoryFilter
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
//        NSLog(@"%@",data);
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert groupHistoryMessageModelConvert:itemArray];
            [resultArray addObject:msgOb];
            
        }];
        
        if (successCallback) {

            RTMHistory * history = [RTMHistory new];
            history.begin = [[data objectForKey:@"begin"] longLongValue];
            history.end = [[data objectForKey:@"end"] longLongValue];
            history.lastid = [[data objectForKey:@"lastid"] longLongValue];
            history.messageArray = resultArray;
            
            successCallback(history);
        }
        

        }fail:^(FPNError * _Nullable error) {
    
            _failCallback(error);

        }];
    
    handlerNetworkError;
    
}
-(RTMHistoryMessageAnswer*)getGroupHistoryMessageWithGroupId:(NSNumber * _Nonnull)groupId
                                                        desc:(BOOL)desc
                                                         num:(NSNumber * _Nonnull)num
                                                       begin:(NSNumber * _Nullable)begin
                                                         end:(NSNumber * _Nullable)end
                                                      lastid:(NSNumber * _Nullable)lastid
                                                      mtypes:(NSArray <NSNumber * >* _Nullable)mtypes
                                                     timeout:(int)timeout{
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
//    messageTypeGetHistoryFilterSync
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert groupHistoryMessageModelConvert:itemArray ];
            [resultArray addObject:msgOb];
            
        }];
        
        RTMHistory * history = [RTMHistory new];
        history.begin = [[answer.responseData objectForKey:@"begin"] longLongValue];
        history.end = [[answer.responseData objectForKey:@"end"] longLongValue];
        history.lastid = [[answer.responseData objectForKey:@"lastid"] longLongValue];
        history.messageArray = resultArray;
        model.history = history;
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}






-(void)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                        groupId:(NSNumber * _Nonnull)groupId
                     fromUserId:(NSNumber * _Nonnull)fromUserId
                        timeout:(int)timeout
                        success:(void(^)(void))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        
        if (successCallback) {
            successCallback();
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                                  groupId:(NSNumber * _Nonnull)groupId
                               fromUserId:(NSNumber * _Nonnull)fromUserId
                                  timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}





-(void)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                     groupId:(NSNumber * _Nonnull)groupId
                  fromUserId:(NSNumber * _Nonnull)fromUserId
                     timeout:(int)timeout
                     success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (data.allKeys > 0 ) {
            if (successCallback) {
                successCallback([RTMMessageModelConvert getMessageModelConvert:data]);
            }
        }else{
            if (successCallback) {
                successCallback(nil);
            }
        }
        

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
    
    
}
-(RTMGetMessageAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                                     groupId:(NSNumber * _Nonnull)groupId
                                  fromUserId:(NSNumber * _Nonnull)fromUserId
                                     timeout:(int)timeout{
    
    RTMGetMessageAnswer * model = [RTMGetMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.getMessage = [RTMMessageModelConvert getMessageModelConvert:answer.responseData];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}






-(void)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                   membersId:(NSArray*)membersId
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addgroupmembers" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback();
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                             membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                               timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addgroupmembers" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}







-(void)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      membersId:(NSArray*)membersId
                        timeout:(int)timeout
                        success:(void(^)(void))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delgroupmembers" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback();
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                                  timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delgroupmembers" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}






-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                     success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmembers" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        if (successCallback) {
            successCallback([data objectForKey:@"uids"]);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMMemberAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                 timeout:(int)timeout{
    
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmembers" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
//        NSLog(@"%@",answer.responseData);
        model.dataArray = [answer.responseData objectForKey:@"uids"];
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
    
}




-(void)getUserGroupsWithTimeout:(int)timeout
                        success:(void(^)(NSArray * _Nullable groupArray))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getusergroups" message:nil twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback([data objectForKey:@"gids"]);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMMemberAnswer*)getUserGroupsWithTimeout:(int)timeout{
    
   
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getusergroups" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
//        NSLog(@"%@",answer.responseData);
        model.dataArray = [answer.responseData objectForKey:@"gids"];
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                 openInfo:(NSString * _Nullable)openInfo
              privateInfo:(NSString * _Nullable)privateInfo
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgroupinfo" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback();
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                           openInfo:(NSString * _Nullable)openInfo
                        privateInfo:(NSString * _Nullable)privateInfo
                            timeout:(int)timeout{
    
        RTMBaseAnswer * model = [RTMBaseAnswer new];
        clientConnectStatueVerifySync
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:groupId forKey:@"gid"];
        [dic setValue:openInfo forKey:@"oinfo"];
        [dic setValue:privateInfo forKey:@"pinfo"];
        
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgroupinfo" message:dic twoWay:YES];
        FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                            timeout:RTMClientSendQuestTimeout];
        
        if (answer.error == nil) {
            
        }else{
            model.error = answer.error;
        }
        
        return model;
    
    
}






-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                  timeout:(int)timeout
                  success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupinfo" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            RTMInfoAnswer * model = [RTMInfoAnswer new];
            model.openInfo = [data objectForKey:@"oinfo"];
            model.privateInfo = [data objectForKey:@"pinfo"];
            successCallback(model);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
    
    
}
-(RTMInfoAnswer*)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                            timeout:(int)timeout{
    
   
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
        clientConnectStatueVerifySync
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:groupId forKey:@"gid"];
        
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupinfo" message:dic twoWay:YES];
        FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                            timeout:RTMClientSendQuestTimeout];
        
        if (answer.error == nil) {
            model.openInfo = [answer.responseData objectForKey:@"oinfo"];
            model.privateInfo = [answer.responseData objectForKey:@"pinfo"];
        }else{
            model.error = answer.error;
        }
        
        return model;
    
    
}




-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                      timeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupopeninfo" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            RTMInfoAnswer * model = [RTMInfoAnswer new];
            model.openInfo = [data objectForKey:@"oinfo"];
            successCallback(model);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}
-(RTMInfoAnswer*)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                                timeout:(int)timeout{
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupopeninfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.openInfo = [answer.responseData objectForKey:@"oinfo"];
        model.privateInfo = [answer.responseData objectForKey:@"pinfo"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                      timeout:(int)timeout
                      success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
   NSMutableDictionary * dic = [NSMutableDictionary dictionary];
   [dic setValue:groupIds forKey:@"gids"];
   FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupsopeninfo" message:dic twoWay:YES];
   BOOL result = [fpnnMainClient sendQuest:quest
                               timeout:RTMClientSendQuestTimeout
                               success:^(NSDictionary * _Nullable data) {
       
       if (successCallback) {
           RTMAttriAnswer * model = [RTMAttriAnswer new];
           model.atttriDictionary = [data objectForKey:@"info"];
           successCallback(model);
       }
       
   
   }fail:^(FPNError * _Nullable error) {
       
         _failCallback(error);

   }];
       
   handlerNetworkError;
    
}
-(RTMAttriAnswer*)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                                  timeout:(int)timeout{
    
    RTMAttriAnswer * model = [RTMAttriAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupIds forKey:@"gids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupsopeninfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.atttriDictionary = [answer.responseData objectForKey:@"info"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}





//-(void)stranscribeGroupWithId:(NSNumber * _Nonnull)messageId
//                   fromUserId:(NSNumber * _Nonnull)fromUserId
//                    toGroupId:(NSNumber * _Nonnull)toGroupId
//              profanityFilter:(BOOL)profanityFilter
//                      timeout:(int)timeout
//                      success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
//                         fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientConnectStatueVerify
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:messageId forKey:@"mid"];
//    [dic setValue:toGroupId forKey:@"xid"];
//    [dic setValue:fromUserId forKey:@"from"];
//    [dic setValue:@(2) forKey:@"type"];
//    [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    
//    // type: 1,p2p; 2,group; 3, room
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES];
//    
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//        
//        
//        if (successCallback) {
//            RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//            model.lang = [data objectForKey:@"lang"];
//            model.text = [data objectForKey:@"text"];
//            successCallback(model);
//        }
//        
//
//    }fail:^(FPNError * _Nullable error) {
//    
//        _failCallback(error);
//
//    }];
//
//    
//    handlerNetworkError;
//    
//}
//
//-(RTMSpeechRecognitionAnswer*)stranscribeGroupWithId:(NSNumber * _Nonnull)messageId
//                                          fromUserId:(NSNumber * _Nonnull)fromUserId
//                                           toGroupId:(NSNumber * _Nonnull)toGroupId
//                                     profanityFilter:(BOOL)profanityFilter
//                                             timeout:(int)timeout{
//    
//    
//    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//    clientConnectStatueVerifySync
//    
//     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//       [dic setValue:messageId forKey:@"mid"];
//       [dic setValue:toGroupId forKey:@"xid"];
//       [dic setValue:fromUserId forKey:@"from"];
//       [dic setValue:@(2) forKey:@"type"];
//       [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    
//    // type: 1,p2p; 2,group; 3, room
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES];
//    
//    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
//                                        timeout:RTMClientSendQuestTimeout];
//    
//    if (answer.error == nil) {
//        RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//        model.lang = [answer.responseData objectForKey:@"lang"];
//        model.text = [answer.responseData objectForKey:@"text"];
//    }else{
//        model.error = answer.error;
//    }
//    
//    return model;
//    
//    
//}
@end
