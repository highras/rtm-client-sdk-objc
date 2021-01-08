//
//  RTMGetPushAttrsAnswer.h
//  Rtm
//
//  Created by zsl on 2020/12/24.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMGetPushAttrsAnswer : RTMBaseAnswer

@property(nonatomic,strong)NSDictionary * p2p;  //@{userId（string）: @[mtype]}
@property(nonatomic,strong)NSDictionary * group;//@{groupId (string）: @[mtype]}
@end

NS_ASSUME_NONNULL_END
