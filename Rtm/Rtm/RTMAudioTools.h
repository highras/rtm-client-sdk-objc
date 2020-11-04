//
//  RTMAudioTools.h
//  Rtm
//
//  Created by zsl on 2020/3/11.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMAudioTools : NSObject
+ (NSData*)audioDataAddHeader:(NSData*)audioData lang:(NSString*)lang time:(long long)time srate:(int)srate;
+ (NSData*)audioDataRemoveHeader:(NSData*)audioData;
+ (BOOL)isAmrVerify:(NSData*)audioData;
@end

NS_ASSUME_NONNULL_END
