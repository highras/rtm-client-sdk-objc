//
//  RTMTextReviewAnswer.h
//  Rtm
//
//  Created by zsl on 2020/10/16.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMTextReviewAnswer : RTMBaseAnswer
@property(nonatomic,assign)int result;//是否通过 0通过   2不通过
@property(nonatomic,strong)NSString * text;//敏感词过滤后的文本内容，含有的敏感词会被替换为*，如果没有被标星，则无此字段
@property(nonatomic,strong)NSArray * tags;//触发的分类，比如涉黄涉政等等，具体见文本审核分类
@property(nonatomic,strong)NSArray * wlist;//敏感词列表
@end

NS_ASSUME_NONNULL_END
