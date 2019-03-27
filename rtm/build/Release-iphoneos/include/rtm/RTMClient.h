//
//  RTMClient.h
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef RTMClient_h
#define RTMClient_h

#import <Foundation/Foundation.h>
#import "FPClient.h"

@class FPEvent, FPPackage, RTMProcessor, BaseClient, DispatchClient;

static NSInteger count = 0;

@interface RTMClient : NSObject

@property(nonatomic, readonly, assign) NSInteger pid;
@property(nonatomic, readonly, assign) NSInteger uid;
@property(nonatomic, readonly, assign) NSInteger timeout;

@property(nonatomic, readonly, assign) BOOL reconnect;
@property(nonatomic, readonly, assign) BOOL startTimerThread;

@property(nonatomic, readonly, strong) NSString * dispatch;
@property(nonatomic, readonly, strong) NSString * token;
@property(nonatomic, readonly, strong) NSString * version;
@property(nonatomic, readonly, strong) NSDictionary * attrs;

@property(nonatomic, readonly, assign) BOOL ipv6;
@property(nonatomic, readwrite, assign) BOOL isClose;
@property(nonatomic, readwrite, strong) NSString * endpoint;

@property (nonatomic, readonly, strong) RTMProcessor * processor;
@property(nonatomic, readonly, strong) FPEvent * event;

@property (nonatomic, readonly, strong) BaseClient * baseClient;
@property (nonatomic, readwrite, strong) DispatchClient * dispatchClient;

/*
 * @param {NSString}                        dispatch
 * @param {NSInteger}                       pid
 * @param {NSInteger}                       uid
 * @param {NSString}                        token
 * @param {NSString}                        version
 * @param {NSDictionary[String,String]}     attrs
 * @param {BOOL}                            reconnect
 * @param {NSInteger}                       timeout
 * @param {BOOL}                            startTimerThread
 */
- (instancetype) initWithDispatch:(NSString *)dispatch andPid:(NSInteger)pid andUid:(NSInteger)uid andToken:(NSString *)token andVersion:(NSString *)version andAttrs:(NSDictionary *)attrs andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread;

- (void) sendQuestWithData:(FPData *)data andBlock:(CallbackBlock)callback;
- (void) sendQuestWithData:(FPData *)data andBlock:(CallbackBlock)callback andTimeout:(NSInteger)timeout;
- (void) destroy;

/*
 * @param {NSString}                        endpoint
 * @param {BOOL}                            ipv6
 */
- (void) loginWithEndpoint:(NSString *)endpoint andIPv6:(BOOL)ipv6;

/*
 *
 * rtmGate (2)
 *
 * @param {NSInteger}                       to
 * @param {NSInteger}                       mtype
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSObject(mtime:NSInteger)}       payload
 * </CallbackData>
 */
- (void) sendMessage:(NSInteger)to andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (3)
 *
 * @param {NSInteger}                       gid
 * @param {NSInteger}                       mtype
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSObject(mtime:NSInteger)}       payload
 * </CallbackData>
 */
- (void) sendGroupMessage:(NSInteger)gid andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (4)
 *
 * @param {NSInteger}                       rid
 * @param {NSInteger}                       mtype
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSObject(mtime:NSInteger)}       payload
 * </CallbackData>
 */
- (void) sendRoomMessage:(NSInteger)rid andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (5)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSObject(p2p:NSObject(NSString,NSInteger),group:NSObject(NSString,NSInteger))}         payload
 * </CallbackData>
 */
- (void) getUnreadMessage:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (6)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject}                        payload
 * </CallbackData>
 */
- (void) cleanUnreadMessage:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (7)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(p2p:NSObject(NSString,NSInteger),group:NSObject(NSString,NSInteger))}         payload
 * </CallbackData>
 */
- (void) getSession:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (8)
 *
 * @param {NSInteger}                       gid
 * @param {BOOL}                            desc
 * @param {NSInteger}                       num
 * @param {NSInteger}                       begin
 * @param {NSInteger}                       end
 * @param {NSInteger}                       lastid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(num:NSInteger,lastid:NSInteger,begin:NSInteger,end:NSInteger,msgs:NSArray(GroupMsg))}  payload
 * </CallbackData>
 *
 * <GroupMsg>
 * @param {NSInteger}                       id
 * @param {NSInteger}                       from
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       mid
 * @param {BOOL}                            deleted
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mtime
 * </GroupMsg>
 */
- (void) getGroupMessage:(NSInteger)gid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (9)
 *
 * @param {NSInteger}                       rid
 * @param {BOOL}                            desc
 * @param {NSInteger}                       num
 * @param {NSInteger}                       begin
 * @param {NSInteger}                       end
 * @param {NSInteger}                       lastid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(num:NSInteger,lastid:NSInteger,begin:NSInteger,end:NSInteger,msgs:NSArray(RoomMsg))}  payload
 * </CallbackData>
 *
 * <RoomMsg>
 * @param {NSInteger}                       id
 * @param {NSInteger}                       from
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       mid
 * @param {BOOL}                            deleted
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mtime
 * </RoomMsg>
 */
- (void) getRoomMessage:(NSInteger)rid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (10)
 *
 * @param {BOOL}                            desc
 * @param {NSInteger}                       num
 * @param {NSInteger}                       begin
 * @param {NSInteger}                       end
 * @param {NSInteger}                       lastid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(num:NSInteger,lastid:NSInteger,begin:NSInteger,end:NSInteger,msgs:NSArray(BroadcastMsg))}  payload
 * </CallbackData>
 *
 * <BroadcastMsg>
 * @param {NSInteger}                       id
 * @param {NSInteger}                       from
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       mid
 * @param {BOOL}                            deleted
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mtime
 * </BroadcastMsg>
 */
- (void) getBroadcastMessage:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (11)
 *
 * @param {NSInteger}                       ouid
 * @param {BOOL}                            desc
 * @param {NSInteger}                       begin
 * @param {NSInteger}                       end
 * @param {NSInteger}                       lastid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(num:NSInteger,lastid:NSInteger,begin:NSInteger,end:NSInteger,msgs:NSArray(P2PMsg))}  payload
 * </CallbackData>
 *
 * <P2PMsg>
 * @param {NSInteger}                       id
 * @param {NSInteger}                       direction
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       mid
 * @param {BOOL}                            deleted
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       mtime
 * </P2PMsg>
 */
- (void) getP2PMessage:(NSInteger)ouid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (12)
 *
 * @param {NSString}                        cmd
 * @param {NSArray(Long)}                   tos
 * @param {NSInteger}                       to
 * @param {NSInteger}                       rid
 * @param {NSInteger}                       gid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(token:NSString,endpoint:NSString)}  payload
 * </CallbackData>
 */
- (void) fileToken:(NSString *)cmd andTos:(NSArray *)tos andTo:(NSInteger)to andRid:(NSInteger)rid andGid:(NSInteger)gid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 * rtmGate (13)
 */
- (void) close;

/*
 *
 * rtmGate (14)
 *
 * @param {NSDictionary(NSString,NSString)} attrs
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) addAttrs:(NSDictionary *)attrs andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (15)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSObject(attrs:NSArray(Map))}    payload
 * </CallbackData>
 *
 * <Map>
 * @param {NSString}                        ce
 * @param {NSString}                        login
 * @param {NSString}                        my
 * </Map>
 */
- (void) getAttrs:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (16)
 *
 * @param {NSString}                        msg
 * @param {NSString}                        attrs
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) addDebugLog:(NSString *)msg andAttrs:(NSString *)attrs andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (17)
 *
 * @param {NSString}                        apptype
 * @param {NSString}                        devicetoken
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) addDevice:(NSString *)apptype andDeviceToken:(NSString *)devicetoken andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (18)
 *
 * @param {String}                          devicetoken
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) removeDevice:(NSString *)devicetoken andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (19)
 *
 * @param {NSString}                        targetLanguage
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) setTranslationLanguage:(NSString *)targetLanguage andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (20)
 *
 * @param {NSString}                        originalMessage
 * @param {NSString}                        originalLanguage
 * @param {NSString}                        targetLanguage
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary(stext:NSString,src:NSString,dtext:NSString,dst:NSString)}   payload
 * </CallbackData>
 */
- (void) translate:(NSString *)originalMessage andOriginalLanguage:(NSString *)originalLanguage andTargetLanguage:(NSString *)targetLanguage andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (21)
 *
 * @param {NSArray(NSInteger)}              friends
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) addFriends:(NSArray *)friends andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (22)
 *
 * @param {NSArray(NSInteger)}              friends
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) deleteFriends:(NSArray *)friends andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (23)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) getFriends:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (24)
 *
 * @param {NSInteger}                       gid
 * @param {NSArray(NSInteger)}              uids
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) addGroupMembers:(NSInteger)gid andUIDs:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (25)
 *
 * @param {NSInteger}                       gid
 * @param {NSArray(NSInteger)}              uids
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) deleteGroupMembers:(NSInteger)gid andUIDs:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (26)
 *
 * @param {NSInteger}                       gid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) getGroupMembers:(NSInteger)gid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (27)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) getUserGroups:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (28)
 *
 * @param {NSInteger}                       rid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) enterRoom:(NSInteger)rid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (29)
 *
 * @param {NSInteger}                       rid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) leaveRoom:(NSInteger)rid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (30)
 *
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) getUserRooms:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (31)
 *
 * @param {NSArray(NSInteger)}              uids
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) getOnlineUsers:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (32)
 *
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       xid
 * @param {NSInteger}                       type
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) deleteMessage:(NSInteger)mid andXID:(NSInteger)xid andType:(NSInteger)type andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (33)
 *
 * @param {NSString}                        ce
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSArray(NSInteger)}              payload
 * </CallbackData>
 */
- (void) kickout:(NSString *)ce andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (34)
 *
 * @param {NSString}                        key
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary(val:NSString)}      payload
 * </CallbackData>
 */
- (void) dbGet:(NSString *)key andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * rtmGate (35)
 *
 * @param {NSString}                        key
 * @param {NSString}                        value
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSError}                         error
 * @param {NSDictionary}                    payload
 * </CallbackData>
 */
- (void) dbSet:(NSString *)key andValue:(NSString *)value andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * fileGate (1)
 *
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       to
 * @param {NSData}                          fileData
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSDictionary(mtime:NSInteger)}   payload
 * </CallbackData>
 */
- (void) sendFile:(NSInteger)mtype andTo:(NSInteger)to andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * fileGate (3)
 *
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       gid
 * @param {NSData}                          fileData
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSDictionary(mtime:NSInteger)}   payload
 * </CallbackData>
 */
- (void) sendGroupFile:(NSInteger)mtype andGid:(NSInteger)gid andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

/*
 *
 * fileGate (4)
 *
 * @param {NSInteger}                       mtype
 * @param {NSInteger}                       rid
 * @param {NSData}                          fileData
 * @param {NSInteger}                       mid
 * @param {NSInteger}                       timeout
 * @param {CallbackBlock}                   callback
 *
 * @callback
 * @param {CallbackData}                    cbd
 *
 * <CallbackData>
 * @param {NSInteger}                       mid
 * @param {NSError}                         error
 * @param {NSDictionary(mtime:NSInteger)}   payload
 * </CallbackData>
 */
- (void) sendRoomFile:(NSInteger)mtype andRid:(NSInteger)rid andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

- (void) connect:(NSString *)endpoint andTimeout:(NSInteger)timeout;

@end

@interface BaseClient : FPClient

- (void) initWithEndpoint:(NSString *)endpoint andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread;
- (void) enableConnect;

- (CallbackBlock) questWithBlock:(CallbackBlock)callback;

- (BOOL) isBlankString:(NSString *)str;
- (NSString *) md5WithData:(NSData *)data;
- (NSString *) md5WithString:(NSString *)str;

@end


@interface DispatchClient : BaseClient

- (void) initWithEndpoint:(NSString *)endpoint andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread;
- (void) whichWithPayload:(NSDictionary *)payload andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

@end


@interface FileClient : BaseClient

- (void) initWithEndpoint:(NSString *)endpoint andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread;
- (void) sendWithMethod:(NSString *)method andFileData:(NSData *)fileData andToken:(NSString *)token andPayload:(NSDictionary *)payload andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback;

@end

#endif /* RTMClient_h */
