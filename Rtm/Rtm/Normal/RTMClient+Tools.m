//
//  RTMClient+Administrator.m
//  Rtm
//
//  Created by zsl on 2019/12/12.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Tools.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAudioTools.h"

@implementation RTMClient (Tools)
-(void)setLanguage:(NSString * _Nonnull)language
            timeout:(int)timeout
               tag:(id)tag
            success:(RTMAnswerSuccessCallBack)successCallback
              fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:language forKey:@"lang"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setlang" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)setLanguage:(NSString * _Nonnull)language
                 timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:language forKey:@"lang"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setlang" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);

}


-(void)translateText:(NSString * _Nonnull)translateText
    originalLanguage:(NSString * _Nullable)originalLanguage
      targetLanguage:(NSString * _Nonnull)targetLanguage
                type:(NSString * _Nullable)type
           profanity:(NSString * _Nullable)profanity
             timeout:(int)timeout
                 tag:(id)tag
             success:(RTMAnswerSuccessCallBack)successCallback
                fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:translateText forKey:@"text"];
    [dic setValue:originalLanguage forKey:@"src"];
    [dic setValue:targetLanguage forKey:@"dst"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:profanity forKey:@"profanity"];
    //[dic setValue:@(postProfanity) forKey:@"postProfanity"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"translate" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)translateText:(NSString * _Nonnull)translateText
          originalLanguage:(NSString * _Nullable)originalLanguage
            targetLanguage:(NSString * _Nonnull)targetLanguage
                      type:(NSString * _Nullable)type
                 profanity:(NSString * _Nullable)profanity
                   timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:translateText forKey:@"text"];
    [dic setValue:originalLanguage forKey:@"src"];
    [dic setValue:targetLanguage forKey:@"dst"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:profanity forKey:@"profanity"];
    //[dic setValue:@(postProfanity) forKey:@"postProfanity"];
    

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"translate" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}


-(void)textProfanity:(NSString * _Nonnull)profanityText
            classify:(BOOL)classify
             timeout:(int)timeout
                 tag:(id _Nullable)tag
             success:(RTMAnswerSuccessCallBack)successCallback
                fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:profanityText forKey:@"text"];
    [dic setValue:@(classify) forKey:@"classify"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"profanity" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)textProfanity:(NSString * _Nonnull)profanityText
                  classify:(BOOL)classify
                   timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:profanityText forKey:@"text"];
    [dic setValue:@(classify) forKey:@"classify"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"profanity" message:dic twoWay:YES];
    return handlerResult(quest,timeout);
}



-(void)speechRecognition:(NSData * _Nonnull)audioSource
                    lang:(NSString*)lang
                duration:(long long)duration
         profanityFilter:(BOOL)profanityFilter
                 timeout:(int)timeout
                     tag:(id _Nullable)tag
                 success:(RTMAnswerSuccessCallBack)successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    if (audioSource == nil) {
        FPNSLog(@"rtm speechRecognition audioSource is nil");
        return;
    }
    if (duration == 0){
        FPNSLog(@"rtm speechRecognition duration is nil");
        return;
    }
    //2950
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioSource
                                                       lang:lang
                                                       time:duration
                                                      srate:16000];
    
    if (resultData) {
        [dic setValue:resultData forKey:@"audio"];
        [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
    }else{
        FPNSLog(@"rtm speechRecognition audioDataAddHeader is error");
        return ;
    }
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"transcribe" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)speechRecognition:(NSData * _Nonnull)audioSource
                          lang:(NSString*)lang
                      duration:(long long)duration
               profanityFilter:(BOOL)profanityFilter
                       timeout:(int)timeout
                           tag:(id _Nullable)tag{
    
    
    clientStatueVerify
    
    if (audioSource == nil) {
        FPNSLog(@"rtm speechRecognition audioSource is nil");
        return nil;
    }
    if (duration == 0){
        FPNSLog(@"rtm speechRecognition duration is nil");
        return nil;
    }
    
    //2950
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioSource
                                                       lang:lang
                                                       time:duration
                                                      srate:16000];
    
    if (resultData) {
        [dic setValue:resultData forKey:@"audio"];
        [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
    }else{
        FPNSLog(@"rtm speechRecognition audioDataAddHeader is error");
        return nil;
    }
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"transcribe" message:dic twoWay:YES];
    return handlerResult(quest,timeout);
    
}



-(void)addDebugLogWithMsg:(NSString * _Nonnull)msg
             attrs:(NSString * _Nonnull)attrs
                 timeout:(int)timeout
                      tag:(id)tag
              success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddebuglog" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)addDebugLogWithMsg:(NSString * _Nonnull)msg
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddebuglog" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)addDeviceWithApptype:(NSString * _Nonnull)apptype
             deviceToken:(NSString * _Nonnull)deviceToken
                 timeout:(int)timeout
                        tag:(id)tag
              success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:apptype forKey:@"apptype"];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddevice" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)addDeviceWithApptype:(NSString * _Nonnull)apptype
                      deviceToken:(NSString * _Nonnull)deviceToken
                        timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:apptype forKey:@"apptype"];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddevice" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                 timeout:(int)timeout
                         tag:(id)tag
              success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removedevice" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                           timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removedevice" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)setGeoWithLatitude:(double)latitude
                longitude:(double)longitude
                      uid:(NSNumber * _Nonnull)uid
                  timeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:[NSNumber numberWithDouble:latitude] forKey:@"lat"];
    [dic setValue:[NSNumber numberWithDouble:longitude] forKey:@"lng"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgeo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)setGeoWithLatitude:(double)latitude
                      longitude:(double)longitude
                            uid:(NSNumber * _Nonnull)uid
                        timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:[NSNumber numberWithDouble:latitude] forKey:@"lat"];
    [dic setValue:[NSNumber numberWithDouble:longitude] forKey:@"lng"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgeo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}



-(void)getGeoWithUid:(NSNumber * _Nonnull)uid
             timeout:(int)timeout
                 tag:(id)tag
             success:(RTMAnswerSuccessCallBack)successCallback
                fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uid forKey:@"uid"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeo" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)getGeoWithUid:(NSNumber * _Nonnull)uid
                   timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uid forKey:@"uid"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeo" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)getGeosWithUids:(NSArray <NSNumber*> *)uids
              timeout:(int)timeout
                  tag:(id)tag
              success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uids forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeos" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getGeosWithUid:(NSArray<NSNumber*>*)uids
                    timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.pid) forKey:@"pid"];
    [dic setValue:uids forKey:@"uids"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeos" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}
@end
