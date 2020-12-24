//
//  RTMClient+Administrator.h
//  Rtm
//
//  Created by zsl on 2019/12/12.
//  Copyright © 2019 FunPlus. All rights reserved.
//


#import <Rtm/Rtm.h>
#import "RTMTranslatedInfo.h"
#import "RTMSendAnswer.h"
#import "RTMHistoryMessageAnswer.h"
#import "RTMGetMessageAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMInfoAnswer.h"
#import "RTMBaseAnswer.h"
#import "RTMAttriAnswer.h"
#import "RTMP2pGroupMemberAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMTranslatedInfoAnswer.h"
#import "RTMSpeechRecognitionAnswer.h"
#import "RTMTextProfanityAnswer.h"
#import "RTMTextReviewAnswer.h"
#import "RTMReviewAnswer.h"
#import "RTMGetPushAttrsAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Tools)
/// 设置当前用户需要的翻译语言
/// @param language 对应语言
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setLanguage:(NSString * _Nonnull)language
           timeout:(int)timeout
           success:(void(^)(void))successCallback
              fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setLanguage:(NSString * _Nonnull)language
                 timeout:(int)timeout;


/// 翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）
/// @param translateText 翻译文本
/// @param originalLanguage 原语言类型 
/// @param targetLanguage 目标语言类型
/// @param type 可选值为chat或mail。如未指定，则默认使用chat
/// @param profanity 敏感词过滤   默认：off censor: 用星号(*)替换敏感词
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)translateText:(NSString * _Nonnull)translateText
    originalLanguage:(NSString * _Nullable)originalLanguage
      targetLanguage:(NSString * _Nonnull)targetLanguage
                type:(NSString * _Nullable)type
           profanity:(NSString * _Nullable)profanity
             timeout:(int)timeout
             success:(void(^)(RTMTranslatedInfo * _Nullable translatedInfo))successCallback
                fail:(RTMAnswerFailCallBack)failCallback;
-(RTMTranslatedInfoAnswer*)translateText:(NSString * _Nonnull)translateText
                        originalLanguage:(NSString * _Nullable)originalLanguage
                          targetLanguage:(NSString * _Nonnull)targetLanguage
                                    type:(NSString * _Nullable)type
                               profanity:(NSString * _Nullable)profanity
                                 timeout:(int)timeout;







/// 添加debug日志
/// @param msg msg
/// @param attrs 属性
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDebugLogWithMsg:(NSString * _Nonnull)msg
                    attrs:(NSString * _Nonnull)attrs
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addDebugLogWithMsg:(NSString * _Nonnull)msg
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout;


/// 添加设备，应用信息
/// @param apptype app类型
/// @param deviceToken token
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDeviceWithApptype:(NSString * _Nonnull)apptype
                deviceToken:(NSString * _Nonnull)deviceToken
                    timeout:(int)timeout
                    success:(void(^)(void))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addDeviceWithApptype:(NSString * _Nonnull)apptype
                          deviceToken:(NSString * _Nonnull)deviceToken
                              timeout:(int)timeout;


/// 删除设备，应用信息，解除绑定的意思
/// @param deviceToken token
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                               timeout:(int)timeout;


///// 添加设备推送属性
///// @param type type=0, 设置某个p2p 不推送    type=1, 设置某个group不推送
///// @param xid type=0,对应fromUserId  type=1,对应groupId
///// @param mTypes 消息类型数组  为空，则所有mtype均不推送，其他值，则指定mtype不推送
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
//-(void)addPushAttrsWithType:(int)type
//                        xid:(int64_t)xid
//                     mTypes:(NSArray <NSNumber*>* _Nullable)mTypes
//                    timeout:(int)timeout
//                    success:(void(^)(void))successCallback
//                       fail:(RTMAnswerFailCallBack)failCallback;
//-(RTMBaseAnswer*)addPushAttrsWithType:(int)type
//                                  xid:(int64_t)xid
//                               mTypes:(NSArray<NSNumber*>* _Nullable)mTypes
//                              timeout:(int)timeout;
//
//
///// 移除设备推送属性
///// @param type type=0, 设置某个p2p 不推送    type=1, 设置某个group不推送
///// @param xid type=0,对应fromUserId  type=1,对应groupId
///// @param mTypes 消息类型数组  为空，则所有mtype均不推送，其他值，则指定mtype不推送
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
//-(void)removePushAttrsWithType:(int)type
//                           xid:(int64_t)xid
//                        mTypes:(NSArray <NSNumber*>* _Nullable)mTypes
//                       timeout:(int)timeout
//                       success:(void(^)(void))successCallback
//                          fail:(RTMAnswerFailCallBack)failCallback;
//-(RTMBaseAnswer*)removePushAttrsWithType:(int)type
//                                     xid:(int64_t)xid
//                                  mTypes:(NSArray<NSNumber*>* _Nullable)mTypes
//                                 timeout:(int)timeout;
//
//
///// 获取推送属性
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
//-(void)getPushAttrsWithTimeout:(int)timeout
//                       success:(void(^)(RTMGetPushAttrsAnswer *answer))successCallback
//                          fail:(RTMAnswerFailCallBack)failCallback;
//-(RTMGetPushAttrsAnswer*)getPushAttrsWithTimeout:(int)timeout;



/// 文本审核, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本审核系统）
/// @param text  需要过滤的文本
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)textReviewWithText:(NSString * _Nonnull)text
                  timeout:(int)timeout
                  success:(void(^)(RTMTextReviewAnswer * _Nullable textReview))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMTextReviewAnswer*)textReviewWithText:(NSString * _Nonnull)text
                                  timeout:(int)timeout;




/// 图片审核, （调用此接口需在管理系统启用图片审核系统）调用这个接口的超时时间得加大到120s
/// @param imageUrl 图片数据 imageUrl imageData 二选一  同时传imageData优先
/// @param imageData 图片数据 imageUrl imageData 二选一 同时传imageData优先
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)imageReviewWithSource:(NSString * _Nullable)imageUrl
                   imageData:(NSData * _Nullable)imageData
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable imageReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)imageReviewWithSource:(NSString * _Nullable)imageUrl
                               imageData:(NSData * _Nullable)imageData
                                 timeout:(int)timeout;


/// 音频审核, （调用此接口需在管理系统启用语音审核系统）调用这个接口的超时时间得加大到120s
/// @param audioUrl 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param audioData 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param lang 语言
/// @param codec 编解码 传空 默认AMR_WB
/// @param srate 采样率 传空 默认为16000
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)audioReviewWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString * _Nonnull)lang
                       codec:(NSString * _Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable audioReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)audioReviewWithSource:(NSString * _Nullable)audioUrl
                                         audioData:(NSData * _Nullable)audioData
                                              lang:(NSString * _Nonnull)lang
                                             codec:(NSString * _Nullable)codec
                                             srate:(int32_t)srate
                                           timeout:(int)timeout;


/// 视频审核, （调用此接口需在管理系统启用视频审核系统） 调用这个接口的超时时间得加大到120s
/// @param videoUrl 视频数据 videoUrl videoData二选一
/// @param videoData 视频数据 videoUrl videoData二选一
/// @param videoName 视频名字
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)videoReviewWithSource:(NSString * _Nullable)videoUrl
                   videoData:(NSData * _Nullable)videoData
                   videoName:(NSString * _Nonnull)videoName
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable videoReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)videoReviewWithSource:(NSString * _Nullable)videoUrl
                                         videoData:(NSData * _Nullable)videoData
                                         videoName:(NSString * _Nonnull)videoName
                                           timeout:(int)timeout;


/// 语音转文字（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s
/// @param audioUrl 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param audioData 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param lang 语言
/// @param codec 编解码 传空 默认AMR_WB
/// @param srate 采样率 传空 默认为16000
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString *_Nonnull)lang
                       codec:(NSString *_Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSpeechRecognitionAnswer*)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                                          audioData:(NSData * _Nullable)audioData
                                               lang:(NSString *_Nonnull)lang
                                              codec:(NSString *_Nullable)codec
                                              srate:(int32_t)srate
                                           timeout:(int)timeout;

@end

NS_ASSUME_NONNULL_END


