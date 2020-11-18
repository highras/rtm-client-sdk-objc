//
//  RTMUnreadMessageAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/14.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMP2pGroupMemberAnswer : RTMBaseAnswer
@property(nonatomic,strong)NSArray * p2pArray;
@property(nonatomic,strong)NSArray * groupArray;
@end

NS_ASSUME_NONNULL_END

