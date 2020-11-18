//
//  RTMImageReviewAnswer.h
//  Rtm
//
//  Created by zsl on 2020/10/16.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMReviewAnswer : RTMBaseAnswer
@property(nonatomic,assign)int result;//是否通过 0通过   2不通过
@property(nonatomic,strong)NSArray * tags;//触发的分类，比如涉黄涉政等等，具体见图片审核分类
@end

NS_ASSUME_NONNULL_END
