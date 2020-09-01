
iOS RTM 使用文档 （集成+接口说明）
================================

* [版本支持](#版本支持)
* [集成依赖](#集成依赖)
* [代理方法](#代理方法)
* [校验登录](#校验登录)
* [单聊接口](#单聊接口)
* [群组接口](#群组接口)//加入状态会持久化
* [房间接口](#房间接口)//加入状态不会持久化，每次需要加入房间
* [广播接口](#广播接口)
* [文件接口](#文件接口)
* [好友接口](#好友接口)
* [用户接口](#用户接口)
* [加密接口](#加密接口)
* [翻译接口](#翻译接口)
* [debug日志，设备相关操作接口](#debug日志，设备相关操作接口)
* [chat单聊接口](#chat单聊接口)//是对单聊部分接口的二次封装 (固定mtype)
* [chat群组接口](#chat群组接口)//是对群组部分接口的二次封装 (固定mtype)
* [chat房间接口](#chat房间接口)//是对房间部分接口的二次封装 (固定mtype)
* [chat广播接口](#chat广播接口)//是对广播部分接口的二次封装 (固定mtype)
* [录音播放相关接口](#录音播放相关接口)

<a id="版本支持">版本支持</a>
================
* 语言:Objective-C  
* 最低支持 iOS8 系统
* 包含 armv7 armv7s arm64 i386  x86_64 指令集, 可运行真机 + 模拟器





<a id="集成依赖">集成依赖</a>
================
* 导入SDK 引入头文件 #import <Rtm/Rtm.h>
* 拖入文件夹 RTMAudioManager
* 在TARGETS->Build Settings->Other Linker Flags （选中ALL视图）中添加-ObjC，字母O和C大写，符号“-”请勿忽略
* 静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)
* 添加库libresolv.9.tbd
* Info.plist 添加麦克风权限 Privacy - Microphone Usage Description




<a id="代理方法">代理方法</a>
================


* 引入协议 RTMProtocol
* 设置 client.delegate = self;
    
```objc

@required
//重连将要开始
-(BOOL)rtmReloginWillStart:(RTMClient *)client reloginCount:(int)reloginCount;

//重连结果
-(void)rtmReloginCompleted:(RTMClient *)client reloginCount:(int)reloginCount reloginResult:(BOOL)reloginResult error:(FPNError*)error;


@optional

//关闭连接回调
-(void)rtmConnectClose:(RTMClient *)client;

//被踢下线
-(void)rtmKickout:(RTMClient *)client;

//房间踢出
-(void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
//Binary
-(void)rtmPushP2PBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//message
-(void)rtmPushP2PMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//file
-(void)rtmPushP2PFile:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupFile:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomFile:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastFile:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//chat message
-(void)rtmPushP2PChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//chat audio
-(void)rtmPushP2PChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//chat cmd
-(void)rtmPushP2PChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;

```






<a id="校验登录">校验登录</a>
================
```objc
#import <Rtm/Rtm.h>

//初始化
self.client = [RTMClient clientWithEndpoint:
                                  projectId:
                                     userId:
                                   delegate:
                                     config:
                                 autoRelogin:];
//登录
 if (self.client) {
 
    [self.client loginWithToken:
                       language:
                      attribute:
                        timeout:
                        success:^{
                                       
                    
                } connectFail:^(FPNError * _Nullable error) {
                    
                    
                    
                }];
                
            
}
            
```




 
<a id="单聊接口">单聊接口</a>
================

```objc
/// 发送P2P消息 
/// @param userId int64 接收人id
/// @param messageType int8 消息类型 请使用51-127
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                  messageType:(NSNumber * _Nonnull)messageType
                      message:(NSString * _Nonnull)message
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(int64_t mtime))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;



/// 发送P2P消息
/// @param userId int64 接收人id
/// @param messageType int8 消息类型 请使用51-127
/// @param data 消息内容 二进制数据
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                  messageType:(NSNumber * _Nonnull)messageType
                         data:(NSData * _Nonnull)data
                        attrs:(NSString * _Nonnull)attrs
                      timeout:(int)timeout
                      success:(void(^)(int64_t mtime))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;

                          
                          
                          
/// 获取历史P2P消息（包括自己发送的消息）
/// @param userId int64 获取和哪个uid之间的历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
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
                              success:(void(^)(RTMHistory* _Nullable history))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;

/// 删除消息 p2p
/// @param messageId int64 消息id
/// @param fromUserId int64
/// @param toUserId int64
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                       fromUserId:(NSNumber * _Nonnull)fromUserId
                         toUserId:(NSNumber * _Nonnull)toUserId
                          timeout:(int)timeout
                          success:(void(^)(void))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
                             
                             
                             
/// 获取消息 p2p
/// @param messageId int64 消息id
/// @param fromUserId int64 发送者
/// @param toUserId int64 接收者
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getP2pMessageWithId:(NSNumber * _Nonnull)messageId
                fromUserId:(NSNumber * _Nonnull)fromUserId
                  toUserId:(NSNumber * _Nonnull)toUserId
                   timeout:(int)timeout
                   success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;    
                      
                      
                      
/// 语音识别 （调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s，此接口只支持通过rtm发送的语音消息，无需把原始语音再一次发送，节省流量
/// @param messageId int64 消息ID
/// @param fromUserId int64 发送者ID
/// @param toUserId int64 接收者ID
/// @param profanityFilter 敏感词过滤
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)stranscribeP2pWithId:(NSNumber * _Nonnull)messageId
                 fromUserId:(NSNumber * _Nonnull)fromUserId
                   toUserId:(NSNumber * _Nonnull)toUserId
            profanityFilter:(BOOL)profanityFilter
                    timeout:(int)timeout
                    success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
                       
                       
```





<a id="群组接口">群组接口</a>
================
```objc

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
                      success:(void(^)(int64_t mtime))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;




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
                            success:(void(^)(int64_t mtime))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback;




/// 获取group历史消息
/// @param groupId int64 获取group历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
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



/// 获取group中的所有member
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                     success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;



/// 获取用户在哪些组里
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserGroupsWithTimeout:(int)timeout
                        success:(void(^)(NSArray * _Nullable groupArray))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;

                                 


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



/// 获取群组的公开信息和私有信息，会检查用户是否在组内
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                  timeout:(int)timeout
                  success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;



/// 获取群组的公开信息
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                      timeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;




/// 语音识别 （调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s，此接口只支持通过rtm发送的语音消息，无需把原始语音再一次发送，节省流量
/// @param messageId int64 消息ID
/// @param fromUserId int64 发送者ID
/// @param toGroupId int64 群ID
/// @param profanityFilter 敏感词过滤
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)stranscribeGroupWithId:(NSNumber * _Nonnull)messageId
                   fromUserId:(NSNumber * _Nonnull)fromUserId
                    toGroupId:(NSNumber * _Nonnull)toGroupId
              profanityFilter:(BOOL)profanityFilter
                      timeout:(int)timeout
                      success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;


```
<a id="房间接口">房间接口</a>
================

```objc

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
                     success:(void(^)(int64_t mtime))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;



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
                           success:(void(^)(int64_t mtime))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;



/// 获取room历史消息
/// @param roomId 房间id
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
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



/// 进入某个房间或者频道
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)enterRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;





/// 离开某个房间或者频道（不会持久化）
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)leaveRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;





/// 获取用户当前所在的所有房间
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserAtRoomsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable roomArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;






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





/// 获取房间的公开信息和私有信息，会检查用户是否在房间内
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                 timeout:(int)timeout
                 success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;




/// 获取房间的公开信息
/// @param roomId int64 房间频道id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                     timeout:(int)timeout
                     success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;





/// 语音识别 （调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s，此接口只支持通过rtm发送的语音消息，无需把原始语音再一次发送，节省流量
/// @param messageId int64 消息ID
/// @param fromUserId int64 发送者ID
/// @param toRoomId int64 房间ID
/// @param profanityFilter 敏感词过滤
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)stranscribeRoomWithId:(NSNumber * _Nonnull)messageId
                  fromUserId:(NSNumber * _Nonnull)fromUserId
                    toRoomId:(NSNumber * _Nonnull)toRoomId
             profanityFilter:(BOOL)profanityFilter
                     timeout:(int)timeout
                     success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;



                           
```   

<a id="广播接口">广播接口</a>
================


```objc

/// 获取广播历史消息
/// @param num int16 条数
/// @param desc 是否降序排列
/// @param begin int64
/// @param end int64
/// @param lastid int64
/// @param mtypes [int8] 消息类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                    desc:(BOOL)desc
                                   begin:(NSNumber * _Nullable)begin
                                     end:(NSNumber * _Nullable)end
                                  lastid:(NSNumber * _Nullable)lastid
                                  mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                 timeout:(int)timeout
                                 success:(void(^)(RTMHistory* _Nullable history))successCallback
                                    fail:(RTMAnswerFailCallBack)failCallback;




/// 获取消息
/// @param messageId int64 消息id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 成功回调
-(void)getBroadCastMessageWithId:(NSNumber * _Nonnull)messageId
                         timeout:(int)timeout
                         success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;



/// 语音识别 （调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s，此接口只支持通过rtm发送的语音消息，无需把原始语音再一次发送，节省流量
/// @param messageId int64 消息ID
/// @param fromUserId int64 发送者ID
/// @param profanityFilter 敏感词过滤
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)stranscribeBroadcastWithId:(NSNumber * _Nonnull)messageId
                       fromUserId:(NSNumber * _Nonnull)fromUserId
                  profanityFilter:(BOOL)profanityFilter
                          timeout:(int)timeout
                          success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;


```
<a id="文件接口">文件接口</a>
================                           
```objc

/// p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
/// @param userId 发给谁
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nonnull)fileData
                fileName:(NSString * _Nonnull)fileName
              fileSuffix:(NSString * _Nonnull)fileSuffix
                fileType:(RTMFileType)fileType
                 timeout:(int)timeout
                 success:(void(^)(int64_t mtime))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;

/// group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
/// @param groupId 群组id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                   fileData:(NSData * _Nonnull)fileData
                   fileName:(NSString * _Nonnull)fileName
                 fileSuffix:(NSString * _Nonnull)fileSuffix
                   fileType:(RTMFileType)fileType
                    timeout:(int)timeout
                    success:(void(^)(int64_t mtime))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;

/// room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频
/// @param roomId 房间id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nonnull)fileData
                 fileName:(NSString * _Nonnull)fileName
               fileSuffix:(NSString * _Nonnull)fileSuffix
                 fileType:(RTMFileType)fileType
                  timeout:(int)timeout
                  success:(void(^)(int64_t mtime))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
                     
                     
```

<a id="好友接口">好友接口</a>
================                           
```objc

/// 添加好友，每次最多添加100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;



/// 删除好友，每次最多删除100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;



/// 获取好友
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserFriendsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;



/// 添加黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;

   

/// 解除黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;




/// 拉取黑名单
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBlacklistWithTimeout:(int)timeout
                       success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;


```

<a id="用户接口">用户接口</a>
================                           
```objc


/// 客户端主动断开
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)offLineWithTimeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;



/// 踢掉一个链接（只对多用户登录有效，不能踢掉自己，可以用来实现同类设备，只容许一个登录）
/// @param endPoint  链接的endpoint，可以通过调用 getAttrsWithTimeout 获取
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                   timeout:(int)timeout
                   success:(void(^)(void))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;



/// 添加key_value形式的变量（例如设置客户端信息，会保存在当前链接中，客户端可以获取到）
/// @param attrs 注意 key value 为 nsstring
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;



/// 获取attrs
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getAttrsWithTimeout:(int)timeout
                   success:(void(^)(RTMAttriAnswer * _Nullable attri))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;



/// 检测离线聊天  只有通过Chat类接口 才会产生
/// @param clear yes 获取并清除离线提醒
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUnreadMessagesWithClear:(BOOL)clear
                          timeout:(int)timeout
                          success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;



/// 清除离线聊天提醒
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)cleanUnreadMessagesWithTimeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;



/// 获取所有聊天的会话（p2p用户和自己也会产生会话）
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getAllSessionsWithTimeout:(int)timeout
                         success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;



/// 获取在线用户列表，限制每次最多获取200个
/// @param userIds [int64] 用户id 数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getOnlineUsers:(NSArray <NSNumber* >* _Nonnull)userIds
              timeout:(int)timeout
              success:(void(^)(NSArray * _Nullable uidArray))successCallback
                 fail:(RTMAnswerFailCallBack)failCallback;




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



/// 获取用户自己的公开信息和私有信息
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserInfoWithTimeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;




/// 获取其他用户的公开信息，每次最多获取100人
/// @param userIds [int64] 用户id 数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserOpenInfo:(NSArray <NSNumber* > * _Nullable)userIds
               timeout:(int)timeout
               success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;





/// 获取存储的数据信息(key:最长128字节)
/// @param key 数据信息key
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserValueInfoWithKey:(NSString * _Nullable)key
                       timeout:(int)timeout
                       success:(void(^)(RTMInfoAnswer * _Nullable valueInfo))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;





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


/// 删除存储的数据信息
/// @param key 数据信息key
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteUserDataWithKey:(NSString * _Nonnull)key
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;




```

<a id="加密接口">加密接口</a>
================                           
```objc


- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

                
                     
```

<a id="翻译接口">翻译接口</a>
================                           
```objc

/// 设置当前用户需要的翻译语言
/// @param language 对应语言
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)setLanguage:(NSString * _Nonnull)language
           timeout:(int)timeout
           success:(void(^)(void))successCallback
              fail:(RTMAnswerFailCallBack)failCallback;



/// 翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）
/// @param translateText 翻译文本
/// @param originalLanguage 原语言类型 
/// @param targetLanguage 目标语言类型
/// @param type 可选值为chat或mail。如未指定，则默认使用chat
/// @param profanity 敏感词过滤   默认：off  stop: 返回错误，censor: 用星号(*)替换敏感词
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)translateText:(NSString * _Nonnull)translateText
    originalLanguage:(NSString * _Nullable)originalLanguage
      targetLanguage:(NSString * _Nonnull)targetLanguage
                type:(NSString * _Nullable)type
           profanity:(NSString * _Nullable)profanity
             timeout:(int)timeout
             success:(void(^)(RTMTranslatedInfo * _Nullable translatedInfo))successCallback
                fail:(RTMAnswerFailCallBack)failCallback;




/// 敏感词过滤, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本检测系统）
/// @param profanityText 翻译文本
/// @param classify 是否进行文本分类检测
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)textProfanity:(NSString * _Nonnull)profanityText
            classify:(BOOL)classify
             timeout:(int)timeout
             success:(void(^)(RTMTextProfanityAnswer * _Nullable textProfanity))successCallback
                fail:(RTMAnswerFailCallBack)failCallback;



/// 语音识别（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s
/// @param audioFilePath 语音文件路径
/// @param lang 当前语音的语言
/// @param duration 音频长度 毫秒
/// @param profanityFilter 文本过滤
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)speechRecognition:(NSString * _Nonnull)audioFilePath
                    lang:(NSString * _Nullable)lang
                duration:(long long)duration
         profanityFilter:(BOOL)profanityFilter
                 timeout:(int)timeout
                 success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable textProfanity))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;










```

<a id="debug日志，设备相关操作接口">debug日志，设备相关操作接口</a>
================                           
```objc


/// 添加debug日志
/// @param msg msg
/// @param attrs 属性
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDebugLogWithMsg:(NSString * _Nonnull)msg
                    attrs:(NSString * _Nonnull)attrs
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;



/// 添加设备，应用信息
/// @param apptype app类型
/// @param deviceToken token
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDeviceWithApptype:(NSString * _Nonnull)apptype
                deviceToken:(NSString * _Nonnull)deviceToken
                    timeout:(int)timeout
                    success:(void(^)(void))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;



/// 删除设备，应用信息，解除绑定的意思
/// @param deviceToken token
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;


```


<a id="chat单聊接口">chat单聊接口</a>
================                           
```objc

/// 发送P2P消息 对 sendP2PMessageWithId 的封装 mtype=30
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取 会产生聊天会话 通过getAllSessionsWithTimeout获取
/// @param userId int64 接收人id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(int64_t mtime))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout;




/// 发送音频消息 对 sendP2PMessageWithId 的封装 mtype=31
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取 会产生聊天会话 通过getAllSessionsWithTimeout获取
/// 对音频大小有限制
/// @param userId int64
/// @param audioFilePath 音频数据路径  音频要求 16KHZ 16位 单声道 
/// @param attrs 属性
/// @param lang 音频语言
/// @param duration 音频时长 毫秒 必传
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                    audioFilePath:(NSString * _Nonnull)audioFilePath
                            attrs:(NSDictionary * _Nullable)attrs
                             lang:(NSString * _Nonnull)lang
                         duration:(long long)duration
                          timeout:(int)timeout
                          success:(void(^)(int64_t mtime))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                    audioFilePath:(NSString * _Nonnull)audioFilePath
                            attrs:(NSDictionary * _Nullable)attrs
                             lang:(NSString * _Nonnull)lang
                         duration:(long long)duration
                          timeout:(int)timeout;







/// 发送系统命令 对 sendP2PMessageWithId 的封装 mtype=32
/// 会产生离线提醒 通过getUnreadMessagesWithClear获取
/// 系统命令(或者需要离线提醒的消息)，比如：组队邀请,申请入群,拒绝申请入群,邀请入群,拒绝邀请入群,加好友,删除好友,其他等和聊天相关的命令
/// @param userId int64 接收人id
/// @param message 消息内容
/// @param attrs 属性 建议使用可解析的json字符串
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(int64_t mtime))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout;


/// 获取历史P2P消息 对 getP2PHistoryMessageWithUserId 的封装 mtypes = [30,31,32,40,41,42] （只包含sendP2PMessageChatWithId，sendAudioMessageChatWithId，sendCmdMessageChatWithId产生的历史消息）
/// @param userId int64 获取和哪个uid之间的历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getP2PHistoryMessageChatWithUserId:(NSNumber * _Nonnull)userId
                                     desc:(BOOL)desc
                                      num:(NSNumber * _Nonnull)num
                                    begin:(NSNumber * _Nullable)begin
                                      end:(NSNumber * _Nullable)end
                                   lastid:(NSNumber * _Nullable)lastid
                                  timeout:(int)timeout
                                  success:(void(^)(RTMHistory* _Nullable history))successCallback
                                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getP2PHistoryMessageChatWithUserId:(NSNumber * _Nonnull)userId
                                                         desc:(BOOL)desc
                                                          num:(NSNumber * _Nonnull)num
                                                        begin:(NSNumber * _Nullable)begin
                                                          end:(NSNumber * _Nullable)end
                                                       lastid:(NSNumber * _Nullable)lastid
                                                      timeout:(int)timeout;



```
<a id="chat群组接口">chat群组接口</a>
================                           
```objc

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
                          success:(void(^)(int64_t mtime))successCallback
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
                               success:(void(^)(int64_t mtime))successCallback
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
                             success:(void(^)(int64_t mtime))successCallback
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

```

<a id="chat房间接口">chat房间接口</a>
================                           
```objc
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
                         success:(void(^)(int64_t mtime))successCallback
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
                              success:(void(^)(int64_t mtime))successCallback
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
                            success:(void(^)(int64_t mtime))successCallback
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

```

<a id="chat广播接口">chat广播接口</a>
================                           
```objc
/// 获取广播历史消息  对 getBroadCastHistoryMessageWithNum 的封装 mtypes = [30,31,32,40,41,42]
/// @param num int16 条数
/// @param desc 是否降序排列
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                        desc:(BOOL)desc
                                       begin:(NSNumber * _Nullable)begin
                                         end:(NSNumber * _Nullable)end
                                      lastid:(NSNumber * _Nullable)lastid
                                     timeout:(int)timeout
                                     success:(void(^)(RTMHistory* _Nullable history))successCallback
                                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMHistoryMessageAnswer*)getBroadCastHistoryMessageChatWithNum:(NSNumber * _Nonnull)num
                                                            desc:(BOOL)desc
                                                           begin:(NSNumber * _Nullable)begin
                                                             end:(NSNumber * _Nullable)end
                                                          lastid:(NSNumber * _Nullable)lastid
                                                         timeout:(int)timeout;

```


<a id="录音播放相关接口">录音播放相关接口</a>
================                           
```objc
录音播放转换相关操作在demo有详细使用方式 
录音要求  1采样率16000.0    2采样位数16    3通道数1
传输格式为amr
请使用Sdk内的接口进行录音和相关播放

开始录音
-(void)startRecord;
结束录音
-(void)stopRecord:(void(^)(NSString * _Nullable amrAudioPath,NSString * _Nullable wavAudioPath,double durationTime))recorderFinish;              
播放录音                            
-(void)playWithData:(NSData*)audioData;//通过RTM SDK getMessage接口获取的binary音频消息
-(void)playWithWavPath:(NSString*)wavAudioPath;//对应结束录音返回路径
-(void)playWithAmrPath:(NSString*)amrAudioPath;//对应结束录音返回路径                      
停止播放
-(void)stop;


```



