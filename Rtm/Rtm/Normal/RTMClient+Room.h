//
//  RTMClient+Room.h
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
#import "RTMAttriAnswer.h"
#import "RTMCountAnswer.h"
#import "RTMRoomMemberCountAnswer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Room)


/// 发送房间消息
/// @param roomId int64 房间id
/// @param messageType int8 消息类型 请使用51-127
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
 
-(void)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                 messageType:(NSNumber * _Nonnull)messageType
                     message:(NSString * _Nonnull)message
                       attrs:(NSString * _Nonnull)attrs
                     timeout:(int)timeout
                     success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
                           messageType:(NSNumber * _Nonnull)messageType
                               message:(NSString * _Nonnull)message
                                 attrs:(NSString * _Nonnull)attrs
                               timeout:(int)timeout;



/// 发送房间消息
/// @param roomId int64 房间id
/// @param messageType int8 消息类型 请使用51-127
/// @param data 消息内容  二进制数据
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
 
-(void)sendRoomBinaryMessageWithId:(NSNumber * _Nonnull)roomId
                       messageType:(NSNumber * _Nonnull)messageType
                              data:(NSData * _Nonnull)data
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                           success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendRoomBinaryMessageWithId:(NSNumber * _Nonnull)roomId
                                 messageType:(NSNumber * _Nonnull)messageType
                                        data:(NSData * _Nonnull)data
                                       attrs:(NSString * _Nonnull)attrs
                                     timeout:(int)timeout;



/// 获取room历史消息
/// @param roomId 房间id
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomHistoryMessageWithId:(NSNumber * _Nonnull)roomId
                              desc:(BOOL)desc
                               num:(NSNumber * _Nonnull)num
                             begin:(NSNumber * _Nullable)begin
                               end:(NSNumber * _Nullable)end
                            lastid:(NSNumber * _Nullable)lastid
                            mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                           timeout:(int)timeout
                           success:(void(^)(RTMHistory* _Nullable history))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getRoomHistoryMessageWithId:(NSNumber * _Nonnull)roomId
                                              desc:(BOOL)desc
                                                   num:(NSNumber * _Nonnull)num
                                                 begin:(NSNumber * _Nullable)begin
                                                   end:(NSNumber * _Nullable)end
                                                lastid:(NSNumber * _Nullable)lastid
                                                mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                               timeout:(int)timeout;





///// 删除消息 room
///// @param messageId int64 消息id
///// @param roomId int64
///// @param fromUserId int64
///// @param timeout 请求超时时间 秒
///// @param successCallback 成功回调
///// @param failCallback 失败回调
-(void)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                        roomId:(NSNumber * _Nonnull)roomId
                    fromUserId:(NSNumber * _Nonnull)fromUserId
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteRoomMessageWithId:(NSNumber * _Nonnull)messageId
                                  roomId:(NSNumber * _Nonnull)roomId
                              fromUserId:(NSNumber * _Nonnull)fromUserId
                                 timeout:(int)timeout;


/// 获取消息
/// @param messageId int64 消息id
/// @param roomId int64 房间id
/// @param fromUserId int64 发送者
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                     roomId:(NSNumber * _Nonnull)roomId
                 fromUserId:(NSNumber * _Nonnull)fromUserId
                    timeout:(int)timeout
                    success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
-(RTMGetMessageAnswer*)getRoomMessageWithId:(NSNumber * _Nonnull)messageId
                                     roomId:(NSNumber * _Nonnull)roomId
                                 fromUserId:(NSNumber * _Nonnull)fromUserId
                                    timeout:(int)timeout;


/// 进入某个房间或者频道（不会持久化）
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)enterRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)enterRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout;




/// 离开某个房间或者频道（不会持久化）
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)leaveRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)leaveRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout;




/// 获取用户当前所在的所有房间
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserAtRoomsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable roomArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserAtRoomsWithTimeout:(int)timeout;


/// 获取房间中的所有member
/// @param roomId 房间ID int64
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomMembersWithId:(NSNumber * _Nonnull)roomId
                    timeout:(int)timeout
                    success:(void(^)(NSArray * _Nullable userIdArray))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getRoomMembersWithId:(NSNumber * _Nonnull)roomId
                                timeout:(int)timeout;





/// 获取房间中的用户数量
/// @param roomIds 房间ID数组 int64
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomMemberCountWithId:(NSArray <NSNumber*>* _Nonnull)roomIds
                        timeout:(int)timeout
                        success:(void(^)(RTMRoomMemberCountAnswer * answer))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMRoomMemberCountAnswer*)getRoomMemberCountWithId:(NSArray <NSNumber*>*)roomIds
                                             timeout:(int)timeout;






/// 设置房间的公开信息或者私有信息，会检查用户是否在房间(openInfo,privateInfo 最长 65535)
/// @param roomId int64 房间频道id
/// @param openInfo 公开信息
/// @param privateInfo 私有信息
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
                openInfo:(NSString * _Nullable)openInfo
             privateInfo:(NSString * _Nullable)privateInfo
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setRoomInfoWithId:(NSNumber * _Nonnull)roomId
                          openInfo:(NSString * _Nullable)openInfo
                       privateInfo:(NSString * _Nullable)privateInfo
                           timeout:(int)timeout;




/// 获取房间的公开信息和私有信息，会检查用户是否在房间内
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                 timeout:(int)timeout
                 success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                           timeout:(int)timeout;



/// 获取房间的公开信息
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                     timeout:(int)timeout
                     success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                               timeout:(int)timeout;


/// 获取房间的公开信息
/// @param roomIds int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)roomIds
                        timeout:(int)timeout
                        success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getRoomsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)roomIds
                                  timeout:(int)timeout;





@end

NS_ASSUME_NONNULL_END
