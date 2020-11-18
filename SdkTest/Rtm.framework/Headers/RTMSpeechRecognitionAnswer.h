//
//  RTMSpeechRecognitionAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/14.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMSpeechRecognitionAnswer : RTMBaseAnswer
@property(nonatomic,strong)NSString * lang;
@property(nonatomic,strong)NSString * text;
@end

NS_ASSUME_NONNULL_END
