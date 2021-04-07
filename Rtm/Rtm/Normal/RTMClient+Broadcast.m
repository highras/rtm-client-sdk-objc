//
//  RTMClient+Broadcast.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Broadcast.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAudioTools.h"
#import "RTMMessageModelConvert.h"

@implementation RTMClient (Broadcast)
-(void)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                           desc:(BOOL)desc
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
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {

            RTMHistoryMessage * msgOb = [RTMMessageModelConvert broadcastHistoryMessageModelConvert:itemArray];
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
    
            _failCallback(error);

        }];
    
    handlerNetworkError;
    
}
-(RTMHistoryMessageAnswer*)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                                        desc:(BOOL)desc
                                                       begin:(NSNumber * _Nullable)begin
                                                         end:(NSNumber * _Nullable)end
                                                      lastid:(NSNumber * _Nullable)lastid
                                                      mtypes:(NSArray <NSNumber* > * _Nullable)mtypes    
                                                     timeout:(int)timeout{
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
//    messageTypeGetHistoryFilterSync
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert broadcastHistoryMessageModelConvert:itemArray];
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








-(void)getBroadCastMessageWithId:(NSNumber * _Nonnull)messageId
                         timeout:(int)timeout
                         success:(void(^)(RTMGetMessage * _Nullable  message))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{

    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:@(4) forKey:@"type"];
    [dic setValue:@(0) forKey:@"xid"];
    [dic setValue:@(0) forKey:@"from"];
    // type: 1,p2p; 2,group; 3, room
        
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
        
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
-(RTMGetMessageAnswer*)getBroadCastHistoryMessageWithId:(NSNumber * _Nonnull)messageId
                                                timeout:(int)timeout{
    
    RTMGetMessageAnswer * model = [RTMGetMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:@(4) forKey:@"type"];
    [dic setValue:@(0) forKey:@"xid"];
    [dic setValue:@(0) forKey:@"from"];
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


//-(void)stranscribeBroadcastWithId:(NSNumber * _Nonnull)messageId
//                       fromUserId:(NSNumber * _Nonnull)fromUserId
//                  profanityFilter:(BOOL)profanityFilter
//                          timeout:(int)timeout
//                          success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
//                             fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientConnectStatueVerify
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:messageId forKey:@"mid"];
//    [dic setValue:@(0) forKey:@"xid"];
//    [dic setValue:fromUserId forKey:@"from"];
//    [dic setValue:@(4) forKey:@"type"];
//    [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    
//    // type: 1,p2p; 2,group; 3, room
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"stranscribe" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
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
//-(RTMSpeechRecognitionAnswer*)stranscribeBroadcastWithId:(NSNumber * _Nonnull)messageId
//                                              fromUserId:(NSNumber * _Nonnull)fromUserId
//                                         profanityFilter:(BOOL)profanityFilter
//                                                 timeout:(int)timeout{
//    
//    
//    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//    clientConnectStatueVerifySync
//    
//     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//     [dic setValue:messageId forKey:@"mid"];
//     [dic setValue:@(0) forKey:@"xid"];
//     [dic setValue:fromUserId forKey:@"from"];
//     [dic setValue:@(4) forKey:@"type"];
//     [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
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
