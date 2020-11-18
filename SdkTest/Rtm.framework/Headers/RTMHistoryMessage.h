//
//  RTMHistoryMessage.h
//  Rtm
//
//  Created by zsl on 2020/8/4.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMHistoryMessage : RTMMessage
@property(nonatomic,assign)int64_t cursorId;
@end

NS_ASSUME_NONNULL_END
