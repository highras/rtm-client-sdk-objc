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


@implementation RTMClient (Group)

-(void)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                     messageType:(NSNumber * _Nonnull)messageType
                         message:(NSString * _Nonnull)message
                           attrs:(NSString * _Nonnull)attrs
                         timeout:(int)timeout
                          tag:(id)tag
                         success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    messageTypeCallFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                           messageType:(NSNumber * _Nonnull)messageType
                               message:(NSString*)message
                                 attrs:(NSString*)attrs
                              timeout:(int)timeout{
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}


-(void)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                        messageType:(NSNumber * _Nonnull)messageType
                               data:(NSData * _Nonnull)data
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout
                                tag:(id)tag
                            success:(RTMAnswerSuccessCallBack)successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    messageTypeCallFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                              messageType:(NSNumber * _Nonnull)messageType
                                     data:(NSData * )data
                                    attrs:(NSString*)attrs
                                  timeout:(int)timeout{
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}




-(void)getGroupMessageWithId:(NSNumber * _Nonnull)groupId
                                    desc:(BOOL)desc
                                     num:(NSNumber * _Nonnull)num
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray * _Nullable)mtypes
                                 timeout:(int)timeout
                         tag:(id)tag
                                 success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmsg" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)groupId
                                          desc:(BOOL)desc
                                           num:(NSNumber * _Nonnull)num
                                         begin:(NSNumber * _Nullable)begin
                                           end:(NSNumber * _Nullable)end
                                        lastid:(NSNumber * _Nullable)lastid
                                        mtypes:(NSArray * _Nullable)mtypes
                           timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
}



-(void)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                         groupId:(NSNumber * _Nonnull)groupId
                        timeout:(int)timeout
                            tag:(id)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                              groupId:(NSNumber * _Nonnull)groupId
                              timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}



-(void)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                     groupId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                         tag:(id _Nullable)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
    
    
}
-(RTMAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                           groupId:(NSNumber * _Nonnull)groupId
                           timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:groupId forKey:@"xid"];
    [dic setValue:@(2) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
    
}





-(void)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                   membersId:(NSArray*)membersId
                     timeout:(int)timeout
                         tag:(id)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addgroupmembers" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                         membersId:(NSArray*)membersId
                           timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addgroupmembers" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}


-(void)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      membersId:(NSArray*)membersId
                        timeout:(int)timeout
                            tag:(id)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delgroupmembers" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                            membersId:(NSArray*)membersId
                              timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:membersId forKey:@"uids"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delgroupmembers" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}


-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                         tag:(id)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmembers" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                           timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupmembers" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)getUserGroupsWithTimeout:(int)timeout
                            tag:(id)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getusergroups" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getUserGroupsWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getusergroups" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
           openInfo:(NSString * _Nullable)openInfo
        privateInfo:(NSString * _Nullable)privateInfo
            timeout:(int)timeout
                      tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgroupinfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                 openInfo:(NSString * _Nullable)openInfo
              privateInfo:(NSString * _Nullable)privateInfo
                        timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgroupinfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
            timeout:(int)timeout
                      tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupinfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
    
}
-(RTMAnswer*)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                        timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupinfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}

-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
            timeout:(int)timeout
                          tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupopeninfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                            timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgroupopeninfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




@end
