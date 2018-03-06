//
//  FPNNQuestProcessor.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNNAsyncAnswer.h"
#import "FPNNSDKInternalFuncDefinition.h"

@interface FPNNQuestProcessor : NSObject

@property (nonatomic) FPNNConnectEvent connectedEventCallback;
@property (nonatomic) FPNNConnectWillCloseEvent closeEventCallback;
@property (nonatomic) FPNNQuestEvent questEventCallback;

- (instancetype)init;

/*
 If you want to hook the connection events, please override the following methods you want hooked.
 */

- (void)connected;
- (void)connectionWillClose:(BOOL)closeByError;

/*
 Optional quest event / server push:
 - (FPNNAnswer*)<methodName>:(NSDictionary*)params;
 */


/*
 !!! Please DO NOT override the following methods. !!!
 */
- (FPNNAsyncAnswer*)genAsyncAnswer;

- (BOOL)sendEmptyAnswer;
- (BOOL)sendAnswer:(FPNNAnswer*)answer;
- (BOOL)sendAnswerWithPayload:(NSDictionary*)payload;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message;
- (BOOL)sendErrorAnswerWithErrorCode:(int)errorCode andDescription:(NSString*)message withRaiser:(NSString*)raiser;

@end
