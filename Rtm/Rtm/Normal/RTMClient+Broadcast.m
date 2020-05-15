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

@implementation RTMClient (Broadcast)
-(void)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
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
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                          desc:(BOOL)desc
                                         begin:(NSNumber * _Nullable)begin
                                           end:(NSNumber * _Nullable)end
                                        lastid:(NSNumber * _Nullable)lastid
                                        mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                       timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getbroadcastmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}
@end
