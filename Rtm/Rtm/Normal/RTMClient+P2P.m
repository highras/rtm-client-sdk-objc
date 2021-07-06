//
//  RTMClient+PtoP.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+P2P.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAnswer.h"
#import "RTMAudioTools.h"
#import "RTMClientConfig.h"
#import <Foundation/Foundation.h>
#import "RTMMessageModelConvert.h"
@implementation RTMClient (P2P)

-(void)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                  messageType:(NSNumber * _Nonnull)messageType
                      message:(NSString * _Nonnull)message
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{

//    @autoreleasepool {
        messageTypeFilter(messageType.intValue)
            clientConnectStatueVerify
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:userId forKey:@"to"];
            [dic setValue:mid forKey:@"mid"];
            [dic setValue:messageType forKey:@"mtype"];
            [dic setValue:message forKey:@"msg"];
            [dic setValue:attrs forKey:@"attrs"];
            
            
                FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
                BOOL result = [fpnnMainClient sendQuest:quest
                                            timeout:RTMClientSendQuestTimeout
                                            success:^(NSDictionary * _Nullable data) {
                    
                    
                        
//                        if (successCallback) {
//                            @autoreleasepool {
                            
                                RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
                                sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
                                sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
                                successCallback(sendAnswer);
                                
//                            }
//                        }
                    
                    
                
                }fail:^(FPNError * _Nullable error) {
                    
                      _failCallback(error);

                }];
        //        NSLog(@"===%@",fpnnMainClient);
                handlerNetworkError;
//            }
//    }
//    
    
    
    
}
-(RTMSendAnswer*)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                     messageType:(NSNumber * _Nonnull)messageType
                         message:(NSString * _Nonnull)message
                           attrs:(NSString * _Nonnull)attrs
                         timeout:(int)timeout{
    
    @autoreleasepool {
        
        RTMSendAnswer * model = [RTMSendAnswer new];
        messageTypeFilterSync(messageType.intValue)
        clientConnectStatueVerifySync
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:userId forKey:@"to"];
        [dic setValue:mid forKey:@"mid"];
        [dic setValue:messageType forKey:@"mtype"];
        [dic setValue:message forKey:@"msg"];
        [dic setValue:attrs forKey:@"attrs"];
        
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
        
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
    
    
}

-(void)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                  messageType:(NSNumber * _Nonnull)messageType
                         data:(NSData * _Nonnull)data
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    messageTypeFilter(messageType.intValue)
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
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
-(RTMSendAnswer*)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                            messageType:(NSNumber * _Nonnull)messageType
                                   data:(NSData * _Nonnull)data
                                  attrs:(NSString * _Nonnull)attrs
                                timeout:(int)timeout{
    RTMSendAnswer * model = [RTMSendAnswer new];
    messageTypeFilterSync(messageType.intValue)
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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

//-(void)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
//                         mtime:(int64_t)mtime
//                  messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
//                       timeout:(int)timeout
//                       success:(void(^)(RTMUnreadAnswer * _Nullable unreadAnswer))successCallback
//                          fail:(RTMAnswerFailCallBack)failCallback{
//
//
//    clientConnectStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userIds forKey:@"uids"];
//    [dic setValue:@(mtime) forKey:@"mtime"];
//    [dic setValue:messageTypes forKey:@"mtypes"];
//
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2punread" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
//
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//
//
//        if (successCallback) {
//            RTMUnreadAnswer* unreadAnswer  = [RTMUnreadAnswer new];
//            unreadAnswer.unreadDictionary = [data objectForKey:@"p2p"];
//            successCallback(unreadAnswer);
//        }
//
//    }fail:^(FPNError * _Nullable error) {
//
//          _failCallback(error);
//
//    }];
//
//    handlerNetworkError;
//
//}
//
//-(RTMUnreadAnswer *)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
//                                             mtime:(int64_t)mtime
//                                      messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
//                                           timeout:(int)timeout{
//
//        RTMUnreadAnswer* model  = [RTMUnreadAnswer new];
//        clientConnectStatueVerifySync
//
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setValue:userIds forKey:@"uids"];
//        [dic setValue:@(mtime) forKey:@"mtime"];
//        [dic setValue:messageTypes forKey:@"mtypes"];
//
//        FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2punread" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
//        FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
//                                           timeout:RTMClientSendQuestTimeout];
//
//        if (answer.error == nil) {
//
//            model.unreadDictionary = [answer.responseData objectForKey:@"p2p"];
//
//        }else{
//            model.error = answer.error;
//        }
//
//        return model;
//
//}
-(void)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
                         mtime:(int64_t)mtime
                  messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                       timeout:(int)timeout
                       success:(void(^)(RTMUnreadAnswer * _Nullable unreadAnswer))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{


    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    [dic setValue:@(mtime) forKey:@"mtime"];
    [dic setValue:messageTypes forKey:@"mtypes"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2punread" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];

    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {


        if (successCallback) {
            RTMUnreadAnswer* unreadAnswer  = [RTMUnreadAnswer new];
            unreadAnswer.unreadDictionary = [data objectForKey:@"p2p"];
            unreadAnswer.lastMsgTimeDictionary = [data objectForKey:@"ltime"];
            successCallback(unreadAnswer);
        }

    }fail:^(FPNError * _Nullable error) {

          _failCallback(error);

    }];

    handlerNetworkError;

}

-(RTMUnreadAnswer *)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
                                             mtime:(int64_t)mtime
                                      messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                                           timeout:(int)timeout{

        RTMUnreadAnswer* model  = [RTMUnreadAnswer new];
        clientConnectStatueVerifySync

        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:userIds forKey:@"uids"];
        [dic setValue:@(mtime) forKey:@"mtime"];
        [dic setValue:messageTypes forKey:@"mtypes"];

        FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2punread" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
        FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                           timeout:RTMClientSendQuestTimeout];

        if (answer.error == nil) {

            model.unreadDictionary = [answer.responseData objectForKey:@"p2p"];
            model.lastMsgTimeDictionary = [answer.responseData objectForKey:@"ltime"];

        }else{
            model.error = answer.error;
        }

        return model;

}
-(void)getP2PHistoryMessageWithUserId:(NSNumber * _Nonnull)userId
                               desc:(BOOL)desc
                                num:(NSNumber * _Nonnull)num
                              begin:(NSNumber * _Nullable)begin
                                end:(NSNumber * _Nullable)end
                             lastid:(NSNumber * _Nullable)lastid
                             mtypes:(NSArray <NSNumber *> * _Nullable)mtypes
                            timeout:(int)timeout
                            success:(void(^)(RTMHistory* _Nullable history))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
//    messageTypeGetHistoryFilter
    clientConnectStatueVerify

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray toUserId:userId.longLongValue myUserId:self.userId];
            if (msgOb != nil) {
                [resultArray addObject:msgOb];
            }
            
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
    
//            NSLog(@"bbbbbb");
            _failCallback(error);

        }];
    
    handlerNetworkError;
    
}
-(RTMHistoryMessageAnswer*)getP2PHistoryMessageWithUserId:(NSNumber * _Nonnull)userId
                                        desc:(BOOL)desc
                                         num:(NSNumber * _Nonnull)num
                                       begin:(NSNumber * _Nullable)begin
                                         end:(NSNumber * _Nullable)end
                                      lastid:(NSNumber * _Nullable)lastid
                                      mtypes:(NSArray <NSNumber *> * _Nullable)mtypes
                                     timeout:(int)timeout{
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
//    messageTypeGetHistoryFilterSync
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray toUserId:userId.longLongValue myUserId:self.userId];
            if (msgOb != nil) {
                [resultArray addObject:msgOb];
            }
            
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

-(void)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                       fromUserId:(NSNumber * _Nonnull)fromUserId
                         toUserId:(NSNumber * _Nonnull)toUserId
                          timeout:(int)timeout
                          success:(void(^)(void))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
        
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:toUserId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
-(RTMBaseAnswer*)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                                 fromUserId:(NSNumber * _Nonnull)fromUserId
                                   toUserId:(NSNumber * _Nonnull)toUserId
                                    timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:toUserId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}


-(void)getP2pMessageWithId:(NSNumber * _Nonnull)messageId
                    fromUserId:(NSNumber * _Nonnull)fromUserId
                      toUserId:(NSNumber * _Nonnull)toUserId
                       timeout:(int)timeout
                       success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{

    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:toUserId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
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
    
//    if([[data objectForKey:@"mtype"] intValue] == 31){
//        //chat 语音
//        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
//        NSData * resultData = [RTMAudioTools audioDataRemoveHeader:[data objectForKey:@"msg"]];//去掉头的 音频数据
//        if (resultData != nil) {
//            [dic setValue:resultData forKey:@"msg"];
//            _successCallback(dic,tag);
//        }
//
//    }else{
//        _successCallback(data,tag);
//    }
    
}
-(RTMGetMessageAnswer*)getP2pMessageWithId:(NSNumber * _Nonnull)messageId
                                fromUserId:(NSNumber * _Nonnull)fromUserId
                                  toUserId:(NSNumber * _Nonnull)toUserId
                                   timeout:(int)timeout{
    
    RTMGetMessageAnswer * model = [RTMGetMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:toUserId forKey:@"xid"];
    [dic setValue:fromUserId forKey:@"from"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.getMessage = [RTMMessageModelConvert getMessageModelConvert:answer.responseData];
    }else{
        model.error = answer.error;
    }
    
    return model;
}




//-(void)stranscribeP2pWithId:(NSNumber * _Nonnull)messageId
//                 fromUserId:(NSNumber * _Nonnull)fromUserId
//                   toUserId:(NSNumber * _Nonnull)toUserId
//            profanityFilter:(BOOL)profanityFilter
//                    timeout:(int)timeout
//                    success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
//                       fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientConnectStatueVerify
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:messageId forKey:@"mid"];
//    [dic setValue:toUserId forKey:@"xid"];
//    [dic setValue:fromUserId forKey:@"from"];
//    [dic setValue:@(1) forKey:@"type"];
//    [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    
////    NSLog(@"%@",dic);
//    // type: 1,p2p; 2,group; 3, room
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
//    
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
////
////        NSLog(@"%@",data);
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
//-(RTMSpeechRecognitionAnswer*)stranscribeP2pWithId:(NSNumber * _Nonnull)messageId
//                                        fromUserId:(NSNumber * _Nonnull)fromUserId
//                                          toUserId:(NSNumber * _Nonnull)toUserId
//                                   profanityFilter:(BOOL)profanityFilter
//                                           timeout:(int)timeout{
//    
//    
//    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//    clientConnectStatueVerifySync
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:messageId forKey:@"mid"];
//    [dic setValue:toUserId forKey:@"xid"];
//    [dic setValue:fromUserId forKey:@"from"];
//    [dic setValue:@(1) forKey:@"type"];
//    [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    
//    // type: 1,p2p; 2,group; 3, room
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
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

