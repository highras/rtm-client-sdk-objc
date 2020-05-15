//
//  RTMClient+PtoP.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (P2P)

/// 发送P2P消息 不会产生聊天 会话 离线等记录 如果需要请使用chat类接口
/// @param userId int64 接收人id
/// @param messageType int8 消息类型 请使用51-127
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PMessageWithId:(NSNumber * _Nonnull)userId
                messageType:(NSNumber * _Nonnull)messageType
                    message:(NSString * _Nonnull)message
                      attrs:(NSString * _Nonnull)attrs
                    timeout:(int)timeout
                        tag:(id _Nullable)tag
                    success:(RTMAnswerSuccessCallBack)successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)sendP2PMessageWithId:(NSNumber * _Nonnull)userId
                      messageType:(NSNumber * _Nonnull)messageType
                          message:(NSString * _Nonnull)message
                            attrs:(NSString * _Nonnull)attrs
                          timeout:(int)timeout;


/// 发送P2P消息 不会产生聊天 会话 离线等记录 如果需要请使用chat类接口
/// @param userId int64 接收人id
/// @param messageType int8 消息类型 请使用51-127
/// @param data 消息内容 二进制数据
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PBinaryMessageWithId:(NSNumber * _Nonnull)userId
                      messageType:(NSNumber * _Nonnull)messageType
                             data:(NSData * _Nonnull)data
                            attrs:(NSString * _Nonnull)attrs
                          timeout:(int)timeout
                              tag:(id _Nullable)tag
                          success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)sendP2PBinaryMessageWithId:(NSNumber * _Nonnull)userId
                            messageType:(NSNumber * _Nonnull)messageType
                                   data:(NSData * _Nonnull)data
                                  attrs:(NSString * _Nonnull)attrs
                                timeout:(int)timeout;




/// 获取历史P2P消息（包括自己发送的消息）
/// @param userId int64 获取和哪个uid之间的历史消息
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
-(void)getP2PHistoryMessageWithUserId:(NSNumber * _Nonnull)userId
                                 desc:(BOOL)desc
                                  num:(NSNumber * _Nonnull)num
                                begin:(NSNumber * _Nullable)begin
                                  end:(NSNumber * _Nullable)end
                               lastid:(NSNumber * _Nullable)lastid
                               mtypes:(NSArray <NSNumber *> * _Nullable)mtypes
                              timeout:(int)timeout
                                  tag:(id _Nullable)tag
                              success:(RTMAnswerSuccessCallBack)successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getP2PHistoryMessageWithUserId:(NSNumber * _Nonnull)userId
                                       desc:(BOOL)desc
                                        num:(NSNumber * _Nonnull)num
                                      begin:(NSNumber * _Nullable)begin
                                        end:(NSNumber * _Nullable)end
                                     lastid:(NSNumber * _Nullable)lastid
                                     mtypes:(NSArray <NSNumber *> * _Nullable)mtypes
                                    timeout:(int)timeout;




/// 删除消息 p2p
/// @param messageId int64 消息id
/// @param userId int64 和哪个用户产生的消息
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                           userId:(NSNumber * _Nonnull)userId
                          timeout:(int)timeout
                              tag:(id _Nullable)tag
                          success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                                 userId:(NSNumber * _Nonnull)userId
                                timeout:(int)timeout;




/// 获取消息
/// @param messageId int64 消息id
/// @param userId int64 和哪个用户产生的消息
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getMessageWithMessageId:(NSNumber * _Nonnull)messageId
                        userId:(NSNumber * _Nonnull)userId
                       timeout:(int)timeout
                           tag:(id _Nullable)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAnswer*)getMessageWithMessageId:(NSNumber * _Nonnull)messageId
                              userId:(NSNumber * _Nonnull)userId
                             timeout:(int)timeout;





@end

NS_ASSUME_NONNULL_END
