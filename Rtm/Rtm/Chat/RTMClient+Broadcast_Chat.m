//
//  RTMClient+Broadcast_Chat.m
//  Rtm
//
//  Created by zsl on 2019/12/24.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Broadcast_Chat.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAnswer.h"
#import "RTMAudioTools.h"
#import "RTMMessageModelConvert.h"
@implementation RTMClient (Broadcast_Chat)
-(void)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                 timeout:(int)timeout
                                     success:(void(^)(RTMHistory* _Nullable history))successCallback
                                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(32),@(40),@(41),@(42),@(50)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)
//                                success:^(NSDictionary * _Nullable data) {
//
//        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
//        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
//            int mType = [[itemArray objectAtIndex:2] intValue];
//            if (mType == 31) {//音频的要去头再返回
//                NSData * msg = [itemArray objectAtIndex:5];
//                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
//                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
//                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
//                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
//            }
//        }];
//        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
//        [newData setValue:msgArray forKey:@"msgs"];
//        _successCallback(newData,tag);
//
//    }
//                                   fail:^(FPNError * _Nullable error) {
//        _failCallback(error,tag);
//
//    }];
//
//    handlerResultFail;
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert broadcastHistoryMessageModelConvert:itemArray];
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
-(RTMHistoryMessageAnswer*)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                                            desc:(BOOL)desc
                                                           begin:(NSNumber * _Nullable)begin
                                                             end:(NSNumber * _Nullable)end
                                                          lastid:(NSNumber * _Nullable)lastid
                                                         timeout:(int)timeout{
    
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(32),@(40),@(41),@(42),@(50)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
//
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert broadcastHistoryMessageModelConvert:itemArray];
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

@end
