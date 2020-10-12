//
//  RTMClient+Group_Chat.h
//  Rtm
//
//  Created by zsl on 2019/12/24.
//  Copyright © 2019 FunPlus. All rights reserved.
//


#import <Rtm/Rtm.h>
#import "RTMHistoryMessage.h"
#import "RTMHistory.h"
#import "RTMSendAnswer.h"
#import "RTMHistoryMessageAnswer.h"
#import "RTMGetMessageAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMInfoAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Group_Chat)
/// 发送Group消息 对 sendGroupMessageWithId 的封装 mtype=30
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取 会产生聊天会话 通过getAllSessionsWithTimeout获取
/// @param groupId int64 接收id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupMessageChatWithId:(NSNumber * _Nonnull)groupId
                          message:(NSString * _Nonnull)message
                            attrs:(NSString * _Nonnull)attrs
                          timeout:(int)timeout
                          success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendGroupMessageChatWithId:(NSNumber * _Nonnull)groupId
                                    message:(NSString * _Nonnull)message
                                      attrs:(NSString * _Nonnull)attrs
                                    timeout:(int)timeout;




/// 发送音频消息 对 sendGroupMessageWithId 的封装 mtype=31
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取 会产生聊天会话 通过getAllSessionsWithTimeout获取
/// 对音频大小有限制
/// @param groupId int64
/// @param audioFilePath 音频数据路径  音频要求 16KHZ 16位 单声道 
/// @param attrs 属性 建议使用可解析的json字符串
/// @param lang 音频语言
/// @param duration 音频时长 毫秒 必传
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupAudioMessageChatWithId:(NSNumber * _Nonnull)groupId
                         audioFilePath:(NSString * _Nonnull)audioFilePath
                                 attrs:(NSDictionary * _Nullable)attrs
                                  lang:(NSString * _Nonnull)lang
                              duration:(long long)duration
                               timeout:(int)timeout
                               success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendGroupAudioMessageChatWithId:(NSNumber * _Nonnull)groupId
                                   audioFilePath:(NSString * _Nonnull)audioFilePath
                                           attrs:(NSDictionary * _Nullable)attrs
                                            lang:(NSString * _Nonnull)lang
                                        duration:(long long)duration
                                         timeout:(int)timeout;





/// 发送系统命令 对 sendGroupMessageWithId 的封装 mtype=32
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取
/// 系统命令(或者需要离线提醒的消息)，比如：组队邀请,申请入群,拒绝申请入群,邀请入群,拒绝邀请入群,加好友,删除好友,其他等和聊天相关的命令
/// @param groupId int64 接收id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupCmdMessageChatWithId:(NSNumber * _Nonnull)groupId
                             message:(NSString * _Nonnull)message
                               attrs:(NSString * _Nonnull)attrs
                             timeout:(int)timeout
                             success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)sendGroupCmdMessageChatWithId:(NSNumber * _Nonnull)groupId
                                      message:(NSString * _Nonnull)message
                                        attrs:(NSString * _Nonnull)attrs
                                      timeout:(int)timeout;


/// 获取历史group消息 对 getGroupHistoryMessageWithGroupId 的封装 mtypes = [30,31,32,40,41,42] （只包含sendGroupMessageChatWithId，sendGroupAudioMessageChatWithId，sendGroupCmdMessageChatWithId产生的历史消息）
/// @param groupId int64 
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupHistoryMessageChatWithGroupId:(NSNumber * _Nonnull)groupId
                                        desc:(BOOL)desc
                                         num:(NSNumber * _Nonnull)num
                                       begin:(NSNumber * _Nullable)begin
                                         end:(NSNumber * _Nullable)end
                                      lastid:(NSNumber * _Nullable)lastid
                                     timeout:(int)timeout
                                     success:(void(^)(RTMHistory* _Nullable history))successCallback
                                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getGroupHistoryMessageChatWithGroupId:(NSNumber * _Nonnull)groupId
                                                            desc:(BOOL)desc
                                                             num:(NSNumber * _Nonnull)num
                                                           begin:(NSNumber * _Nullable)begin
                                                             end:(NSNumber * _Nullable)end
                                                          lastid:(NSNumber * _Nullable)lastid
                                                         timeout:(int)timeout;
@end

NS_ASSUME_NONNULL_END

