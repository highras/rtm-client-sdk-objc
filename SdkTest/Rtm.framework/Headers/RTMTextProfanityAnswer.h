//
//  RTMTextProfanityAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/14.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMTextProfanityAnswer : RTMBaseAnswer
@property(nonatomic,strong)NSString * text;
@property(nonatomic,strong)NSArray * classification;
@end

NS_ASSUME_NONNULL_END
