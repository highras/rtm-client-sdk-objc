//
//  RTMMessageModelConvert.h
//  Rtm
//
//  Created by zsl on 2020/8/5.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMMessage.h"
#import "RTMHistoryMessage.h"
#import "RTMClient+MessagesManager.h"
#import "RTMGetMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMMessageModelConvert : NSObject
+(RTMMessage*)messageModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType;
//+(RTMMessage*)audioModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType;
+(RTMMessage*)cmdModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType;
+(RTMMessage*)fileModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType;


+(RTMHistoryMessage*)p2pHistoryMessageModelConvert:(NSArray*)itemArray toUserId:(int64_t)toUserId myUserId:(int64_t)myUserId;
+(RTMHistoryMessage*)groupHistoryMessageModelConvert:(NSArray*)itemArray;
+(RTMHistoryMessage*)roomHistoryMessageModelConvert:(NSArray*)itemArray;
+(RTMHistoryMessage*)broadcastHistoryMessageModelConvert:(NSArray*)itemArray;


+(RTMGetMessage*)getMessageModelConvert:(NSDictionary*)data;

@end

NS_ASSUME_NONNULL_END
