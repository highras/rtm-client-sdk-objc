//
//  RTMClient+Room.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Room.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"



@implementation RTMClient (Room)

-(void)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
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
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                           messageType:(NSNumber * _Nonnull)messageType
                               message:(NSString*)message
                                 attrs:(NSString*)attrs
                              timeout:(int)timeout{
    
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}



-(void)sendRoomBinaryMessageWithId:(NSNumber * _Nonnull)roomId
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
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)sendRoomBinaryMessageWithId:(NSNumber * _Nonnull)roomId
                             messageType:(NSNumber * _Nonnull)messageType
                                    data:(NSData * )data
                                   attrs:(NSString*)attrs
                                 timeout:(int)timeout{
    
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}




-(void)getRoomMessageWithId:(NSNumber * _Nonnull)roomId
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
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getRoomMessageWithId:(NSNumber * _Nonnull)roomId
                                          desc:(BOOL)desc
                                           num:(NSNumber * _Nonnull)num
                                         begin:(NSNumber * _Nullable)begin
                                           end:(NSNumber * _Nullable)end
                                        lastid:(NSNumber * _Nullable)lastid
                                        mtypes:(NSArray * _Nullable)mtypes
                           timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
}


-(void)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                         roomId:(NSNumber * _Nonnull)roomId
                        timeout:(int)timeout
                           tag:(id)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                               roomId:(NSNumber * _Nonnull)roomId
                              timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}




-(void)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                     roomId:(NSNumber * _Nonnull)roomId
                    timeout:(int)timeout
                        tag:(id _Nullable)tag
                    success:(RTMAnswerSuccessCallBack)successCallback
                       fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                           roomId:(NSNumber * _Nonnull)roomId
                          timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




-(void)enterRoomWithId:(NSNumber * _Nonnull)roomId
            timeout:(int)timeout
                   tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"enterroom" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)enterRoomWithId:(NSNumber * _Nonnull)roomId
                     timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"enterroom" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)leaveRoomWithId:(NSNumber * _Nonnull)roomId
            timeout:(int)timeout
                   tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"leaveroom" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)leaveRoomWithId:(NSNumber * _Nonnull)roomId
                     timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"leaveroom" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)getUserAtRoomsWithTimeout:(int)timeout
                                tag:(id)tag
                            success:(RTMAnswerSuccessCallBack)successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserrooms" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getUserAtRoomsWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserrooms" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
           openInfo:(NSString * _Nullable)openInfo
        privateInfo:(NSString * _Nullable)privateInfo
            timeout:(int)timeout
                     tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setroominfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
                 openInfo:(NSString * _Nullable)openInfo
              privateInfo:(NSString * _Nullable)privateInfo
                        timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setroominfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
            timeout:(int)timeout
                     tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroominfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
    
}
-(RTMAnswer*)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                        timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroominfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}

-(void)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
            timeout:(int)timeout
                         tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroomopeninfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                            timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroomopeninfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




@end
