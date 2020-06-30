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
                   tag:(id)tag
               success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addfriends" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)addFriendWithId:(NSArray*)friendids
                     timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addfriends" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)deleteFriendWithId:(NSArray*)friendids
                  timeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delfriends" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)deleteFriendWithId:(NSArray*)friendids
                        timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"friends"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delfriends" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)getUserFriendsWithTimeout:(int)timeout
                             tag:(id)tag
                         success:(RTMAnswerSuccessCallBack)successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getfriends" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
                          
-(RTMAnswer*)getUserFriendsWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getfriends" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
}

-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                           tag:(id _Nullable)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addblacks" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    
}
-(RTMAnswer*)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                             timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addblacks" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}
   

-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                           tag:(id _Nullable)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delblacks" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    
}
-(RTMAnswer*)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:friendids forKey:@"blacks"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delblacks" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}

-(void)getBlacklistWithTimeout:(int)timeout
                           tag:(id _Nullable)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getblacks" message:nil twoWay:YES];

    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    
}
-(RTMAnswer*)getBlacklistWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getblacks" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
       
    
}

@end

