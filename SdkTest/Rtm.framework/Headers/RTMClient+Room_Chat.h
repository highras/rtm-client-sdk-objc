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
#import "RTMAudioModel.h"
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



///// 发送音频消息 对 sendFile 的封装 mtype = 41
///// @param roomId int64
///// @param audioModel  音频数据模型
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
//-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
//                           audioModel:(RTMAudioModel * _Nonnull)audioModel
//                                attrs:(NSDictionary * _Nullable)attrs
//                              timeout:(int)timeout
//                              success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
//                                 fail:(RTMAnswerFailCallBack)failCallback;
//-(RTMSendAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
//                                     audioModel:(RTMAudioModel * _Nonnull)audioModel
//                                          attrs:(NSDictionary * _Nullable)attrs
//                                        timeout:(int)timeout;



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


/// 获取历史Room消息 对 getRoomHistoryMessageWithId 的封装 mtypes = [30,32,40,41,42,50] 
/// @param roomId int64
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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

