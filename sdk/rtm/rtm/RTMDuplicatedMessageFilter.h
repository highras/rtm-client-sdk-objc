//
//  RTMDuplicatedMessageFilter.h
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMDuplicatedMessageFilter : NSObject

+ (BOOL)filterP2PMessage:(int64_t)mid from:(int64_t)uid;
+ (BOOL)filterGroupMessage:(int64_t)mid from:(int64_t)uid inGroup:(int64_t)groupId;
+ (BOOL)filterRoomMessage:(int64_t)mid from:(int64_t)uid inRoom:(int64_t)roomId;
+ (BOOL)filterBroadcastMessage:(int64_t)mid from:(int64_t)uid;

+ (void)cleanExpiredCache;

@end
