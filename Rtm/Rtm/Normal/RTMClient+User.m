//
//  RTMClient+User.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+User.h"
#import <objc/runtime.h>
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
static NSString *nameKey = @"nameKey";
static NSString *name2Key = @"nameKey2";
@interface RTMClient ()
@property(nonatomic,copy)NSString * name2;

@end


@implementation RTMClient (User)

//-(NSString*)name{
//    return objc_getAssociatedObject(self, &nameKey);
//}
//-(void)setName:(NSString *)name{
//    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
//}
//
//-(NSString*)name2{
//    return objc_getAssociatedObject(self, &name2Key);
//}
//-(void)setName2:(NSString *)name2{
//    objc_setAssociatedObject(self, &name2Key, name2, OBJC_ASSOCIATION_COPY);
//}
-(void)offLineWithTimeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"bye" message:nil twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)offLineWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"bye" message:nil twoWay:YES];
    return  handlerResult(quest,timeout);
}



-(void)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                   timeout:(int)timeout
                       tag:(id)tag
                   success:(RTMAnswerSuccessCallBack)successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:endPoint forKey:@"ce"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"kickout" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                         timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:endPoint forKey:@"ce"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"kickout" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}



-(void)addAttrsWithAttrs:(NSDictionary *)attrs
                 timeout:(int)timeout
                     tag:(id)tag
                 success:(RTMAnswerSuccessCallBack)successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addattrs" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)addAttrsWithAttrs:(NSDictionary *)attrs
                       timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:attrs forKey:@"attrs"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addattrs" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)getAttrsWithTimeout:(int)timeout
                       tag:(id)tag
                   success:(RTMAnswerSuccessCallBack)successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getattrs" message:@{} twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getAttrsWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getattrs" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
}



-(void)getUnreadMessagesWithClear:(BOOL)clear
                          timeout:(int)timeout
                              tag:(id)tag
                          success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(clear) forKey:@"clear"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getunread" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getUnreadMessagesWithClear:(BOOL)clear
                                timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(clear) forKey:@"clear"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getunread" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
    
}



-(void)cleanUnreadMessagesWithTimeout:(int)timeout
                                  tag:(id)tag
                              success:(RTMAnswerSuccessCallBack)successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"cleanunread" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)cleanUnreadMessagesWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"cleanunread" message:nil twoWay:YES];
    return  handlerResult(quest,timeout);
}





-(void)getAllSessionsWithTimeout:(int)timeout
                             tag:(id)tag
                         success:(RTMAnswerSuccessCallBack)successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getsession" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getAllSessionsWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getsession" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




-(void)getOnlineUsers:(NSArray *)userIds
              timeout:(int)timeout
                  tag:(id)tag
              success:(RTMAnswerSuccessCallBack)successCallback
                 fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getonlineusers" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getOnlineUsers:(NSArray *)userIds
                    timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getonlineusers" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




-(void)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                    privteinfo:(NSString * _Nullable)privteInfo
                       timeout:(int)timeout
                           tag:(id)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privteInfo forKey:@"pinfo"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setuserinfo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                          privteinfo:(NSString * _Nullable)privteInfo
                             timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privteInfo forKey:@"pinfo"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setuserinfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}




-(void)getUserInfoWithTimeout:(int)timeout
                          tag:(id)tag
                      success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserinfo" message:nil twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)getUserInfoWithTimeout:(int)timeout{
    
    clientStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserinfo" message:nil twoWay:YES];
    
    return  handlerResult(quest,timeout);
}




-(void)getUserOpenInfo:(NSArray * _Nullable)userIds
               timeout:(int)timeout
                   tag:(id)tag
               success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
        clientCallStatueVerify
       NSMutableDictionary * dic = [NSMutableDictionary dictionary];
       [dic setValue:userIds forKey:@"uids"];
       FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuseropeninfo" message:dic twoWay:YES];
       
       BOOL result = handlerCallResult(quest,timeout,tag);
       handlerResultFail;
       //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getUserOpenInfo:(NSArray * _Nullable)userIds
                     timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuseropeninfo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)getUserDataWithKey:(NSString * _Nullable)key
                  timeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataget" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getUserDataWithKey:(NSString * _Nullable)key
                        timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataget" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)setUserDataWithKey:(NSString * _Nonnull)key
                    value:(NSString * _Nonnull)value
                  timeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    [dic setValue:value forKey:@"val"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataset" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)setUserDataWithKey:(NSString * _Nonnull)key
                          value:(NSString * _Nonnull)value
                        timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    [dic setValue:value forKey:@"val"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataset" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}



-(void)deleteUserDataWithKey:(NSString * _Nonnull)key
                     timeout:(int)timeout
                         tag:(id)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"datadel" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)deleteUserDataWithKey:(NSString * _Nonnull)key
                           timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"datadel" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}

@end

    

    
    
    
