//
//  RTMInfoAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMInfoAnswer : RTMBaseAnswer
@property(nonatomic,copy)NSString * _Nullable openInfo;
@property(nonatomic,copy)NSString * _Nullable privateInfo;
@property(nonatomic,copy)NSString * _Nullable valueInfo;

@end

NS_ASSUME_NONNULL_END
