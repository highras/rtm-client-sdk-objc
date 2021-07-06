//
//  RTMMemberCountAnswer.h
//  Rtm
//
//  Created by zsl on 2021/3/8.
//  Copyright © 2021 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMMemberCountAnswer : RTMBaseAnswer
@property(nonatomic,assign)int64_t count;
@property(nonatomic,assign)int64_t onlineCount;
@end

NS_ASSUME_NONNULL_END
