//
//  RTMConfig.h
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef RTMConfig_h
#define RTMConfig_h

#import <Foundation/Foundation.h>

@interface RTMConfig : NSObject

+ (NSInteger) MID_TTL;

+ (NSString *) SERVER_PUSH_kickOut;
+ (NSString *) SERVER_PUSH_kickOutRoom;
+ (NSString *) SERVER_PUSH_recvMessage;
+ (NSString *) SERVER_PUSH_recvGroupMessage;
+ (NSString *) SERVER_PUSH_recvRoomMessage;
+ (NSString *) SERVER_PUSH_recvBroadcastMessage;
+ (NSString *) SERVER_PUSH_recvFile;
+ (NSString *) SERVER_PUSH_recvGroupFile;
+ (NSString *) SERVER_PUSH_recvRoomFile;
+ (NSString *) SERVER_PUSH_recvBroadcastFile;
+ (NSString *) SERVER_PUSH_recvPing;

+ (NSString *) SERVER_EVENT_login;
+ (NSString *) SERVER_EVENT_logout;

typedef NS_ENUM(NSUInteger, FILE_TYPE) {
    
    image = 40,     //图片
    audio = 41,     //语音
    video = 42,     //视频
    file = 50       //泛指文件，服务器会修改此值（如果服务器可以判断出具体类型的话，仅在mtype=50的情况下）
};

enum {
    
    RTM_EC_INVALID_PROJECT_ID_OR_USER_ID = 200001,
    RTM_EC_INVALID_PROJECT_ID_OR_SIGN = 200002,
    RTM_EC_INVALID_FILE_OR_SIGN_OR_TOKEN = 200003,
    RTM_EC_ATTRS_WITHOUT_SIGN_OR_EXT = 200004,
    
    RTM_EC_API_FREQUENCY_LIMITED = 200010,
    RTM_EC_MESSAGE_FREQUENCY_LIMITED = 200011,
    
    RTM_EC_FORBIDDEN_METHOD = 200020,
    RTM_EC_PERMISSION_DENIED = 200021,
    RTM_EC_UNAUTHORIZED = 200022,
    RTM_EC_DUPLCATED_AUTH = 200023,
    RTM_EC_AUTH_DENIED = 200024,
    RTM_EC_ADMIN_LOGIN = 200025,
    RTM_EC_ADMIN_ONLY = 200026,
    
    RTM_EC_LARGE_MESSAGE_OR_ATTRS = 200030,
    RTM_EC_LARGE_FILE_OR_ATTRS = 200031,
    RTM_EC_TOO_MANY_ITEMS_IN_PARAMETERS = 200032,
    RTM_EC_EMPTY_PARAMETER = 200033,
    
    RTM_EC_NOT_IN_ROOM = 200040,
    RTM_EC_NOT_GROUP_MEMBER = 200041,
    RTM_EC_MAX_GROUP_MEMBER_COUNT = 200042,
    RTM_EC_NOT_FRIEND = 200043,
    RTM_EC_BANNED_IN_GROUP = 200044,
    RTM_EC_BANNED_IN_ROOM = 200045,
    RTM_EC_EMPTY_GROUP = 200046,
    RTM_EC_ENTER_TOO_MANY_ROOMS = 200047,
    
    RTM_EC_UNSUPPORTED_LANGUAGE = 200050,
    RTM_EC_EMPTY_TRANSLATION = 200051,
    RTM_EC_SEND_TO_SELF = 200052,
    RTM_EC_DUPLCATED_MID = 200053,
    RTM_EC_SENSITIVE_WORDS = 200054,
    
    RTM_EC_UNKNOWN_ERROR = 200999,
};
@end

#endif /* RTMConfig_h */