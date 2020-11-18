//
//  RTMClient+MessagesManager.h
//  Rtm
//
//  Created by zsl on 2020/7/22.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RTMChatType)
{
    RTMP2p = 0,
    RTMGroup = 1,
    RTMRoom = 2,
    RTMBroadcast = 3
};
@interface RTMClient (MessagesManager)
-(void)messageShareCenter:(NSDictionary*)data method:(NSString*)method;
                
@end

NS_ASSUME_NONNULL_END
