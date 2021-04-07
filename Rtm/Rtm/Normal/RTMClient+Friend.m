//
//  RTMClient+Friend.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Friend.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"



@implementation RTMClient (Friend)
-(void)addFriendWithId:(NSArray*)friendids
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addfriends" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
-(RTMBaseAnswer*)addFriendWithId:(NSArray*)friendids
                         timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addfriends" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
       
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}
//
//
//
-(void)deleteFriendWithId:(NSArray*)friendids
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delfriends" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
-(RTMBaseAnswer*)deleteFriendWithId:(NSArray*)friendids
                        timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delfriends" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
       
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}
//
//
//
-(void)getUserFriendsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getfriends" message:nil twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
                          
-(RTMMemberAnswer*)getUserFriendsWithTimeout:(int)timeout{
    
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getfriends" message:nil twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.dataArray = [answer.responseData objectForKey:@"uids"];
    }else{
        model.error = answer.error;
    }
    
    return model;
}
//

-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addblacks" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
-(RTMBaseAnswer*)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                             timeout:(int)timeout{
    
        RTMBaseAnswer * model = [RTMBaseAnswer new];
       clientConnectStatueVerifySync
       NSMutableDictionary * dic = [NSMutableDictionary dictionary];
       [dic setValue:friendids forKey:@"blacks"];
       FPNNQuest * quest = [FPNNQuest questWithMethod:@"addblacks" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
       FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                           timeout:RTMClientSendQuestTimeout];
       
       if (answer.error == nil) {
          
       }else{
           model.error = answer.error;
       }
       
       return model;
    
}
//   
//
//
-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                          timeout:(int)timeout
                          success:(void(^)(void))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delblacks" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    
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
-(RTMBaseAnswer*)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delblacks" message:dic twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
       
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}
//
//
//
-(void)getBlacklistWithTimeout:(int)timeout
                       success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getblacks" message:nil twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
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
-(RTMMemberAnswer*)getBlacklistWithTimeout:(int)timeout{
    
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getblacks" message:nil twoWay:YES pid:[NSString stringWithFormat:@"%lld",self.projectId]];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.dataArray = [answer.responseData objectForKey:@"uids"];
    }else{
        model.error = answer.error;
    }
    
    return model;
       
    
}
@end
