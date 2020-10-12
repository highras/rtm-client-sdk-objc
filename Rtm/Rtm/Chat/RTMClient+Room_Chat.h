//
//  RTMClient+Room_Chat.h
//  Rtm
//
//  Created by zsl on 2019/12/24.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>
#import "RTMHistory.h"
#import "RTMSendAnswer.h"
#import "RTMHistoryMessageAnswer.h"
#import "RTMGetMessageAnswer.h"
#import "RTMMemberAnswer.h"
#import "RTMInfoAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Room_Chat)
/// 发送Room消息 对 sendRoomMessageWithId 的封装 mtype=30
/// @param roomId int64 接收id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                         message:(NSString * _Nonnull)message
                           attrs:(NSString * _Nonnull)attrs
                         timeout:(int)timeout
                         success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                                   message:(NSString * _Nonnull)message
                                     attrs:(NSString * _Nonnull)attrs
                                   timeout:(int)timeout;



/// 发送音频消息 对 sendRoomMessageWithId 的封装 mtype=31
/// 对音频大小有限制
/// @param roomId int64
/// @param audioFilePath 音频数据路径  音频要求 16KHZ 16位 单声道 
/// @param attrs 属性
/// @param lang 音频语言
/// @param duration 音频时长 毫秒 必传
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                        audioFilePath:(NSString * _Nonnull)audioFilePath
                                attrs:(NSDictionary * _Nullable)attrs
                                 lang:(NSString * _Nonnull)lang
                             duration:(long long)duration
                              timeout:(int)timeout
                              success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                                  audioFilePath:(NSString * _Nonnull)audioFilePath
                                          attrs:(NSDictionary * _Nullable)attrs
                                           lang:(NSString * _Nonnull)lang
                                       duration:(long long)duration
                                        timeout:(int)timeout;



/// 发送系统命令 对 sendRoomMessageWithId 的封装 mtype=32
/// 系统命令(或者需要离线提醒的消息)，比如：组队邀请,申请入群,拒绝申请入群,邀请入群,拒绝邀请入群,加好友,删除好友,其他等和聊天相关的命令
/// @param roomId int64 接收人id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                            message:(NSString * _Nonnull)message
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout
                            success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                                      message:(NSString * _Nonnull)message
                                        attrs:(NSString * _Nonnull)attrs
                                      timeout:(int)timeout;


/// 获取历史Room消息 对 getRoomHistoryMessageWithId 的封装 mtypes = [30,31,32,40,41,42] （只包含sendRoomMessageChatWithId，sendRoomAudioMessageChatWithId，sendRoomCmdMessageChatWithId产生的历史消息）
/// @param roomId int64
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
                                      desc:(BOOL)desc
                                       num:(NSNumber * _Nonnull)num
                                     begin:(NSNumber * _Nullable)begin
                                       end:(NSNumber * _Nullable)end
                                    lastid:(NSNumber * _Nullable)lastid
                                   timeout:(int)timeout
                                   success:(void(^)(RTMHistory* _Nullable history))successCallback
                                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
                                                          desc:(BOOL)desc
                                                           num:(NSNumber * _Nonnull)num
                                                         begin:(NSNumber * _Nullable)begin
                                                           end:(NSNumber * _Nullable)end
                                                        lastid:(NSNumber * _Nullable)lastid
                                                       timeout:(int)timeout;
@end

NS_ASSUME_NONNULL_END

