
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
* [chat单聊接口](#chat单聊接口)//是对单聊部分接口的二次封装 (固定mtype) 会产生历史消息和未读
* [chat群组接口](#chat群组接口)//是对群组部分接口的二次封装 (固定mtype) 会产生历史消息和未读
* [chat房间接口](#chat房间接口)//是对房间部分接口的二次封装 (固定mtype) 会产生历史消息和未读
* [chat广播接口](#chat广播接口)//是对广播部分接口的二次封装 (固定mtype) 会产生历史消息和未读
* [录音播放相关接口](#录音播放相关接口)

<a id="版本支持">版本支持</a>
================
* 语言:Objective-C  
* 最低支持 iOS9 系统



<a id="集成依赖">集成依赖</a>
================
* 导入SDK 引入头文件 #import <Rtm/Rtm.h>
* 拖入文件夹 RTMAudioManager
* 在TARGETS->Build Settings->Other Linker Flags （选中ALL视图）中添加-ObjC，字母O和C大写，符号“-”请勿忽略
* 静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)
* 添加库libresolv.9.tbd




<a id="代理方法">代理方法</a>
================


* 引入协议 RTMProtocol
* 设置 client.delegate = self;
    
```objc

@required
//重连只有在登录成功过1次后才会有效
//重连将要开始
-(BOOL)rtmReloginWillStart:(RTMClient *)client reloginCount:(int)reloginCount;

//重连结果
-(void)rtmReloginCompleted:(RTMClient *)client reloginCount:(int)reloginCount reloginResult:(BOOL)reloginResult error:(FPNError*)error;


@optional

//关闭连接
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
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
                             messageType:(NSNumber * _Nonnull)messageType
                                 message:(NSString * _Nonnull)message
                                   attrs:(NSString * _Nonnull)attrs
                                 timeout:(int)timeout;


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
                      success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendP2PMessageToUserId:(NSNumber * _Nonnull)userId
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
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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
-(RTMHistoryMessageAnswer*)getP2PHistoryMessageWithUserId:(NSNumber * _Nonnull)userId
                                                     desc:(BOOL)desc
                                                      num:(NSNumber * _Nonnull)num
                                                    begin:(NSNumber * _Nullable)begin
                                                      end:(NSNumber * _Nullable)end
                                                   lastid:(NSNumber * _Nullable)lastid
                                                   mtypes:(NSArray <NSNumber *> * _Nullable)mtypes
                                                  timeout:(int)timeout;


/// 检测p2p离线聊天数目  只要是设置为保存的消息，均可获取未读。不限于 chat、cmd、file。
/// @param userIds int64 用户集合
/// @param mtime 毫秒级时间戳，获取这个时间戳之后的未读消息，如果mtime 为空，则获取上一次logout后的未读消息
/// @param messageTypes int 消息类型集合 (如果不传默认所有聊天相关消息类型，不包含自定义的type)
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调

-(void)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
                         mtime:(int64_t)mtime
                  messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                       timeout:(int)timeout
                       success:(void(^)(RTMUnreadAnswer *_Nullable history))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMUnreadAnswer * _Nullable)getP2pUnreadWithUserIds:(NSArray<NSNumber*> * _Nonnull)userIds
                                                mtime:(int64_t)mtime
                                         messageTypes:(NSArray<NSNumber*> * _Nullable)messageTypes
                                              timeout:(int)timeout;


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
-(RTMBaseAnswer*)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                                 fromUserId:(NSNumber * _Nonnull)fromUserId
                                   toUserId:(NSNumber * _Nonnull)toUserId
                                    timeout:(int)timeout;




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
-(RTMGetMessageAnswer*)getP2pMessageWithId:(NSNumber * _Nonnull)messageId
                                fromUserId:(NSNumber * _Nonnull)fromUserId
                                  toUserId:(NSNumber * _Nonnull)toUserId
                                   timeout:(int)timeout;
                       
                       
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
-(RTMSendAnswer*)sendGroupMessageWithId:(NSNumber * _Nonnull)groupId
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


/// 获取group中的所有member
/// @param groupId int64 群组id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                     success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
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
-(RTMSendAnswer*)sendRoomMessageWithId:(NSNumber * _Nonnull)roomId
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



                           
```   

<a id="广播接口">广播接口</a>
================


```objc

/// 获取广播历史消息
/// @param num int16 条数
/// @param desc 是否降序排列
/// @param begin int64
/// @param end int64
/// @param lastid int64 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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
-(RTMHistoryMessageAnswer*)getBroadCastHistoryMessageWithNum:(NSNumber * _Nonnull)num
                                                        desc:(BOOL)desc
                                                       begin:(NSNumber * _Nullable)begin
                                                         end:(NSNumber * _Nullable)end
                                                      lastid:(NSNumber * _Nullable)lastid
                                                      mtypes:(NSArray <NSNumber* > * _Nullable)mtypes
                                                     timeout:(int)timeout;



/// 获取消息
/// @param messageId int64 消息id
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 成功回调
-(void)getBroadCastMessageWithId:(NSNumber * _Nonnull)messageId
                         timeout:(int)timeout
                         success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMGetMessageAnswer*)getBroadCastHistoryMessageWithId:(NSNumber * _Nonnull)messageId
                                                timeout:(int)timeout;


```
<a id="文件接口">文件接口</a>
================                           
```objc

/// p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param userId 发给谁
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nullable)fileData
                fileName:(NSString * _Nullable)fileName
              fileSuffix:(NSString * _Nullable)fileSuffix
                fileType:(RTMFileType)fileType
                   attrs:(NSDictionary * _Nullable)attrs
              audioModel:(RTMAudioModel * _Nullable)audioModel
                 timeout:(int)timeout
                 success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;


/// group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param groupId 群组ID
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                  fileData:(NSData * _Nullable)fileData
                  fileName:(NSString * _Nullable)fileName
                fileSuffix:(NSString * _Nullable)fileSuffix
                  fileType:(RTMFileType)fileType
                     attrs:(NSDictionary * _Nullable)attrs
                 audioModel:(RTMAudioModel * _Nullable)audioModel
                    timeout:(int)timeout
                    success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;


/// room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param roomId 房间Id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nullable)fileData
                 fileName:(NSString * _Nullable)fileName
               fileSuffix:(NSString * _Nullable)fileSuffix
                 fileType:(RTMFileType)fileType
                    attrs:(NSDictionary * _Nullable)attrs
               audioModel:(RTMAudioModel * _Nullable)audioModel
                  timeout:(int)timeout
                  success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
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
-(RTMBaseAnswer*)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                         timeout:(int)timeout;


/// 删除好友，每次最多删除100人
/// @param friendids [int64] 用户id数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                            timeout:(int)timeout;


/// 获取好友
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getUserFriendsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserFriendsWithTimeout:(int)timeout;


/// 添加黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                 timeout:(int)timeout;
   

/// 解除黑名单
/// @param friendids 用户ID数组
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                    timeout:(int)timeout;



/// 拉取黑名单
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getBlacklistWithTimeout:(int)timeout
                       success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getBlacklistWithTimeout:(int)timeout;


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

<a id="翻译，过滤等工具接口">翻译接口</a>
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
-(RTMBaseAnswer*)setLanguage:(NSString * _Nonnull)language
                 timeout:(int)timeout;


/// 翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）
/// @param translateText 翻译文本
/// @param originalLanguage 原语言类型 
/// @param targetLanguage 目标语言类型
/// @param type 可选值为chat或mail。如未指定，则默认使用chat
/// @param profanity 敏感词过滤   默认：off censor: 用星号(*)替换敏感词
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
-(RTMTranslatedInfoAnswer*)translateText:(NSString * _Nonnull)translateText
                        originalLanguage:(NSString * _Nullable)originalLanguage
                          targetLanguage:(NSString * _Nonnull)targetLanguage
                                    type:(NSString * _Nullable)type
                               profanity:(NSString * _Nullable)profanity
                                 timeout:(int)timeout;








/// 文本审核, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本审核系统）
/// @param text  需要过滤的文本
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)textReviewWithText:(NSString * _Nonnull)text
                  timeout:(int)timeout
                  success:(void(^)(RTMTextReviewAnswer * _Nullable textReview))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMTextReviewAnswer*)textReviewWithText:(NSString * _Nonnull)text
                                  timeout:(int)timeout;




/// 图片审核, （调用此接口需在管理系统启用图片审核系统）调用这个接口的超时时间得加大到120s
/// @param imageUrl 图片数据 imageUrl imageData 二选一  同时传imageData优先
/// @param imageData 图片数据 imageUrl imageData 二选一 同时传imageData优先
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)imageReviewWithSource:(NSString * _Nullable)imageUrl
                   imageData:(NSData * _Nullable)imageData
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable imageReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)imageReviewWithSource:(NSString * _Nullable)imageUrl
                               imageData:(NSData * _Nullable)imageData
                                 timeout:(int)timeout;


/// 音频审核, （调用此接口需在管理系统启用语音审核系统）调用这个接口的超时时间得加大到120s
/// @param audioUrl 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param audioData 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param lang 语言
/// @param codec 编解码 传空 默认AMR_WB
/// @param srate 采样率 传空 默认为16000
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)audioReviewWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString * _Nonnull)lang
                       codec:(NSString * _Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable audioReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)audioReviewWithSource:(NSString * _Nullable)audioUrl
                                         audioData:(NSData * _Nullable)audioData
                                              lang:(NSString * _Nonnull)lang
                                             codec:(NSString * _Nullable)codec
                                             srate:(int32_t)srate
                                           timeout:(int)timeout;


/// 视频审核, （调用此接口需在管理系统启用视频审核系统） 调用这个接口的超时时间得加大到120s
/// @param videoUrl 视频数据 videoUrl videoData二选一
/// @param videoData 视频数据 videoUrl videoData二选一
/// @param videoName 视频名字
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)videoReviewWithSource:(NSString * _Nullable)videoUrl
                   videoData:(NSData * _Nullable)videoData
                   videoName:(NSString * _Nonnull)videoName
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable videoReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)videoReviewWithSource:(NSString * _Nullable)videoUrl
                                         videoData:(NSData * _Nullable)videoData
                                         videoName:(NSString * _Nonnull)videoName
                                           timeout:(int)timeout;


/// 语音转文字（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s
/// @param audioUrl 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param audioData 音频数据 audioUrl audioData二选一 同时传audioData优先
/// @param lang 语言
/// @param codec 编解码 传空 默认AMR_WB
/// @param srate 采样率 传空 默认为16000
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                   audioData:(NSData * _Nullable)audioData
                        lang:(NSString *_Nonnull)lang
                       codec:(NSString *_Nullable)codec
                       srate:(int32_t)srate
                     timeout:(int)timeout
                     success:(void(^)(RTMSpeechRecognitionAnswer * _Nullable recognition))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSpeechRecognitionAnswer*)voiceToTextWithSource:(NSString * _Nullable)audioUrl
                                          audioData:(NSData * _Nullable)audioData
                                               lang:(NSString *_Nonnull)lang
                                              codec:(NSString *_Nullable)codec
                                              srate:(int32_t)srate
                                           timeout:(int)timeout;








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
/// @param appType app类型   iOS ：apns   android ：fcm
/// @param deviceToken token
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDeviceWithAppType:(NSString * _Nonnull)appType
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




/// 设置设备推送属性(注意此接口是设置个人或群组某个类型的type不推送的设置)
/// @param type type=0, 设置某个p2p 不推送    type=1, 设置某个group不推送
/// @param xid type=0,对应userId  type=1,对应groupId
/// @param mTypes 为空数组，则所有mtype均不推送;否则表示指定mtype不推送
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)addDevicePushOptionWithType:(int)type
                               xid:(int64_t)xid
                            mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                           timeout:(int)timeout
                           success:(void(^)(void))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;



/// 取消设备推送属性(和addDevicePushOptionWithType对应)
/// @param type  type=0, 设置某个p2p    type=1, 设置某个group
/// @param xid type=0,对应fromUserId  type=1,对应groupId
/// @param mTypes  需要取消设置的messagetype数组(如果为空数组表示什么都不做)
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)removeDevicePushOptionWithType:(int)type
                                  xid:(int64_t)xid
                               mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                              timeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;



/// 获取设备推送属性(addDevicePushOptionWithType的结果)
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)getDevicePushOptionWithTimeout:(int)timeout
                              success:(void(^)(RTMGetPushAttrsAnswer *answer))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;

```


<a id="chat单聊接口">chat单聊接口</a>
================                           
```objc

/// 发送P2P消息 对 sendP2PMessageWithId 的封装 mtype=30
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
                        success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout;








/// 发送系统命令 对 sendP2PMessageWithId 的封装 mtype=32
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
                        success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout;


/// 获取历史P2P消息 对 getP2PHistoryMessageWithUserId 的封装 mtypes = [30,32,40,41,42,50]
/// @param userId int64 获取和哪个uid之间的历史消息
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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
                          success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendGroupMessageChatWithId:(NSNumber * _Nonnull)groupId
                                    message:(NSString * _Nonnull)message
                                      attrs:(NSString * _Nonnull)attrs
                                    timeout:(int)timeout;








/// 发送系统命令 对 sendGroupMessageWithId 的封装 mtype=32
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


/// 获取历史group消息 对 getGroupHistoryMessageWithGroupId 的封装 mtypes = [30,32,40,41,42,50] 
/// @param groupId int64 
/// @param desc 是否降序排列
/// @param num int16 条数
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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
                         success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMSendAnswer*)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                                   message:(NSString * _Nonnull)message
                                     attrs:(NSString * _Nonnull)attrs
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

```

<a id="chat广播接口">chat广播接口</a>
================                           
```objc
/// 获取广播历史消息  对 getBroadCastHistoryMessageWithNum 的封装 mtypes = [30,32,40,41,42,50]
/// @param num int16 条数
/// @param desc 是否降序排列
/// @param begin int64 开始时间戳，精确到 毫秒
/// @param end int64 结束时间戳，精确到 毫秒
/// @param lastid int64 最后一条消息的id 对应RTMGetMessage RTMHistoryMessage 的 cursorId字段
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
-(void)startRecordWithLang:(NSString * _Nonnull)lang;
结束录音
-(void)stopRecord:(void(^)(RTMAudioModel * audioModel))recorderFinish;             
播放录音                            
-(void)playWithAudioModel:(RTMAudioModel*)audioModel;//audioFilePath is not nil
-(void)playWithAmrData:(NSData*)amrData;//通过音频url获取的二进制数据 amr格式                      
停止播放
-(void)stop;


```


