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

@property(nonatomic,strong)NSDictionary < NSNumber* , NSArray<NSNumber *> *> * p2pAttrs;//@{ userId : @[mtype] }
@property(nonatomic,strong)NSDictionary < NSNumber* , NSArray<NSNumber *> *> * groupAttrs;//@{ groupId : @[mtype] }
@end

NS_ASSUME_NONNULL_END
