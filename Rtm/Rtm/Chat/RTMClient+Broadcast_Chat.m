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
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
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
    return  handlerResult(quest,timeout);
    
    
}
@end
