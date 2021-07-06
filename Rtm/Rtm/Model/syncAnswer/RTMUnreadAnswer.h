//
//  RTMUnreadAnswer.h
//  Rtm
//
//  Created by zsl on 2020/11/25.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMUnreadAnswer : RTMBaseAnswer

@property(nonatomic,strong)NSDictionary * unreadDictionary;
@property(nonatomic,strong)NSDictionary * lastMsgTimeDictionary;
@end

NS_ASSUME_NONNULL_END
