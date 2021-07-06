//
//  RTMGroupMemberAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMMemberAnswer : RTMBaseAnswer
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * onlinesArray;
@end

NS_ASSUME_NONNULL_END
