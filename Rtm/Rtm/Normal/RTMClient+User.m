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
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"bye" message:nil twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
//        @synchronized (self) {
////            NSLog(@"async offLineWithTimeoutoffLineWithTimeout");
//            [self setValue:@(YES) forKey:@"isOverlookFpnnCloseCallBack"];
//            [self setValue:@(NO) forKey:@"authFinish"];
//        }
//        if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
//            [self.delegate rtmConnectClose:self];
//        }
        [self closeConnect];
        if (successCallback) {
            successCallback();
        }
        
//        [self _sendByeCloseConnect];
        
        
        
    }fail:^(FPNError * _Nullable error) {
        
//        [self closeConnect];
                
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
}
-(RTMBaseAnswer*)offLineWithTimeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"bye" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    
    if (answer.error == nil) {
        [self closeConnect];
//        @synchronized (self) {
////            NSLog(@"sync offLineWithTimeoutoffLineWithTimeout");
//            [self setValue:@(YES) forKey:@"isOverlookFpnnCloseCallBack"];
//            [self setValue:@(NO) forKey:@"authFinish"];
//        }
//
//        if ([self.delegate respondsToSelector:@selector(rtmConnectClose:)]) {
//            [self.delegate rtmConnectClose:self];
//        }
        
    }else{
        
//        [self closeConnect];
        model.error = answer.error;
        
    }
    
    return model;
}
//-(void)_sendByeCloseConnect{
//    [self performSelector:@selector(_byeCloseConnect) withObject:@(NO)];
////    ((void* (*)(id, SEL))[self methodForSelector:NSSelectorFromString(@"_byeCloseConnect")])(self, NSSelectorFromString(@"_byeCloseConnect"));
//}







-(void)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                   timeout:(int)timeout
                   success:(void(^)(void))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:endPoint forKey:@"ce"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"kickout" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                         timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:endPoint forKey:@"ce"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"kickout" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}







-(void)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addattrs" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)addAttrsWithAttrs:(NSDictionary *)attrs
                           timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addattrs" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}







-(void)getAttrsWithTimeout:(int)timeout
                   success:(void(^)(RTMAttriAnswer * _Nullable attri))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getattrs" message:@{} twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMAttriAnswer * model = [RTMAttriAnswer new];
            model.atttriDictionary = data;
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMAttriAnswer*)getAttrsWithTimeout:(int)timeout{
    
    RTMAttriAnswer * model = [RTMAttriAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getattrs" message:@{} twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.atttriDictionary = answer.responseData;
    }else{
        
    }
    
    return model;

}



-(void)getUnreadMessagesWithClear:(BOOL)clear
                          timeout:(int)timeout
                          success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(clear) forKey:@"clear"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getunread" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
//        NSArray * p2pArray = [data objectForKey:@"p2p"];
//        NSArray * groupArray = [data objectForKey:@"group"];
        if (successCallback) {
            RTMP2pGroupMemberAnswer * model = [RTMP2pGroupMemberAnswer new];
            model.p2pArray = [data objectForKey:@"p2p"];
            model.groupArray = [data objectForKey:@"group"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMP2pGroupMemberAnswer*)getUnreadMessagesWithClear:(BOOL)clear
                                             timeout:(int)timeout{
    
    RTMP2pGroupMemberAnswer * model = [RTMP2pGroupMemberAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(clear) forKey:@"clear"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getunread" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.p2pArray = [answer.responseData objectForKey:@"p2p"];
        model.groupArray = [answer.responseData objectForKey:@"group"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)cleanUnreadMessagesWithTimeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"cleanunread" message:nil twoWay:YES];
    
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
-(RTMBaseAnswer*)cleanUnreadMessagesWithTimeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"cleanunread" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
}








-(void)getAllSessionsWithTimeout:(int)timeout
                         success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getsession" message:nil twoWay:YES];
    
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        
        if (successCallback) {
            
            RTMP2pGroupMemberAnswer * model = [RTMP2pGroupMemberAnswer new];
            model.p2pArray = [data objectForKey:@"p2p"];
            model.groupArray = [data objectForKey:@"group"];
            successCallback(model);
            
        }
        
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMP2pGroupMemberAnswer*)getAllSessionsWithTimeout:(int)timeout{
    
    RTMP2pGroupMemberAnswer * model = [RTMP2pGroupMemberAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getsession" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.p2pArray = [answer.responseData objectForKey:@"p2p"];
        model.groupArray = [answer.responseData objectForKey:@"group"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}









-(void)getOnlineUsers:(NSArray *)userIds
              timeout:(int)timeout
              success:(void(^)(NSArray * _Nullable uidArray))successCallback
                 fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getonlineusers" message:dic twoWay:YES];
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
-(RTMMemberAnswer*)getOnlineUsers:(NSArray *)userIds
                    timeout:(int)timeout{
    
    RTMMemberAnswer * model = [RTMMemberAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getonlineusers" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.dataArray = [answer.responseData objectForKey:@"uids"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                    privteinfo:(NSString * _Nullable)privteInfo
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privteInfo forKey:@"pinfo"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setuserinfo" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                          privteinfo:(NSString * _Nullable)privteInfo
                             timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:openInfo forKey:@"oinfo"];
    [dic setValue:privteInfo forKey:@"pinfo"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setuserinfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}





-(void)getUserInfoWithTimeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserinfo" message:nil twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
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
-(RTMInfoAnswer*)getUserInfoWithTimeout:(int)timeout{
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuserinfo" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.openInfo = [answer.responseData objectForKey:@"oinfo"];
        model.privateInfo = [answer.responseData objectForKey:@"pinfo"];
    }else{
        model.error = answer.error;
    }
    
    return model;
}





-(void)getUserOpenInfo:(NSArray * _Nullable)userIds
               timeout:(int)timeout
               success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
        
        clientConnectStatueVerify
       NSMutableDictionary * dic = [NSMutableDictionary dictionary];
       [dic setValue:userIds forKey:@"uids"];
       FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuseropeninfo" message:dic twoWay:YES];
       BOOL result = [fpnnMainClient sendQuest:quest
                                   timeout:RTMClientSendQuestTimeout
                                   success:^(NSDictionary * _Nullable data) {
           
           if (successCallback) {
               RTMAttriAnswer * model = [RTMAttriAnswer new];
               model.atttriDictionary = [data objectForKey:@"info"];
               successCallback(model);
           }
           
       
       }fail:^(FPNError * _Nullable error) {
           
             _failCallback(error);

       }];
           
       handlerNetworkError;
    
}
-(RTMAttriAnswer*)getUserOpenInfo:(NSArray * _Nullable)userIds
                     timeout:(int)timeout{
    
    RTMAttriAnswer * model = [RTMAttriAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userIds forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getuseropeninfo" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.atttriDictionary = [answer.responseData objectForKey:@"info"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)getUserValueInfoWithKey:(NSString * _Nullable)key
                       timeout:(int)timeout
                       success:(void(^)(RTMInfoAnswer * _Nullable valueInfo))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataget" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMInfoAnswer * model = [RTMInfoAnswer new];
            model.valueInfo = [data objectForKey:@"val"];
            successCallback(model);
        }
        
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMInfoAnswer*)getUserValueInfoWithKey:(NSString * _Nullable)key
                                 timeout:(int)timeout{
    
    RTMInfoAnswer * model = [RTMInfoAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataget" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.valueInfo = [answer.responseData objectForKey:@"val"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)setUserValueInfoWithKey:(NSString * _Nonnull)key
                         value:(NSString * _Nonnull)value
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    [dic setValue:value forKey:@"val"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataset" message:dic twoWay:YES];
    
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
-(RTMBaseAnswer*)setUserValueInfoWithKey:(NSString * _Nonnull)key
                                   value:(NSString * _Nonnull)value
                                 timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    [dic setValue:value forKey:@"val"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"dataset" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)deleteUserDataWithKey:(NSString * _Nonnull)key
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"datadel" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)deleteUserDataWithKey:(NSString * _Nonnull)key
                           timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:key forKey:@"key"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"datadel" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}

@end

    

    
    
    
