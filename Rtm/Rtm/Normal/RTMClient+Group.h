//
//  RTMClient+Group.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>
NS_ASSUME_NONNULL_BEGIN


@interface RTMClient (Group)
/// 发送Group消息 不会产生聊天 会话 离线等记录 如果需要请使用chat类接口
/// @param groupId int64 groupid
/// @param messageType int64 消息类型 请使用51-127
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                  messageType:(NSNumber * _Nonnull)messageType
                      message:(NSString * _Nonnull)message
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                          tag:(id _Nullable)tag
                      success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
                        messageType:(NSNumber * _Nonnull)messageType
                            message:(NSString * _Nonnull)message
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout;



/// 发送Group消息 不会产生聊天 会话 离线等记录 如果需要请使用chat类接口
/// @param groupId int64 groupid
/// @param messageType int64 消息类型 请使用51-127
/// @param data 消息内容 二进制数据
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                        messageType:(NSNumber * _Nonnull)messageType
                               data:(NSData * _Nonnull)data
                              attrs:(NSString * _Nonnull)attrs
                            timeout:(int)timeout
                                tag:(id _Nullable)tag
                            success:(RTMAnswerSuccessCallBack)successCallback
                               fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)sendGroupBinaryMessageWithId:(NSNumber * _Nonnull)groupId
                              messageType:(NSNumber * _Nonnull)messageType
                                     data:(NSData * _Nonnull)data
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout;



/// 获取group历史消息
/// @param groupId int64 获取group历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupMessageWithId:(NSNumber * _Nonnull)groupId
                        desc:(BOOL)desc
                         num:(NSNumber * _Nonnull)num
                       begin:(NSNumber * _Nullable)begin
                         end:(NSNumber * _Nullable)end
                      lastid:(NSNumber * _Nullable)lastid
                      mtypes:(NSArray <NSNumber * >* _Nullable)mtypes
                     timeout:(int)timeout
                         tag:(id _Nullable)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)groupId
                              desc:(BOOL)desc
                               num:(NSNumber * _Nonnull)num
                             begin:(NSNumber * _Nullable)begin
                               end:(NSNumber * _Nullable)end
                            lastid:(NSNumber * _Nullable)lastid
                            mtypes:(NSArray <NSNumber * > * _Nullable)mtypes
                           timeout:(int)timeout;

/// 删除消息 group
/// @param messageId int64 消息id
/// @param groupId int64 
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                        groupId:(NSNumber * _Nonnull)groupId
                        timeout:(int)timeout
                            tag:(id _Nullable)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)deleteGroupMessageWithId:(NSNumber * _Nonnull)messageId
                              groupId:(NSNumber * _Nonnull)groupId
                              timeout:(int)timeout;


/// 获取消息
/// @param messageId int64 消息id
/// @param groupId int64
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 成功回调
-(void)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                     groupId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                         tag:(id _Nullable)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getGroupMessageWithId:(NSNumber * _Nonnull)messageId
                           groupId:(NSNumber * _Nonnull)groupId
                           timeout:(int)timeout;



/// 添加Group成员，每次最多添加100人
/// @param groupId int64 群组id
/// @param membersId [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                   membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                     timeout:(int)timeout
                         tag:(id _Nullable)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                         membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                           timeout:(int)timeout;


/// 删除Group成员，每次最多删除100人
/// @param groupId int64 群组id
/// @param membersId [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                        timeout:(int)timeout
                            tag:(id _Nullable)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                            membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                              timeout:(int)timeout;


/// 获取group中的所有member
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                         tag:(id _Nullable)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                           timeout:(int)timeout;


/// 获取用户在哪些组里
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserGroupsWithTimeout:(int)timeout
                            tag:(id _Nullable)tag
                        success:(RTMAnswerSuccessCallBack)successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getUserGroupsWithTimeout:(int)timeout;
                                 


/// 设置群组的公开信息或者私有信息，会检查用户是否在组内 (openInfo,privateInfo 最长 65535)
/// @param groupId int64 群组id
/// @param openInfo  公开信息
/// @param privateInfo 私有信息
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                 openInfo:(NSString * _Nullable)openInfo
              privateInfo:(NSString * _Nullable)privateInfo
                  timeout:(int)timeout
                      tag:(id _Nullable)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)setGroupInfoWithId:(NSNumber * _Nonnull)groupId
                       openInfo:(NSString * _Nullable)openInfo
                    privateInfo:(NSString * _Nullable)privateInfo
                        timeout:(int)timeout;


/// 获取群组的公开信息和私有信息，会检查用户是否在组内
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                  timeout:(int)timeout
                      tag:(id _Nullable)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                        timeout:(int)timeout;


/// 获取群组的公开信息
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                      timeout:(int)timeout
                          tag:(id _Nullable)tag
                      success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                            timeout:(int)timeout;




@end

NS_ASSUME_NONNULL_END
