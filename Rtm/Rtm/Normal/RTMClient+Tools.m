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
           success:(void(^)(void))successCallback
              fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:language forKey:@"lang"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setlang" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)setLanguage:(NSString * _Nonnull)language
                 timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:language forKey:@"lang"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setlang" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;

}




-(void)translateText:(NSString * _Nonnull)translateText
    originalLanguage:(NSString * _Nullable)originalLanguage
      targetLanguage:(NSString * _Nonnull)targetLanguage
                type:(NSString * _Nullable)type
           profanity:(NSString * _Nullable)profanity
             timeout:(int)timeout
             success:(void(^)(RTMTranslatedInfo * _Nullable translatedInfo))successCallback
                fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:translateText forKey:@"text"];
    [dic setValue:originalLanguage forKey:@"src"];
    [dic setValue:targetLanguage forKey:@"dst"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:profanity forKey:@"profanity"];
    //[dic setValue:@(postProfanity) forKey:@"postProfanity"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"translate" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientTranslateQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        RTMTranslatedInfo * model = [RTMTranslatedInfo new];
        model.source = [data objectForKey:@"source"];
        model.sourceText = [data objectForKey:@"sourceText"];
        model.target = [data objectForKey:@"target"];
        model.targetText = [data objectForKey:@"targetText"];
        if (successCallback) {
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
}
-(RTMTranslatedInfoAnswer*)translateText:(NSString * _Nonnull)translateText
                        originalLanguage:(NSString * _Nullable)originalLanguage
                          targetLanguage:(NSString * _Nonnull)targetLanguage
                                    type:(NSString * _Nullable)type
                               profanity:(NSString * _Nullable)profanity
                                 timeout:(int)timeout{
    
    
    RTMTranslatedInfoAnswer * model = [RTMTranslatedInfoAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:translateText forKey:@"text"];
    [dic setValue:originalLanguage forKey:@"src"];
    [dic setValue:targetLanguage forKey:@"dst"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:profanity forKey:@"profanity"];
    //[dic setValue:@(postProfanity) forKey:@"postProfanity"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"translate" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientTranslateQuestTimeout];
    
    if (answer.error == nil) {
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.source = [answer.responseData objectForKey:@"source"];
        translatedInfo.sourceText = [answer.responseData objectForKey:@"sourceText"];
        translatedInfo.target = [answer.responseData objectForKey:@"target"];
        translatedInfo.targetText = [answer.responseData objectForKey:@"targetText"];
        
        model.translatedInfo = translatedInfo;
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



//-(void)textProfanity:(NSString * _Nonnull)profanityText
//            classify:(BOOL)classify
//             timeout:(int)timeout
//             success:(void(^)(RTMTextProfanityAnswer * _Nullable textProfanity))successCallback
//                fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientConnectStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:profanityText forKey:@"text"];
//    [dic setValue:@(classify) forKey:@"classify"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"profanity" message:dic twoWay:YES];
//    
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
////        NSLog(@"%@",data);
//        
//        RTMTextProfanityAnswer * model = [RTMTextProfanityAnswer new];
//        model.text = [data objectForKey:@"text"];
//        model.classification = [data objectForKey:@"classification"];
//        
//        if (successCallback) {
//            successCallback(model);
//        }
//    
//    }fail:^(FPNError * _Nullable error) {
//        
//          _failCallback(error);
//
//    }];
//        
//    handlerNetworkError;
//}
//-(RTMTextProfanityAnswer*)textProfanity:(NSString * _Nonnull)profanityText
//                               classify:(BOOL)classify
//                                timeout:(int)timeout{
//    
//    RTMTextProfanityAnswer * model = [RTMTextProfanityAnswer new];
//    clientConnectStatueVerifySync
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:profanityText forKey:@"text"];
//    [dic setValue:@(classify) forKey:@"classify"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"profanity" message:dic twoWay:YES];
//    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
//                                        timeout:RTMClientSendQuestTimeout];
//    
//    if (answer.error == nil) {
//        model.text = [answer.responseData objectForKey:@"text"];
//        model.classification = [answer.responseData objectForKey:@"classification"];
//    }else{
//        model.error = answer.error;
//    }
//    
//    return model;
//}




//-(void)speechRecognition:(NSString * _Nonnull)audioFilePath
//                    lang:(NSString*)lang
//                duration:(long long)duration
//         profanityFilter:(BOOL)profanityFilter
//                 timeout:(int)timeout
//                 success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable textProfanity))successCallback
//                    fail:(RTMAnswerFailCallBack)failCallback{
//
//
//    clientConnectStatueVerify
//
//
//    if (duration == 0 || audioFilePath == nil) {
//        FPNSLog(@"rtm speechRecognition duration or audioFile is nil");
//        return ;
//    }
//
//
//    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
//    if (audioData == nil) {
//        FPNSLog(@"rtm speechRecognitione get audioData error");
//        return ;
//    }
//
//
//    //2950
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData
//                                                       lang:lang
//                                                       time:duration
//                                                      srate:16000];
//
//    if (resultData) {
//        [dic setValue:resultData forKey:@"audio"];
//        [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    }else{
//        FPNSLog(@"rtm speechRecognition audioDataAddHeader is error");
//        return ;
//    }
//
//
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"transcribe" message:dic twoWay:YES];
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientTranslateQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//
//        if (successCallback) {
//            RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//            model.lang = [data objectForKey:@"lang"];
//            model.text = [data objectForKey:@"text"];
//            successCallback(model);
//        }
//
//    }fail:^(FPNError * _Nullable error) {
//
//          _failCallback(error);
//
//    }];
//
//    handlerNetworkError;
//}
//-(RTMSpeechRecognitionAnswer*)speechRecognition:(NSData * _Nonnull)audioSource
//                                           lang:(NSString * _Nullable)lang
//                                       duration:(long long)duration
//                                profanityFilter:(BOOL)profanityFilter
//                                        timeout:(int)timeout{
//
//
//    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
//    clientConnectStatueVerifySync
//    if (audioSource == nil) {
//        FPNSLog(@"rtm speechRecognition audioSource is nil");
////        return;
//    }
//    if (duration == 0){
//        FPNSLog(@"rtm speechRecognition duration is nil");
////        return;
//    }
//    //2950
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioSource
//                                                       lang:lang
//                                                       time:duration
//                                                      srate:16000];
//
//    if (resultData) {
//        [dic setValue:resultData forKey:@"audio"];
//        [dic setValue:@(profanityFilter) forKey:@"profanityFilter"];
//    }else{
//        FPNSLog(@"rtm speechRecognition audioDataAddHeader is error");
////        return ;
//    }
//
//
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"transcribe" message:dic twoWay:YES];
//    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
//                                        timeout:RTMClientTranslateQuestTimeout];
//
//    if (answer.error == nil) {
//
//        model.lang = [answer.responseData objectForKey:@"lang"];
//        model.text = [answer.responseData objectForKey:@"text"];
//
//    }else{
//        model.error = answer.error;
//    }
//
//    return model;
//
//
//}



-(void)addDebugLogWithMsg:(NSString * _Nonnull)msg
                    attrs:(NSString * _Nonnull)attrs
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddebuglog" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)addDebugLogWithMsg:(NSString * _Nonnull)msg
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddebuglog" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)addDeviceWithAppType:(NSString * _Nonnull)appType
                deviceToken:(NSString * _Nonnull)deviceToken
                    timeout:(int)timeout
                    success:(void(^)(void))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:appType forKey:@"apptype"];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddevice" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)addDeviceWithAppType:(NSString * _Nonnull)appType
                      deviceToken:(NSString * _Nonnull)deviceToken
                        timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:appType forKey:@"apptype"];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"adddevice" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removedevice" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                           timeout:(int)timeout{
    
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:deviceToken forKey:@"devicetoken"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removedevice" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)addDevicePushOptionWithType:(int)type
                               xid:(int64_t)xid
                            mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                           timeout:(int)timeout
                           success:(void(^)(void))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(type) forKey:@"type"];
    [dic setValue:@(xid) forKey:@"xid"];
    [dic setValue:mTypes forKey:@"mtypes"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addoption" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)addDevicePushOptionWithType:(int)type
                                         xid:(int64_t)xid
                                      mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                                     timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(type) forKey:@"type"];
    [dic setValue:@(xid) forKey:@"xid"];
    [dic setValue:mTypes forKey:@"mtypes"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"addoption" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)removeDevicePushOptionWithType:(int)type
                                  xid:(int64_t)xid
                               mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                              timeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(type) forKey:@"type"];
    [dic setValue:@(xid) forKey:@"xid"];
    [dic setValue:mTypes forKey:@"mtypes"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removeoption" message:dic twoWay:YES];
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
-(RTMBaseAnswer*)removeDevicePushOptionWithType:(int)type
                                            xid:(int64_t)xid
                                         mTypes:(NSArray<NSNumber*>* _Nonnull)mTypes
                                        timeout:(int)timeout{
    
    RTMBaseAnswer * model = [RTMBaseAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(type) forKey:@"type"];
    [dic setValue:@(xid) forKey:@"xid"];
    [dic setValue:mTypes forKey:@"mtypes"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"removeoption" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}


-(void)getDevicePushOptionWithTimeout:(int)timeout
                              success:(void(^)(RTMGetPushAttrsAnswer *answer))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getoption" message:nil twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                    timeout:RTMClientSendQuestTimeout
                                    success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMGetPushAttrsAnswer * model = [RTMGetPushAttrsAnswer new];
            model.p2p = [data objectForKey:@"p2p"];
            model.group = [data objectForKey:@"group"];
            successCallback(model);
        }
        
       
    }fail:^(FPNError * _Nullable error) {
           
        _failCallback(error);

    }];
           
    handlerNetworkError;
    
    
}
-(RTMGetPushAttrsAnswer*)getDevicePushOptionWithTimeout:(int)timeout{
    
    RTMGetPushAttrsAnswer * model = [RTMGetPushAttrsAnswer new];
    clientConnectStatueVerifySync
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getoption" message:nil twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                            timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.p2p = [answer.responseData objectForKey:@"p2p"];
        model.group = [answer.responseData objectForKey:@"group"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}
//
//
//-(void)setGeoWithLatitude:(double)latitude
//                longitude:(double)longitude
//                      uid:(NSNumber * _Nonnull)uid
//                  timeout:(int)timeout
//                      tag:(id)tag
//                  success:(RTMAnswerSuccessCallBack)successCallback
//                     fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientCallStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uid forKey:@"uid"];
//    [dic setValue:[NSNumber numberWithDouble:latitude] forKey:@"lat"];
//    [dic setValue:[NSNumber numberWithDouble:longitude] forKey:@"lng"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgeo" message:dic twoWay:YES];
//    
//    BOOL result = handlerCallResult(quest,timeout,tag);
//    handlerResultFail;
//    //return  handlerCallResult(quest,timeout,tag);
//    
//}
//-(RTMAnswer*)setGeoWithLatitude:(double)latitude
//                      longitude:(double)longitude
//                            uid:(NSNumber * _Nonnull)uid
//                        timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uid forKey:@"uid"];
//    [dic setValue:[NSNumber numberWithDouble:latitude] forKey:@"lat"];
//    [dic setValue:[NSNumber numberWithDouble:longitude] forKey:@"lng"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"setgeo" message:dic twoWay:YES];
//    
//    return  handlerResult(quest,timeout);
//}
//
//
//
//-(void)getGeoWithUid:(NSNumber * _Nonnull)uid
//             timeout:(int)timeout
//                 tag:(id)tag
//             success:(RTMAnswerSuccessCallBack)successCallback
//                fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientCallStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uid forKey:@"uid"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeo" message:dic twoWay:YES];
//    
//    BOOL result = handlerCallResult(quest,timeout,tag);
//    handlerResultFail;
//    //return  handlerCallResult(quest,timeout,tag);
//}
//-(RTMAnswer*)getGeoWithUid:(NSNumber * _Nonnull)uid
//                   timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uid forKey:@"uid"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeo" message:dic twoWay:YES];
//    
//    return  handlerResult(quest,timeout);
//    
//}
//
//
//
//-(void)getGeosWithUids:(NSArray <NSNumber*> *)uids
//              timeout:(int)timeout
//                  tag:(id)tag
//              success:(RTMAnswerSuccessCallBack)successCallback
//                  fail:(RTMAnswerFailCallBack)failCallback{
//    
//    clientCallStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uids forKey:@"uids"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeos" message:dic twoWay:YES];
//    
//    BOOL result = handlerCallResult(quest,timeout,tag);
//    handlerResultFail;
//    //return  handlerCallResult(quest,timeout,tag);
//    
//}
//-(RTMAnswer*)getGeosWithUid:(NSArray<NSNumber*>*)uids
//                    timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@(self.pid) forKey:@"pid"];
//    [dic setValue:uids forKey:@"uids"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getgeos" message:dic twoWay:YES];
//    
//    return  handlerResult(quest,timeout);
//    
//}
-(void)textReviewWithText:(NSString * _Nonnull)text
                  timeout:(int)timeout
                  success:(void(^)(RTMTextReviewAnswer * _Nullable textReview))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:text forKey:@"text"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"tcheck" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMTextReviewAnswer * model = [RTMTextReviewAnswer new];
            model.result = [[data objectForKey:@"result"] intValue];
            model.text = [data objectForKey:@"text"];
            model.tags = [data objectForKey:@"tags"];
            model.wlist = [data objectForKey:@"wlist"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMTextReviewAnswer*)textReviewWithText:(NSString * _Nonnull)text
                                  timeout:(int)timeout{
    
    RTMTextReviewAnswer * model = [RTMTextReviewAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:text forKey:@"text"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"tcheck" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.result = [[answer.responseData objectForKey:@"result"] intValue];
        model.text = [answer.responseData objectForKey:@"text"];
        model.tags = [answer.responseData objectForKey:@"tags"];
        model.wlist = [answer.responseData objectForKey:@"wlist"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}


-(void)imageReviewWithSource:(NSString * _Nullable)imageUrl
                   imageData:(NSData * _Nullable)imageData
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable imageReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    if ((imageUrl == nil || imageUrl.length == 0) && imageData == nil) {
        FPNSLog(@"imageReviewWithSource error imageUrl and imageData is nil");
        return;
    }
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (imageData != nil) {
        [dic setValue:imageData forKey:@"image"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:imageUrl forKey:@"image"];
        [dic setValue:@(1) forKey:@"type"];
    }
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"icheck" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
       
        if (successCallback) {
            RTMReviewAnswer * model = [RTMReviewAnswer new];
            model.result = [[data objectForKey:@"result"] intValue];
            model.tags = [data objectForKey:@"tags"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMReviewAnswer*)imageReviewWithSource:(NSString * _Nullable)imageUrl
                               imageData:(NSData * _Nullable)imageData
                                 timeout:(int)timeout{
    
    if ((imageUrl == nil || imageUrl.length == 0) && imageData == nil) {
        FPNSLog(@"imageReviewWithSource error imageUrl and imageData is nil");
        return nil;
    }
    
    RTMReviewAnswer * model = [RTMReviewAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (imageData != nil) {
        [dic setValue:imageData forKey:@"image"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:imageUrl forKey:@"image"];
        [dic setValue:@(1) forKey:@"type"];
    }
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"icheck" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.result = [[answer.responseData objectForKey:@"result"] intValue];
        model.tags = [answer.responseData objectForKey:@"tags"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}



-(void)audioReviewWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString * _Nonnull)lang
                       codec:(NSString * _Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable audioReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    if ((audioUrl == nil || audioUrl.length == 0) && audioData == nil) {
        FPNSLog(@"audioReviewWithSource error audioUrl and audioData is nil");
        return;
    }
    
    if (lang == nil || lang.length == 0) {
        FPNSLog(@"audioReviewWithSource error lang is nil");
        return ;
    }
    
    if (codec == nil || codec.length == 0) {
        codec = @"AMR_WB";
    }
    
    if (srate == 0) {
        srate = 16000;
    }
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (audioData != nil) {
        [dic setValue:audioData forKey:@"audio"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:audioUrl forKey:@"audio"];
        [dic setValue:@(1) forKey:@"type"];
    }
    [dic setValue:lang forKey:@"lang"];
    [dic setValue:codec forKey:@"codec"];
    [dic setValue:@(srate) forKey:@"srate"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"acheck" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        if (successCallback) {
            RTMReviewAnswer * model = [RTMReviewAnswer new];
            model.result = [[data objectForKey:@"result"] intValue];
            model.tags = [data objectForKey:@"tags"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMReviewAnswer*)audioReviewWithSource:(NSString * _Nullable)audioUrl
                                         audioData:(NSData * _Nullable)audioData
                                              lang:(NSString * _Nonnull)lang
                                             codec:(NSString * _Nullable)codec
                                             srate:(int32_t)srate
                                        timeout:(int)timeout{
    
    
    if ((audioUrl == nil || audioUrl.length == 0) && audioData == nil) {
        FPNSLog(@"audioReviewWithSource error audioUrl and audioData is nil");
        return nil;
    }
    
    if (lang == nil || lang.length == 0) {
        FPNSLog(@"audioReviewWithSource error lang is nil");
        return nil;
    }
    
    if (codec == nil || codec.length == 0) {
        codec = @"AMR_WB";
    }
    
    if (srate == 0) {
        srate = 16000;
    }
    
    RTMReviewAnswer * model = [RTMReviewAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (audioData != nil) {
        [dic setValue:audioData forKey:@"audio"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:audioUrl forKey:@"audio"];
        [dic setValue:@(1) forKey:@"type"];
    }
    [dic setValue:lang forKey:@"lang"];
    [dic setValue:codec forKey:@"codec"];
    [dic setValue:@(srate) forKey:@"srate"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"acheck" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.result = [[answer.responseData objectForKey:@"result"] intValue];
        model.tags = [answer.responseData objectForKey:@"tags"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)videoReviewWithSource:(NSString * _Nullable)videoUrl
                   videoData:(NSData * _Nullable)videoData
                   videoName:(NSString * _Nonnull)videoName
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable videoReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    if ((videoUrl == nil || videoUrl.length == 0) && videoData == nil) {
        FPNSLog(@"videoReviewWithSource error videoUrl and videoData is nil");
        return;
    }
    
   
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (videoData != nil) {
        [dic setValue:videoData forKey:@"video"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:videoUrl forKey:@"video"];
        [dic setValue:@(1) forKey:@"type"];
    }
    [dic setValue:videoName forKey:@"videoName"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"vcheck" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        if (successCallback) {
            RTMReviewAnswer * model = [RTMReviewAnswer new];
            model.result = [[data objectForKey:@"result"] intValue];
            model.tags = [data objectForKey:@"tags"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMReviewAnswer*)videoReviewWithSource:(NSString * _Nullable)videoUrl
                               videoData:(NSData * _Nullable)videoData
                               videoName:(NSString * _Nonnull)videoName
                                 timeout:(int)timeout{
    
    
    if ((videoUrl == nil || videoUrl.length == 0) && videoData == nil) {
        FPNSLog(@"imageReviewWithSource error videoUrl and videoData is nil");
        return nil;
    }
    
    
    
    RTMReviewAnswer * model = [RTMReviewAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (videoData != nil) {
        [dic setValue:videoData forKey:@"video"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:videoUrl forKey:@"video"];
        [dic setValue:@(1) forKey:@"type"];
    }
    [dic setValue:videoName forKey:@"videoName"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"vcheck" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.result = [[answer.responseData objectForKey:@"result"] intValue];
        model.tags = [answer.responseData objectForKey:@"tags"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}


-(void)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString *_Nonnull)lang
                       codec:(NSString *_Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    if ((audioUrl == nil || audioUrl.length == 0) && audioData == nil) {
        FPNSLog(@"voiceToTextWithSource error audioUrl and audioData is nil");
        return;
    }
    
    if (lang == nil || lang.length == 0) {
        FPNSLog(@"voiceToTextWithSource error lang is nil");
        return;
    }
    
    
    if (codec == nil || codec.length == 0) {
        codec = @"AMR_WB";
    }
    
    if (srate == 0) {
        srate = 16000;
    }
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (audioData != nil) {
        [dic setValue:audioData forKey:@"audio"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:audioUrl forKey:@"audio"];
        [dic setValue:@(1) forKey:@"type"];
    }
    [dic setValue:lang forKey:@"lang"];
    [dic setValue:codec forKey:@"codec"];
    [dic setValue:@(srate) forKey:@"srate"];

    FPNNQuest * quest = [FPNNQuest questWithMethod:@"speech2text" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        if (successCallback) {
            RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
            model.text = [data objectForKey:@"text"];
            model.lang = [data objectForKey:@"lang"];
            successCallback(model);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
    
}
-(RTMSpeechRecognitionAnswer*)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                                          audioData:(NSData * _Nullable)audioData
                                               lang:(NSString *_Nonnull)lang
                                              codec:(NSString *_Nullable)codec
                                              srate:(int32_t)srate
                                            timeout:(int)timeout{
    
    if ((audioUrl == nil || audioUrl.length == 0) && audioData == nil) {
        FPNSLog(@"voiceToTextWithSource error audioUrl and audioData is nil");
        return nil;
    }
    
    if (lang == nil || lang.length == 0) {
        FPNSLog(@"voiceToTextWithSource error lang is nil");
        return nil;
    }
    
    
    if (codec == nil || codec.length == 0) {
        codec = @"AMR_WB";
    }
    
    if (srate == 0) {
        srate = 16000;
    }
    
    RTMSpeechRecognitionAnswer * model = [RTMSpeechRecognitionAnswer new];
    clientConnectStatueVerifySync
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (audioData != nil) {
        [dic setValue:audioData forKey:@"audio"];
        [dic setValue:@(2) forKey:@"type"];
    }else{
        [dic setValue:audioUrl forKey:@"audio"];
        [dic setValue:@(1) forKey:@"type"];
    }
    
    [dic setValue:lang forKey:@"lang"];
    [dic setValue:codec forKey:@"codec"];
    [dic setValue:@(srate) forKey:@"srate"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"speech2text" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                        timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.lang = [answer.responseData objectForKey:@"lang"];
        model.text = [answer.responseData objectForKey:@"text"];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}
@end
