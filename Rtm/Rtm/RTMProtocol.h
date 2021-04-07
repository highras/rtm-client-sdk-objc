//
//  RTMProtocol.h
//  Rtm
//
//  Created by zsl on 2019/12/16.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RTMClient,RTMAnswer,FPNError,RTMMessage;
@protocol RTMProtocol <NSObject>

@required
//重连只有在登录成功过1次后才会有效
//重连将要开始  根据返回值是否进行重连
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

//chat cmd
-(void)rtmPushP2PChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushGroupChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushRoomChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;
-(void)rtmPushBroadcastChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message;

//error log
-(void)rtmErrorLog:(NSString*)errorLog;
@end

NS_ASSUME_NONNULL_END

