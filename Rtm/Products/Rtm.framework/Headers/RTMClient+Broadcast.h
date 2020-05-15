//
//  RTMClient+Broadcast.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

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
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                 timeout:(int)timeout
                                     tag:(id _Nullable)tag
                                 success:(RTMAnswerSuccessCallBack)successCallback
                                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                          desc:(BOOL)desc
                                         begin:(NSNumber * _Nullable)begin
                                           end:(NSNumber * _Nullable)end
                                        lastid:(NSNumber * _Nullable)lastid
                                        mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                       timeout:(int)timeout;

@end

NS_ASSUME_NONNULL_END
