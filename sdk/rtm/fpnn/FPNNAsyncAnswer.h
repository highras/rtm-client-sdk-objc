//
//  FPNNAsyncAnswer.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/20.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNNAnswer.h"

@interface FPNNAsyncAnswer : NSObject

- (instancetype)initWithCppAsyncAnswer:(void*)ptr;

- (BOOL)sendEmptyAnswer;
- (BOOL)sendAnswer:(FPNNAnswer*)answer;
- (BOOL)sendAnswerWithPayload:(NSDictionary*)payload;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message withRaiser:(NSString*)raiser;

@end
