//
//  FPNNAnswerCallback.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/21.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNNSDKInternalFuncDefinition.h"

@interface FPNNAnswerCallback : NSObject

@property (nonatomic) FPNNAnswerBridgeCallback cppCallback;

- (void)onAnswer:(NSDictionary*)payload;
- (void)onException:(int)errorCode payload:(NSDictionary*)payload;

@end


@interface FPNNAnswerBlockCallback : FPNNAnswerCallback

- (instancetype)initWithBlock:(void(^)(int errorCode, NSDictionary* payload))block;

@end

@interface FPNNSyncAnswerCallback : FPNNAnswerCallback

- (FPNNAnswer*)getAnswer;

@end
