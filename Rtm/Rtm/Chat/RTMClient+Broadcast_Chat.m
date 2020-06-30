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
@implementation RTMClient (Broadcast_Chat)
-(void)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                 timeout:(int)timeout
                                     tag:(id)tag
                                 success:(RTMAnswerSuccessCallBack)successCallback
                                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)
                                success:^(NSDictionary * _Nullable data) {

        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
            int mType = [[itemArray objectAtIndex:2] intValue];
            if (mType == 31) {//音频的要去头再返回
                NSData * msg = [itemArray objectAtIndex:5];
                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
            }
        }];
        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
        [newData setValue:msgArray forKey:@"msgs"];
        _successCallback(newData,tag);
        
    }
                                   fail:^(FPNError * _Nullable error) {
        _failCallback(error,tag);
        
    }];
    
    handlerResultFail;
    
}
-(RTMAnswer*)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                          desc:(BOOL)desc
                                         begin:(NSNumber * _Nullable)begin
                                           end:(NSNumber * _Nullable)end
                                        lastid:(NSNumber * _Nullable)lastid
                                           timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
    RTMAnswer * answer = (RTMAnswer*)[mainClient sendQuest:quest timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)];
    if (answer.error == nil && answer.responseData != nil) {
        
        NSDictionary * data = answer.responseData;
        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
            int mType = [[itemArray objectAtIndex:2] intValue];
            if (mType == 31) {//音频的要去头再返回
                NSData * msg = [itemArray objectAtIndex:5];
                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
            }
        }];
        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
        [newData setValue:msgArray forKey:@"msgs"];
        answer.responseData = newData;
    }
    return  answer;
    
    
}
@end
