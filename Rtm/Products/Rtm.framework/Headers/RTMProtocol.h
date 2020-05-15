//
//  RTMProtocol.h
//  Rtm
//
//  Created by zsl on 2019/12/16.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RTMClient,RTMAnswer,FPNError;
@protocol RTMProtocol <NSObject>

@required



//状态
-(void)rtmConnectStateSuccess:(RTMClient *)client;//client 连接成功
-(void)rtmConnectstateClose:(RTMClient *)client;//client 断开
-(void)rtmKickout:(RTMClient *)client;//被踢下线
-(void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary * _Nullable)data;//房间踢出

//normal Binary
-(void)rtmReceiveP2PBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//normal message
-(void)rtmReceiveP2PData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastData:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//file
-(void)rtmReceiveP2PFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//chat message
-(void)rtmReceiveP2PMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//chat audio
-(void)rtmReceiveP2PAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;

//chat cmd
-(void)rtmReceiveP2PCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveGroupCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveRoomCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;
-(void)rtmReceiveBroadcastCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;



@end

NS_ASSUME_NONNULL_END

