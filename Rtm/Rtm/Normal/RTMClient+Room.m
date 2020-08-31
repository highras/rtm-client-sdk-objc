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
#import "RTMAudioTools.h"
#import "RTMMessageModelConvert.h"

@implementation RTMClient (Room)

-(void)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                 messageType:(NSNumber * _Nonnull)messageType
                     message:(NSString * _Nonnull)message
                       attrs:(NSString * _Nonnull)attrs
                     timeout:(int)timeout
                     success:(void(^)(int64_t mtime))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    messageTypeFilter(messageType.intValue)
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback([[data objectForKey:@"mtime"] longLongValue]);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
}
-(RTMSendAnswer*)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                           messageType:(NSNumber * _Nonnull)messageType
                               message:(NSString * _Nonnull)message
                                 attrs:(NSString * _Nonnull)attrs
                               timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    messageTypeFilterSync(messageType.intValue)
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)sendRoomBinaryMessageWithId:(NSNumber * _Nonnull)roomId
                       messageType:(NSNumber * _Nonnull)messageType
                              data:(NSData * _Nonnull)data
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                           success:(void(^)(int64_t mtime))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback{
    
    messageTypeFilter(messageType.intValue)
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        if (successCallback) {
            successCallback([[data objectForKey:@"mtime"] longLongValue]);
        }

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
}
-(RTMSendAnswer*)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                           messageType:(NSNumber * _Nonnull)messageType
                                  data:(NSData * _Nonnull)data
                                 attrs:(NSString * _Nonnull)attrs
                               timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    messageTypeFilterSync(messageType.intValue)
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
    
}






-(void)getRoomHistoryMessageWithId:(NSNumber * _Nonnull)roomId
                              desc:(BOOL)desc
                               num:(NSNumber * _Nonnull)num
                             begin:(NSNumber * _Nullable)begin
                               end:(NSNumber * _Nullable)end
                            lastid:(NSNumber * _Nullable)lastid
                            mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                           timeout:(int)timeout
                           success:(void(^)(RTMHistory* _Nullable history))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback{
    
//    messageTypeGetHistoryFilter
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
//        NSLog(@"%@",data);
        
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {

            RTMHistoryMessage * msgOb = [RTMMessageModelConvert roomHistoryMessageModelConvert:itemArray];
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
-(RTMHistoryMessageAnswer*)getRoomHistoryMessageWithId:(NSNumber * _Nonnull)roomId
                                                  desc:(BOOL)desc
                                                   num:(NSNumber * _Nonnull)num
                                                 begin:(NSNumber * _Nullable)begin
                                                   end:(NSNumber * _Nullable)end
                                                lastid:(NSNumber * _Nullable)lastid
                                                mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                               timeout:(int)timeout{
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
//    messageTypeGetHistoryFilterSync
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert roomHistoryMessageModelConvert:itemArray];
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





-(void)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                        roomId:(NSNumber * _Nonnull)roomId
                    fromUserId:(NSNumber * _Nonnull)fromUserId
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMBaseAnswer*)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                                  roomId:(NSNumber * _Nonnull)roomId
                              fromUserId:(NSNumber * _Nonnull)fromUserId
                                 timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}



-(void)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                     roomId:(NSNumber * _Nonnull)roomId
                 fromUserId:(NSNumber * _Nonnull)fromUserId
                    timeout:(int)timeout
                    success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMGetMessageAnswer*)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                                     roomId:(NSNumber * _Nonnull)roomId
                                 fromUserId:(NSNumber * _Nonnull)fromUserId
                                    timeout:(int)timeout{
    RTMGetMessageAnswer * model = [RTMGetMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:roomId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(3) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.getMessage = [RTMMessageModelConvert getMessageModelConvert:answer.responseData];
    }else{
        model.error = answer.error;
    }
    
    return model;
}



-(void)enterRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"enterroom" message:dic twoWay:YES];
    
    BOOL result = [mainClient sendQuest:quest
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
-(RTMBaseAnswer*)enterRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"enterroom" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}


-(void)leaveRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"leaveroom" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMBaseAnswer*)leaveRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"leaveroom" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)getUserAtRoomsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable roomArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserrooms" message:nil twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback([data objectForKey:@"rooms"]);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
    
    handlerNetworkError;
    
}
-(RTMMemberAnswer*)getUserAtRoomsWithTimeout:(int)timeout{
    
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserrooms" message:nil twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
//        NSLog(@"%@",answer.responseData);
        model.dataArray = [answer.responseData objectForKey:@"rooms"];
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}







-(void)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
                openInfo:(NSString * _Nullable)openInfo
             privateInfo:(NSString * _Nullable)privateInfo
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setroominfo" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMBaseAnswer*)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
                          openInfo:(NSString * _Nullable)openInfo
                       privateInfo:(NSString * _Nullable)privateInfo
                           timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privateInfo forKey:@"pinfo"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setroominfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}






-(void)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                 timeout:(int)timeout
                 success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback {
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroominfo" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMInfoAnswer*)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                        timeout:(int)timeout{
    
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroominfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.openInfo = [answer.responseData objectForKey:@"oinfo"];
        model.privateInfo = [answer.responseData objectForKey:@"pinfo"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}





-(void)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                            timeout:(int)timeout
                            success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroomopeninfo" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
-(RTMInfoAnswer*)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                               timeout:(int)timeout{
    
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroomopeninfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.openInfo = [answer.responseData objectForKey:@"oinfo"];
        model.privateInfo = [answer.responseData objectForKey:@"pinfo"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)stranscribeRoomWithId:(NSNumber * _Nonnull)messageId
                  fromUserId:(NSNumber * _Nonnull)fromUserId
                    toRoomId:(NSNumber * _Nonnull)toRoomId
             profanityFilter:(BOOL)profanityFilter
                     timeout:(int)timeout
                     success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:toRoomId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(3) forKey:@"type"];
    [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
    
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES];
    
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        
        if (successCallback) {
            RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
            model.lang = [data objectForKey:@"lang"];
            model.text = [data objectForKey:@"text"];
            successCallback(model);
        }
        

    }fail:^(FPNError * _Nullable error) {
    
        _failCallback(error);

    }];

    
    handlerNetworkError;
    
}

-(RTMSpeechRecognitionAnswer*)stranscribeRoomWithId:(NSNumber * _Nonnull)messageId
                                         fromUserId:(NSNumber * _Nonnull)fromUserId
                                           toRoomId:(NSNumber * _Nonnull)toRoomId
                                    profanityFilter:(BOOL)profanityFilter
                                            timeout:(int)timeout{
    
    
    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
    clientConnectStatueVerifySync
    
     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
       [dic setValue:messageId forKey:@"mid"];
       [dic setValue:toRoomId forKey:@"xid"];
       [dic setValue:fromUserId forKey:@"from"];
       [dic setValue:@(3) forKey:@"type"];
       [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
    
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
        model.lang = [answer.responseData objectForKey:@"lang"];
        model.text = [answer.responseData objectForKey:@"text"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}
@end
