//
//  RTMClient+User.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>
#import "RTMSendAnswer.h"
#import "RTMHistoryMessageAnswer.h"
#import "RTMGetMessageAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMInfoAnswer.h"
#import "RTMBaseAnswer.h"
#import "RTMAttriAnswer.h"
#import "RTMP2pGroupMemberAnswer.h"
#import "RTMMemberAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (User)


/// 客户端主动断开
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)offLineWithTimeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)offLineWithTimeout:(int)timeout;


/// 踢掉一个链接（只对多用户登录有效，不能踢掉自己，可以用来实现同类设备，只容许一个登录）
/// @param endPoint  链接的endpoint，可以通过调用 getAttrsWithTimeout 获取
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                   timeout:(int)timeout
                   success:(void(^)(void))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                             timeout:(int)timeout;


/// 添加key_value形式的变量（例如设置客户端信息，会保存在当前链接中，客户端可以获取到）
/// @param attrs 注意 key value 为 nsstring
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                           timeout:(int)timeout;


/// 获取attrs
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getAttrsWithTimeout:(int)timeout
                   success:(void(^)(RTMAttriAnswer * _Nullable attri))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getAttrsWithTimeout:(int)timeout;


/// 检测离线聊天  只有通过Chat类接口 才会产生
/// @param clear yes 获取并清除离线提醒
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUnreadMessagesWithClear:(BOOL)clear
                          timeout:(int)timeout
                          success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMP2pGroupMemberAnswer*)getUnreadMessagesWithClear:(BOOL)clear
                                             timeout:(int)timeout;


/// 清除离线聊天提醒
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)cleanUnreadMessagesWithTimeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)cleanUnreadMessagesWithTimeout:(int)timeout;


/// 获取所有聊天的会话（p2p用户和自己也会产生会话）
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getAllSessionsWithTimeout:(int)timeout
                         success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMP2pGroupMemberAnswer*)getAllSessionsWithTimeout:(int)timeout;


/// 获取在线用户列表，限制每次最多获取200个
/// @param userIds [int64] 用户id 数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getOnlineUsers:(NSArray <NSNumber* >* _Nonnull)userIds
              timeout:(int)timeout
              success:(void(^)(NSArray * _Nullable uidArray))successCallback
                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getOnlineUsers:(NSArray <NSNumber* >* _Nullable)userIds
                          timeout:(int)timeout;



/// 设置用户自己的公开信息或者私有信息
/// @param openInfo 公开信息
/// @param privteInfo 私有信息
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                    privteinfo:(NSString * _Nullable)privteInfo
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                          privteinfo:(NSString * _Nullable)privteInfo
                             timeout:(int)timeout;


/// 获取用户自己的公开信息和私有信息
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserInfoWithTimeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getUserInfoWithTimeout:(int)timeout;



/// 获取其他用户的公开信息，每次最多获取100人
/// @param userIds [int64] 用户id 数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserOpenInfo:(NSArray <NSNumber* > * _Nullable)userIds
               timeout:(int)timeout
               success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getUserOpenInfo:(NSArray <NSNumber* > * _Nullable)userIds
                          timeout:(int)timeout;




/// 获取存储的数据信息(key:最长128字节)
/// @param key 数据信息key
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserValueInfoWithKey:(NSString * _Nullable)key
                       timeout:(int)timeout
                       success:(void(^)(RTMInfoAnswer * _Nullable valueInfo))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getUserValueInfoWithKey:(NSString * _Nullable)key
                                timeout:(int)timeout;




/// 设置存储的数据信息(key:最长128字节，value：最长65535字节)
/// @param key 数据信息key
/// @param value 数据信息value
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setUserValueInfoWithKey:(NSString * _Nonnull)key
                         value:(NSString * _Nonnull)value
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setUserValueInfoWithKey:(NSString * _Nonnull)key
                                   value:(NSString * _Nonnull)value
                                 timeout:(int)timeout;

/// 删除存储的数据信息
/// @param key 数据信息key
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteUserDataWithKey:(NSString * _Nonnull)key
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteUserDataWithKey:(NSString * _Nonnull)key
                           timeout:(int)timeout;


@end

NS_ASSUME_NONNULL_END
