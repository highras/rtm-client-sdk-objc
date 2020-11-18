//
//  RTMGetMessageAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"
#import "RTMGetMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMGetMessageAnswer : RTMBaseAnswer
@property(nonatomic,strong)RTMGetMessage * getMessage;
@end

NS_ASSUME_NONNULL_END
