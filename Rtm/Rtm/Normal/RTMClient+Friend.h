//
//  RTMClient+Friend.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Friend)


/// 添加好友，每次最多添加100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
               timeout:(int)timeout
                   tag:(id _Nullable)tag
               success:(RTMAnswerSuccessCallBack)successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                     timeout:(int)timeout;


/// 删除好友，每次最多删除100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                  timeout:(int)timeout
                      tag:(id _Nullable)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                        timeout:(int)timeout;


/// 获取好友
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserFriendsWithTimeout:(int)timeout
                             tag:(id _Nullable)tag
                         success:(RTMAnswerSuccessCallBack)successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getUserFriendsWithTimeout:(int)timeout;

@end

NS_ASSUME_NONNULL_END
