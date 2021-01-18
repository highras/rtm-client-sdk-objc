

iOS RTM Usage document (integration + interface description)
================================

* [version support](#versionsupport)
* [integration dependency](#integrationdependency)
* [delegate](#delegate)
* [verify login](#verifylogin)
* [p2p interface](#p2pinterface)
* [group interface](#groupinterface)//The join state is persistent
* [room interface](#roominterface)//The join state is not persistent and needs to be added to the room every time
* [broadcast interface](#broadcastinterface)
* [file interface](#fileinterface)
* [friend interface](#friendinterface)
* [user interface](#userinterface)
* [encryption interface](#encryptioninterface)
* [translate filter interface](#translatefilterinterface)
* [debug device interface](#debugdeviceinterface)
* [p2p chat interface](#p2pchatinterface)//p2p interface encapsulation (define mtype) Historical messages and unread are generated
* [group chat interface](#groupchatinterface)//group interface encapsulation ( define mtype) Historical messages and unread are generated
* [room chat interface](#roomchatinterface)//room interface encapsulation (define mtype) Historical messages and unread are generated
* [broadcast chat interface](#broadcastchatinterface)//broadcast interface encapsulation (define mtype) Historical messages and unread are generated
* [audio record and play interface](#audiorecordandplayinterface)

<a id="versionsupport">version support</a>
================
* language:Objective-C  
* minimum system iOS 9 



<a id="integrationdependency">integration dependency</a>
================
* import SDK and #import <Rtm/Rtm.h>
* import folder RTMAudioManager
* TARGETS->Build Settings->Other Linker Flags add "-ObjC"
* SDK use Objective-C++，need to add .mm file (any one .m file to .mm)
* add libresolv.9.tbd




<a id="delegate">delegate</a>
================


* import RTMProtocol
* client.delegate = self;
    
```objc

@required
//reconnection is valid only after one successful login
//reconnection is will begin
-(BOOL)rtmReloginWillStart:(RTMClient *)client reloginCount:(int)reloginCount;

//reconnection result
-(void)rtmReloginCompleted:(RTMClient *)client reloginCount:(int)reloginCount reloginResult:(BOOL)reloginResult error:(FPNError*)error;


@optional

//close connect
-(void)rtmConnectClose:(RTMClient *)client;

//kickout offline
-(void)rtmKickout:(RTMClient *)client;

//kickout room
-(void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//binary
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






<a id="verifylogin">verify login</a>
================
```objc
#import <Rtm/Rtm.h>

//init
self.client = [RTMClient clientWithEndpoint:
                                  projectId:
                                     userId:
                                   delegate:
                                     config:
                                 autoRelogin:];
//login
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




 
<a id="p2pinterface">p2p interface</a>
================

```objc
/// send p2p msg 
/// @param userId int64 Recipient ID
/// @param messageType int8 Please use 51-127 for message type
/// @param message msg content 
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
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


/// send p2p binary
/// @param messageType int8 Please use 51-127 for message type
/// @param message msg content
/// @param data Message content binary data
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// get history msg（include myself）
/// @param userId int64 Get the historical message between which uid and which.
/// @param desc Descending order
/// @param num int16 msg numbers
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message.  Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param mtypes [int8] msg types
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// Detect the number of P2P offline chats, as long as it is set to save the message, can get unread. Not limited to chat、cmd、file。
/// @param userIds int64 
/// @param mtime Millisecond timestamps to get the unread messages after this timestamp. If mtime is empty, the unread messages after the last logout are obtained
/// @param messageTypes int Message type collection (if all the default chat related message types are not transmitted, the custom type is not included)
/// @param timeout   Request timeout seconds
/// @param successCallback
/// @param failCallback 

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



/// delete p2p msg
/// @param messageId int64 messageId
/// @param fromUserId int64 sender
/// @param toUserId int64 recipient
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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




/// get p2p msg
/// @param messageId int64 messageId
/// @param fromUserId int64 sender
/// @param toUserId int64 recipient
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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





<a id="groupinterface">group interface</a>
================
```objc

/// send group msg
/// @param groupId int64 groupid
/// @param messageType int64 Please use 51-127 for message type
/// @param message Message content
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// send group binary 
/// @param groupId int64 groupid
/// @param messageType int64 Please use 51-127 for message type
/// @param data Message content binary data
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// get group history msg
/// @param groupId int64 
/// @param desc Descending order
/// @param num int16 msg numbers
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message. Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param mtypes [int8] Message type
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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

/// delete group
/// @param messageId int64 
/// @param groupId int64
/// @param fromUserId int64
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// get group msg
/// @param messageId int64 
/// @param groupId int64 
/// @param fromUserId sender
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// add group member，every time max is 100
/// @param groupId int64 
/// @param membersId [int64] user ids
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                   membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addGroupMembersWithId:(NSNumber * _Nonnull)groupId
                             membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                               timeout:(int)timeout;

/// delete group member，every time max is 100
/// @param groupId int64 
/// @param membersId [int64] user ids
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                      membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                        timeout:(int)timeout
                        success:(void(^)(void))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                membersId:(NSArray <NSNumber* >* _Nonnull)membersId
                                  timeout:(int)timeout;


/// get all group member
/// @param groupId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                     timeout:(int)timeout
                     success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getGroupMembersWithId:(NSNumber * _Nonnull)groupId
                                 timeout:(int)timeout;


/// get user in which groups 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserGroupsWithTimeout:(int)timeout
                        success:(void(^)(NSArray * _Nullable groupArray))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserGroupsWithTimeout:(int)timeout;
                                 


/// set group openInfo and privateInfo.  check whether the user is in the group (openInfo,privateInfo 最长 65535)
/// @param groupId int64 
/// @param openInfo  
/// @param privateInfo 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// get the open and private information of the group will check whether the user is in the group
/// @param groupId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                  timeout:(int)timeout
                  success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getGroupInfoWithId:(NSNumber * _Nonnull)groupId
                            timeout:(int)timeout;


/// get group open info
/// @param groupId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                      timeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getGroupOpenInfoWithId:(NSNumber * _Nonnull)groupId
                                timeout:(int)timeout;



/// get groups open info
/// @param groupIds int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                      timeout:(int)timeout
                      success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getGroupsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)groupIds
                                  timeout:(int)timeout;


```
<a id="roominterface">room interface</a>
================

```objc

/// send room msg
/// @param roomId int64 
/// @param messageType int8 Please use 51-127 for message type
/// @param message Message content
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
 
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



/// send room binary
/// @param roomId int64 
/// @param messageType int8 Please use 51-127 for message type
/// @param data binary data
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
 
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



/// get room history msg
/// @param roomId 
/// @param desc Descending order
/// @param num int16 msg numbers
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message. Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param mtypes [int8] Message types
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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





///// delete room msg
///// @param messageId int64 
///// @param roomId int64
///// @param fromUserId int64
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// get room msg
/// @param messageId int64 
/// @param roomId int64 
/// @param fromUserId int64 sender
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// join room （no persistence）
/// @param roomId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)enterRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)enterRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout;




/// leave room  (no persistence）
/// @param roomId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)leaveRoomWithId:(NSNumber * _Nonnull)roomId
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)leaveRoomWithId:(NSNumber * _Nonnull)roomId
                         timeout:(int)timeout;




/// get all the rooms the user is currently in
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserAtRoomsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable roomArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserAtRoomsWithTimeout:(int)timeout;


/// Get all members in the room
/// @param roomId int64
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
-(void)getRoomMembersWithId:(NSNumber * _Nonnull)roomId
                    timeout:(int)timeout
                    success:(void(^)(NSArray * _Nullable userIdArray))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getRoomMembersWithId:(NSNumber * _Nonnull)roomId
                                timeout:(int)timeout;





/// Gets the number of users in the room
/// @param roomIds int64
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
-(void)getRoomMemberCountWithId:(NSArray <NSNumber*>* _Nonnull)roomIds
                        timeout:(int)timeout
                        success:(void(^)(RTMRoomMemberCountAnswer * answer))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback;
-(RTMRoomMemberCountAnswer*)getRoomMemberCountWithId:(NSArray <NSNumber*>*)roomIds
                                             timeout:(int)timeout;


/// set the open or private information of the room will check whether the user is in the room (openInfo,privateInfo 最长 65535)
/// @param roomId int64 
/// @param openInfo
/// @param privateInfo 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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




/// get open and private information of the room will check whether the user is in the room
/// @param roomId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                 timeout:(int)timeout
                 success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getRoomInfoWithId:(NSNumber * _Nonnull)roomId
                           timeout:(int)timeout;



/// get room open info
/// @param roomId int64 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                     timeout:(int)timeout
                     success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getRoomOpenInfoWithId:(NSNumber * _Nonnull)roomId
                               timeout:(int)timeout;


/// get rooms open info
/// @param roomIds int64
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getRoomsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)roomIds
                        timeout:(int)timeout
                        success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getRoomsOpenInfoWithId:(NSArray <NSNumber* > * _Nullable)roomIds
                                  timeout:(int)timeout;



                           
```   

<a id="broadcastinterface">broadcast interface</a>
================


```objc

/// get broadcast history msg
/// @param num int16 
/// @param desc Descending order
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message. Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param mtypes [int8] Message types
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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



/// get broadcast msg
/// @param messageId 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getBroadCastMessageWithId:(NSNumber * _Nonnull)messageId
                         timeout:(int)timeout
                         success:(void(^)(RTMGetMessage * _Nullable message))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMGetMessageAnswer*)getBroadCastHistoryMessageWithId:(NSNumber * _Nonnull)messageId
                                                timeout:(int)timeout;


```
<a id="fileinterface">file interface</a>
================                           
```objc

/// p2p send file mtype=40image  mtype=41audio  mtype=42video   mtype=50other
/// If the AudioModel is valid, the audio message will be sent. If the AudioModel is invalid, the filedata filename filesuffix filetype is required to send the regular file
/// @param userId recipient
/// @param fileData 
/// @param fileName 
/// @param fileSuffix 
/// @param fileType 
/// @param attrs 
/// @param audioModel 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nonnull)fileData
                fileName:(NSString * _Nonnull)fileName
              fileSuffix:(NSString * _Nonnull)fileSuffix
                fileType:(RTMFileType)fileType
                   attrs:(NSDictionary * _Nullable)attrs
              audioModel:(RTMAudioModel * _Nullable)audioModel
                 timeout:(int)timeout
                 success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;

/// group send file mtype=40image  mtype=41audio  mtype=42video   mtype=50other
/// If the AudioModel is valid, the audio message will be sent. If the AudioModel is invalid, the filedata filename filesuffix filetype is required to send the regular file
/// @param groupId 
/// @param fileData 
/// @param fileName 
/// @param fileSuffix 
/// @param fileType 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                   fileData:(NSData * _Nonnull)fileData
                   fileName:(NSString * _Nonnull)fileName
                 fileSuffix:(NSString * _Nonnull)fileSuffix
                   fileType:(RTMFileType)fileType
                      attrs:(NSDictionary * _Nullable)attrs
                 audioModel:(RTMAudioModel * _Nullable)audioModel
                    timeout:(int)timeout
                    success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;

/// room send file mtype=40image  mtype=41audio  mtype=42video   mtype=50other
/// If the AudioModel is valid, the audio message will be sent. If the AudioModel is invalid, the filedata filename filesuffix filetype is required to send the regular file
/// @param roomId 
/// @param fileData 
/// @param fileName 
/// @param fileSuffix 
/// @param fileType 
/// @param attrs 
/// @param audioModel
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nonnull)fileData
                 fileName:(NSString * _Nonnull)fileName
               fileSuffix:(NSString * _Nonnull)fileSuffix
                 fileType:(RTMFileType)fileType
                    attrs:(NSDictionary * _Nullable)attrs
               audioModel:(RTMAudioModel * _Nullable)audioModel
                  timeout:(int)timeout
                  success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
                     
                     
```

<a id="friendinterface">friend interface</a>
================                           
```objc

/// add friends，every time max 100
/// @param friendids [int64] 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
               timeout:(int)timeout
               success:(void(^)(void))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                         timeout:(int)timeout;


/// delete friends, every time max 100
/// @param friendids [int64] 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteFriendWithId:(NSArray <NSNumber* >* _Nonnull)friendids
                            timeout:(int)timeout;


/// get myself friends
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserFriendsWithTimeout:(int)timeout
                         success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getUserFriendsWithTimeout:(int)timeout;


/// add blacklist
/// @param friendids 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                 timeout:(int)timeout;
   

/// Remove blacklist
/// @param friendids 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteBlacklistWithUserIds:(NSArray <NSNumber* >* _Nonnull)friendids
                                    timeout:(int)timeout;



/// get blacklist
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getBlacklistWithTimeout:(int)timeout
                       success:(void(^)(NSArray * _Nullable uidsArray))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getBlacklistWithTimeout:(int)timeout;


```

<a id="userinterface">user interface</a>
================                           
```objc


/// client to closeConnect
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)offLineWithTimeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)offLineWithTimeout:(int)timeout;


/// Kick off a link (only valid for multi-user login, can't kick yourself off, can be used to implement similar devices, only one login is allowed)
/// @param endPoint  link endpoint，through getAttrsWithTimeout get
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                   timeout:(int)timeout
                   success:(void(^)(void))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)kickoutWithEndPoint:(NSString * _Nonnull)endPoint
                             timeout:(int)timeout;


/// Key add_ Variable in the form of value (for example, setting the client information will be saved in the current link and the client can get it)
/// @param attrs 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                 timeout:(int)timeout
                 success:(void(^)(void))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)addAttrsWithAttrs:(NSDictionary <NSString*,NSString*> * _Nonnull)attrs
                           timeout:(int)timeout;


/// get attrs
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getAttrsWithTimeout:(int)timeout
                   success:(void(^)(RTMAttriAnswer * _Nullable attri))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getAttrsWithTimeout:(int)timeout;


/// Detection of offline chat can only be generated through chat class interface
/// @param clear yes Get and clear offline reminders
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUnreadMessagesWithClear:(BOOL)clear
                          timeout:(int)timeout
                          success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback;
-(RTMP2pGroupMemberAnswer*)getUnreadMessagesWithClear:(BOOL)clear
                                             timeout:(int)timeout;


/// Clear offline chat
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)cleanUnreadMessagesWithTimeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)cleanUnreadMessagesWithTimeout:(int)timeout;


/// Get all chat sessions (P2P users and themselves will also generate sessions)
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getAllSessionsWithTimeout:(int)timeout
                         success:(void(^)(RTMP2pGroupMemberAnswer * _Nullable memberAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback;
-(RTMP2pGroupMemberAnswer*)getAllSessionsWithTimeout:(int)timeout;


/// Get online user list，Get online user list，every time max 200
/// @param userIds [int64] 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getOnlineUsers:(NSArray <NSNumber* >* _Nonnull)userIds
              timeout:(int)timeout
              success:(void(^)(NSArray * _Nullable uidArray))successCallback
                 fail:(RTMAnswerFailCallBack)failCallback;
-(RTMMemberAnswer*)getOnlineUsers:(NSArray <NSNumber* >* _Nullable)userIds
                          timeout:(int)timeout;



/// set user openInfo and privteInfo
/// @param openInfo 
/// @param privteInfo 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                    privteinfo:(NSString * _Nullable)privteInfo
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setUserInfoWithOpenInfo:(NSString * _Nullable)openInfo
                          privteinfo:(NSString * _Nullable)privteInfo
                             timeout:(int)timeout;


/// get user openInfo and privteInfo
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserInfoWithTimeout:(int)timeout
                      success:(void(^)(RTMInfoAnswer * _Nullable info))successCallback
                         fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getUserInfoWithTimeout:(int)timeout;



/// get users openInfo
/// @param userIds [int64] 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserOpenInfo:(NSArray <NSNumber* > * _Nullable)userIds
               timeout:(int)timeout
               success:(void(^)(RTMAttriAnswer * _Nullable info))successCallback
                  fail:(RTMAnswerFailCallBack)failCallback;
-(RTMAttriAnswer*)getUserOpenInfo:(NSArray <NSNumber* > * _Nullable)userIds
                          timeout:(int)timeout;




/// Get stored data information(key:max 128byte)
/// @param key 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)getUserValueInfoWithKey:(NSString * _Nullable)key
                       timeout:(int)timeout
                       success:(void(^)(RTMInfoAnswer * _Nullable valueInfo))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMInfoAnswer*)getUserValueInfoWithKey:(NSString * _Nullable)key
                                timeout:(int)timeout;




/// Set stored data information(key:max 128byte，value：max65535byte)
/// @param key 
/// @param value 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)setUserValueInfoWithKey:(NSString * _Nonnull)key
                         value:(NSString * _Nonnull)value
                       timeout:(int)timeout
                       success:(void(^)(void))successCallback
                          fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setUserValueInfoWithKey:(NSString * _Nonnull)key
                                   value:(NSString * _Nonnull)value
                                 timeout:(int)timeout;

/// Delete stored data information
/// @param key 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)deleteUserDataWithKey:(NSString * _Nonnull)key
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)deleteUserDataWithKey:(NSString * _Nonnull)key
                           timeout:(int)timeout;




```

<a id="encryptioninterface">encryption interface</a>
================                           
```objc


- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

                
                     
```

<a id="translatefilterinterface">translate filter interface</a>
================                           
```objc

/// Set the translation language required by the current user
/// @param language 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)setLanguage:(NSString * _Nonnull)language
           timeout:(int)timeout
           success:(void(^)(void))successCallback
              fail:(RTMAnswerFailCallBack)failCallback;
-(RTMBaseAnswer*)setLanguage:(NSString * _Nonnull)language
                 timeout:(int)timeout;


/// Translation, return the translated string and the language type detected by the translation system (calling this interface needs to enable the translation system in the management system)
/// @param translateText
/// @param originalLanguage  
/// @param targetLanguage 
/// @param type Optional values are chat or mail. If not specified, chat is used by default
/// @param profanity Sensitive words filtering default: off censor: replace sensitive words with asterisk (*)
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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




/// Text auditing, return filtered string or return error (calling this interface needs to enable the text auditing system in the management system)
/// @param text  Text to filter
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)textReviewWithText:(NSString * _Nonnull)text
                  timeout:(int)timeout
                  success:(void(^)(RTMTextReviewAnswer * _Nullable textReview))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;
-(RTMTextReviewAnswer*)textReviewWithText:(NSString * _Nonnull)text
                                  timeout:(int)timeout;




/// Picture review （calling this interface needs to enable the text auditing system in the management system）The timeout time of calling this interface should be increased to 120s
/// @param imageUrl Image data imageurl imagedata choose one from two, and the simultaneous transmission of imagedata is preferred
/// @param imageData Image data imageurl imagedata choose one from two, and the simultaneous transmission of imagedata is preferred
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)imageReviewWithSource:(NSString * _Nullable)imageUrl
                   imageData:(NSData * _Nullable)imageData
                     timeout:(int)timeout
                     success:(void(^)(RTMReviewAnswer * _Nullable imageReview))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;
-(RTMReviewAnswer*)imageReviewWithSource:(NSString * _Nullable)imageUrl
                               imageData:(NSData * _Nullable)imageData
                                 timeout:(int)timeout;


/// Audio review, （calling this interface needs to enable the text auditing system in the management system）The timeout time of calling this interface should be increased to 120s
/// @param audioUrl audio data audioUrl audioData choose one from two, and the simultaneous transmission of audioData is preferred
/// @param audioData audio data audioUrl audioData choose one from two, and the simultaneous transmission of audioData is preferred
/// @param lang 
/// @param codec The default sampling is AMR_WB
/// @param srate The default sampling is 16000
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// video review,, （calling this interface needs to enable the text auditing system in the management system） The timeout time of calling this interface should be increased to 120s
/// @param videoUrl video data videoUrl videoData choose one from two, and the simultaneous transmission of videoData is preferred
/// @param videoData video data videoUrl videoData choose one from two, and the simultaneous transmission of videoData is preferred
/// @param videoName 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// Voice to text （calling this interface needs to enable the text auditing system in the management system） The timeout time of calling this interface should be increased to 120s
/// @param audioUrl audio data audioUrl audioData choose one from two, and the simultaneous transmission of audioData is preferred
/// @param audioData audio data audioUrl audioData choose one from two, and the simultaneous transmission of audioData is preferred
/// @param lang 语言
/// @param codec The default sampling is AMR_WB
/// @param srate The default sampling is 16000
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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

<a id="debugdeviceinterface">debug device interface</a>
================                           
```objc


/// add debug log
/// @param msg msg
/// @param attrs 
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addDebugLogWithMsg:(NSString * _Nonnull)msg
                    attrs:(NSString * _Nonnull)attrs
                  timeout:(int)timeout
                  success:(void(^)(void))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;



/// add device token
/// @param apptype   iOS ：apns   android ：fcm
/// @param deviceToken token
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)addDeviceWithAppType:(NSString * _Nonnull)appType
                deviceToken:(NSString * _Nonnull)deviceToken
                    timeout:(int)timeout
                    success:(void(^)(void))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;



/// delete device app info
/// @param deviceToken token
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
-(void)removeDeviceWithToken:(NSString * _Nonnull)deviceToken
                     timeout:(int)timeout
                     success:(void(^)(void))successCallback
                        fail:(RTMAnswerFailCallBack)failCallback;



/// Set the properties of device push (note that this interface is to set the type of a certain type of individual or group not to push)
/// @param typeType = 0, set a P2P not to push, type = 1, set a group not to push
/// @param xid Type = 0, corresponding to userid, type = 1, corresponding to groupid
/// @param mTypes If the array is empty, all mtypes will not be pushed; otherwise, the specified mtype will not be pushed
/// @param timeout timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
-(void)addDevicePushOptionWithType:(int)type
                               xid:(int64_t)xid
                            mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                           timeout:(int)timeout
                           success:(void(^)(void))successCallback
                              fail:(RTMAnswerFailCallBack)failCallback;



/// Cancel the device push property (corresponding to adddevicepushoptionwithtype)
/// @param type Type = 0, set a P2P type = 1, set a group
/// @param xid Type = 0, corresponding to fromuserid, type = 1, corresponding to groupid
/// @param mTypes. The message type array that needs to be unset (if the array is empty, it means that nothing will be done)
/// @param timeout timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
-(void)removeDevicePushOptionWithType:(int)type
                                  xid:(int64_t)xid
                               mTypes:(NSArray <NSNumber*>* _Nonnull)mTypes
                              timeout:(int)timeout
                              success:(void(^)(void))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;



/// Get device push property (result of adddevicepushoptionwithtype)
/// @param timeout timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback 
-(void)getDevicePushOptionWithTimeout:(int)timeout
                              success:(void(^)(RTMGetPushAttrsAnswer *answer))successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback;

```


<a id="p2pchatinterface">p2p chat interface</a>
================                           
```objc

/// send p2p msg  is  sendP2PMessageWithId interface encapsulation  mtype=30
/// @param userId int64 
/// @param message 
/// @param attrs Property suggests using a parseable JSON string
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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







/// send cmd msg  is sendP2PMessageWithId interface encapsulation  mtype=32
/// System commands (or messages requiring offline reminders), such as: Group invitation, application to join a group, refusal to apply to join a group, invitation to join a group, refusal to invite to join a group, adding friends, deleting friends, and other chat related commands
/// @param userId int64 
/// @param message 
/// @param attrs A parseable JSON string is recommended
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// get history msg  is getP2PHistoryMessageWithUserId interface encapsulation mtypes = [30,32,40,41,42,50]
/// @param userId int64 
/// @param desc Descending order
/// @param num int16 
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message. Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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
<a id="groupchatinterface">group chat interface</a>
================                           
```objc

/// send group msg  is sendGroupMessageWithId interface encapsulation mtype=30
/// Offline reminders will be generated through getunreadmessageswithclear, and chat sessions will be generated through getallsessions withtimeout
/// @param groupId int64 
/// @param message 
/// @param attrs A parseable JSON string is recommended
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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









/// send cmd msg  is sendGroupMessageWithId interface encapsulation mtype=32
/// System commands (or messages requiring offline reminders), such as: Group invitation, application to join a group, refusal to apply to join a group, invitation to join a group, refusal to invite to join a group, adding friends, deleting friends, and other chat related commands
/// @param groupId int64 
/// @param message 
/// @param attrs A parseable JSON string is recommended
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


/// get group history msg  is getGroupHistoryMessageWithGroupId interface encapsulation mtype=[30,32,40,41,42,50] 
/// @param groupId int64 
/// @param desc Descending order
/// @param num int16 
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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

<a id="roomchatinterface">room chat interface</a>
================                           
```objc
/// send room msg  is sendRoomMessageWithId interface encapsulation mtype=30 
/// @param roomId int64 
/// @param message 
/// @param attrs A parseable JSON string is recommended
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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





/// send cmd msg  is sendRoomMessageWithId interface encapsulation mtype=32 
/// System commands (or messages requiring offline reminders), such as: Group invitation, application to join a group, refusal to apply to join a group, invitation to join a group, refusal to invite to join a group, adding friends, deleting friends, and other chat related commands
/// @param roomId int64 
/// @param message 
/// @param attrs  A parseable JSON string is recommended
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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

 
/// get room history msg  is getRoomHistoryMessageWithId interface encapsulation mtype=[30,32,40,41,42,50]
/// @param roomId int64
/// @param desc Descending order
/// @param num int16 
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message. Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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

<a id="broadcastchatinterface">broadcast chat interface</a>
================                           
```objc
/// get broadcast history msg is getBroadCastHistoryMessageWithNum interface encapsulation mtype=[30,32,40,41,42,50]
/// @param num int16 
/// @param desc Descending order
/// @param begin int64 Start timestamp, accurate to milliseconds
/// @param end int64 End timestamp, accurate to milliseconds
/// @param lastid int64 The ID of the last message  Cursorid field corresponding to rtmgetmessage rtmhistorymessage
/// @param timeout Request timeout seconds
/// @param successCallback 
/// @param failCallback
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


<a id="audiorecordandplayinterface">audio record and play interface</a>
================                           
```objc
Audio playback conversion related operations are used in demo in detail
Recording requires 1sampling rate 16000.0   2 sampling bits 16.   3 channels is 1
The transmission format is AMRWB

Start recording
-(void)startRecordWithLang:(NSString * _Nonnull)lang;
End recording
-(void)stopRecord:(void(^)(RTMAudioModel * audioModel))recorderFinish;             
Play the recording                        
-(void)playWithAudioModel:(RTMAudioModel*)audioModel;//audioFilePath is not nil
-(void)playWithAmrData:(NSData*)amrData;//Binary data obtained by audio URL. format is AMRWB                    
stop playing
-(void)stop;


```

