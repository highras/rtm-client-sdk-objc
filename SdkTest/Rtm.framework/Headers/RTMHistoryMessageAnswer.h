//
//  RTMHistoryMessageAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"
#import "RTMHistory.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMHistoryMessageAnswer : RTMBaseAnswer
@property(nonatomic,strong)RTMHistory * history;
@end

NS_ASSUME_NONNULL_END
