//
//  RTMConfig.m
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#import "RTMConfig.h"

@interface RTMConfig() {
    
}

@end


@implementation RTMConfig

+ (NSInteger) MID_TTL {
    
    return 5 * 1000;
}

+ (NSString *) SERVER_PUSH_kickOut {
    
    return @"kickout";
}

+ (NSString *) SERVER_PUSH_kickOutRoom {
    
    return @"kickoutroom";
}

+ (NSString *) SERVER_PUSH_recvMessage {
    
    return @"pushmsg";
}

+ (NSString *) SERVER_PUSH_recvGroupMessage {
    
    return @"pushgroupmsg";
}

+ (NSString *) SERVER_PUSH_recvRoomMessage {
    
    return @"pushroommsg";
}

+ (NSString *) SERVER_PUSH_recvBroadcastMessage {
    
    return @"pushbroadcastmsg";
}

+ (NSString *) SERVER_PUSH_recvFile {
    
    return @"pushfile";
}

+ (NSString *) SERVER_PUSH_recvGroupFile {
    
    return @"pushgroupfile";
}

+ (NSString *) SERVER_PUSH_recvRoomFile {
    
    return @"pushroomfile";
}

+ (NSString *) SERVER_PUSH_recvBroadcastFile {
    
    return @"pushbroadcastfile";
}

+ (NSString *) SERVER_PUSH_recvPing {
    
    return @"ping";
}

+ (NSString *) SERVER_EVENT_login {
    
    return @"login";
}

+ (NSString *) SERVER_EVENT_logout {
    
    return @"logout";
}

@end
