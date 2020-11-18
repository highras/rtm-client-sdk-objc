//
//  RTMTranslatedInfoAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/14.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"
#import "RTMTranslatedInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMTranslatedInfoAnswer : RTMBaseAnswer
@property(nonatomic,strong)RTMTranslatedInfo * translatedInfo;
@end

NS_ASSUME_NONNULL_END
