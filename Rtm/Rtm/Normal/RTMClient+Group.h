//
//  RTMClient+Group.h
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
#import "RTMUnreadAnswer.h"
#import "RTMMemberCountAnswer.h"
NS_ASSUME_NONNULL_BEGIN


@interface RTMClient (Group)
/// 发送Group消息
/// @param groupId int64 groupid
/// @param messageType int64 消息类型 请使用51-127
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                  messageType:(NSNumber * _Nonnull)messageType
                      message:(NSString * _Nonnull)message
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                            messageType:(NSNumber * _Nonnull)messageType
                                message:(NSString * _Nonnull)message
                                  attrs:(NSString * _Nonnull)attrs
                                timeout:(int)timeout;



/// 发送Group消息 
/// @param groupId int64 groupid
/// @param messageType int64 消息类型 请使用51-127
/// @param data 消息内容 二进制数据
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                        messageType:(NSNumber * _Nonnull)messageType
                               data:(NSData * _Nonnull)data
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout
                            success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                                  messageType:(NSNumber * _Nonnull)messageType
                                         data:(NSData * _Nonnull)data
                                        attrs:(NSString * _Nonnull)attrs
                                      timeout:(int)timeout;



/// 检测group离线聊天数目   只要是设置为保存的消息，均可获取未读。不限于 chat、cmd、file。
/// @param groupIds int64 用户集合
/// @param mtime 毫秒级时间戳，获取这个时间戳之后的未读消息，如果mtime 为空，则获取上一次logout后的未读消息
/// @param messageTypes int 消息类型集合 (如果不传默认所有聊天相关消息类型，不包含自定义的type)
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调

-(void)getGroupUnreadWithGroupIds:(NSArray<NSNumber*> * _Nonnull)groupIds
                            mtime:(int64_t)mtime
                     messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                          timeout:(int)timeout
                          success:(void(^)(RTMUnreadAnswer *_Nullable history))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMUnreadAnswer * _Nullable)getGroupUnreadWithGroupIds:(NSArray<NSNumber*> * _Nonnull)groupIds
                                                   mtime:(int64_t)mtime
                                            messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                                                 timeout:(int)timeout;




/// 获取group历史消息
/// @param groupId int64 获取group历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupHistoryMessageWithGroupId:(NSNumber * _Nonnull)groupId
                                    desc:(BOOL)desc
                                     num:(NSNumber * _Nonnull)num
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber * >* _Nullable)mtypes
                                 timeout:(int)timeout
                                 success:(void(^)(RTMHistory* _Nullable history))successCallback
                                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getGroupHistoryMessageWithGroupId:(NSNumber * _Nonnull)groupId
                                                        desc:(BOOL)desc
                                                         num:(NSNumber * _Nonnull)num
                                                       begin:(NSNumber * _Nullable)begin
                                                         end:(NSNumber * _Nullable)end
                                                      lastid:(NSNumber * _Nullable)lastid
                                                      mtypes:(NSArray <NSNumber * >* _Nullable)mtypes
                                                     timeout:(int)timeout;

/// 删除消息 group
/// @param messageId int64 消息id
/// @param groupId int64
/// @param fromUserId int64
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                        groupId:(NSNumber * _Nonnull)groupId
                     fromUserId:(NSNumber * _Nonnull)fromUserId
                        timeout:(int)timeout
                        success:(void(^)(void))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                                  groupId:(NSNumber * _Nonnull)groupId
                               fromUserId:(NSNumber * _Nonnull)fromUserId
                                  timeout:(int)timeout;


/// 获取消息 group
/// @param messageId int64 消息id
/// @param groupId int64 群id
/// @param fromUserId 发送者id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 成功回调
-(void)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                     groupId:(NSNumber * _Nonnull)groupId
                  fromUserId:(NSNumber * _Nonnull)fromUserId
                     timeout:(int)timeout
                     success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMGetMessageAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                                     groupId:(NSNumber * _Nonnull)groupId
                                  fromUserId:(NSNumber * _Nonnull)fromUserId
                                     timeout:(int)timeout;



/// 添加Group成员，每次最多添加100人
/// @param groupId int64 群组id
/// @param membersId [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                   membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                             membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                               timeout:(int)timeout;

/// 删除Group成员，每次最多删除100人
/// @param groupId int64 群组id
/// @param membersId [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                        timeout:(int)timeout
                        success:(void(^)(void))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                                  timeout:(int)timeout;




/// 获取group中的用户数量   online = true，则返回在线数量
/// @param groupId int64 群组id
/// @param online bool 是否返回在线数量
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupCountWithId:(NSNumber * _Nonnull)groupId
                    online:(BOOL)online
                   timeout:(int)timeout
                   success:(void(^)(RTMMemberCountAnswer * _Nullable memberCountAnswer))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberCountAnswer*)getGroupCountWithId:(NSNumber * _Nonnull)groupId
                                     online:(BOOL)online
                                    timeout:(int)timeout;



/// 获取group中的所有member
/// @param groupId int64 群组id
/// @param online 是否在线
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      online:(BOOL)online
                     timeout:(int)timeout
                     success:(void(^)(RTMMemberAnswer * _Nullable memberCountAnswer))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                  online:(BOOL)online
                                 timeout:(int)timeout;




/// 获取用户在哪些组里
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserGroupsWithTimeout:(int)timeout
                        success:(void(^)(NSArray * _Nullable groupArray))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserGroupsWithTimeout:(int)timeout;
                                 


/// 设置群组的公开信息或者私有信息，会检查用户是否在组内 (openInfo,privateInfo 最长 65535)
/// @param groupId int64 群组id
/// @param openInfo  公开信息
/// @param privateInfo 私有信息
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                 openInfo:(NSString * _Nullable)openInfo
              privateInfo:(NSString * _Nullable)privateInfo
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                           openInfo:(NSString * _Nullable)openInfo
                        privateInfo:(NSString * _Nullable)privateInfo
                            timeout:(int)timeout;


/// 获取群组的公开信息和私有信息，会检查用户是否在组内
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                  timeout:(int)timeout
                  success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                            timeout:(int)timeout;


/// 获取群组的公开信息
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                      timeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                                timeout:(int)timeout;



/// 获取群组的公开信息
/// @param groupIds int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                      timeout:(int)timeout
                      success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                                  timeout:(int)timeout;




@end

NS_ASSUME_NONNULL_END
