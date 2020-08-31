//
//  RTMClient+Friend.h
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
#import "RTMSpeechRecognitionAnswer.h"
#import "RTMBaseAnswer.h"
#import "RTMMemberAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Friend)


/// 添加好友，每次最多添加100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                         timeout:(int)timeout;


/// 删除好友，每次最多删除100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                            timeout:(int)timeout;


/// 获取好友
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserFriendsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserFriendsWithTimeout:(int)timeout;


/// 添加黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                 timeout:(int)timeout;
   

/// 解除黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                    timeout:(int)timeout;



/// 拉取黑名单
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBlacklistWithTimeout:(int)timeout
                       success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getBlacklistWithTimeout:(int)timeout;


@end

NS_ASSUME_NONNULL_END
