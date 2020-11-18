//
//  RTMTranslatedInfo.h
//  Rtm
//
//  Created by zsl on 2020/8/4.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMTranslatedInfo : NSObject
@property(nonatomic,copy)NSString * source;
@property(nonatomic,copy)NSString * target;
@property(nonatomic,copy)NSString * sourceText;
@property(nonatomic,copy)NSString * targetText;
@end

NS_ASSUME_NONNULL_END
