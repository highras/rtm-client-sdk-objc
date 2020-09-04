//
//  RTMBaseAnswer.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNError.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMBaseAnswer : NSObject
@property(nonatomic,strong)FPNError * error;//成功时 error 为 nil  
@end

NS_ASSUME_NONNULL_END
