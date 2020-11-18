//
//  RTMClient+Broadcast.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>
#import "RTMHistoryMessage.h"
#import "RTMGetMessage.h"
#import "RTMHistory.h"
#import "RTMSendAnswer.h"
#import "RTMHistoryMessageAnswer.h"
#import "RTMGetMessageAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMInfoAnswer.h"
#import "RTMSpeechRecognitionAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Broadcast)

/// 获取广播历史消息
/// @param num int16 条数
/// @param desc 是否降序排列
/// @param begin int64
/// @param end int64
/// @param lastid int64
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                 timeout:(int)timeout
                                 success:(void(^)(RTMHistory* _Nullable history))successCallback
                                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                                        desc:(BOOL)desc
                                                       begin:(NSNumber * _Nullable)begin
                                                         end:(NSNumber * _Nullable)end
                                                      lastid:(NSNumber * _Nullable)lastid
                                                      mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                                     timeout:(int)timeout;



/// 获取消息
/// @param messageId int64 消息id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 成功回调
-(void)getBroadCastMessageWithId:(NSNumber * _Nonnull)messageId
                         timeout:(int)timeout
                         success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMGetMessageAnswer*)getBroadCastHistoryMessageWithId:(NSNumber * _Nonnull)messageId
                                                timeout:(int)timeout;



///// 语音识别 （调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s，此接口只支持通过rtm发送的语音消息，无需把原始语音再一次发送，节省流量
///// @param messageId int64 消息ID
///// @param fromUserId int64 发送者ID
///// @param profanityFilter 敏感词过滤
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
//-(void)stranscribeBroadcastWithId:(NSNumber * _Nonnull)messageId
//                       fromUserId:(NSNumber * _Nonnull)fromUserId
//                  profanityFilter:(BOOL)profanityFilter
//                          timeout:(int)timeout
//                          success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
//                             fail:(RTMAnswerFailCallBack)failCallback;
//
//-(RTMSpeechRecognitionAnswer*)stranscribeBroadcastWithId:(NSNumber * _Nonnull)messageId
//                                              fromUserId:(NSNumber * _Nonnull)fromUserId
//                                         profanityFilter:(BOOL)profanityFilter
//                                                 timeout:(int)timeout;
@end

NS_ASSUME_NONNULL_END
