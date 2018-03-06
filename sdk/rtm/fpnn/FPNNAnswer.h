//
//  FPNNAnswer.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNMessage.h"

/*
 For String:
 If original string can be used to init NSString with UTF-8 encoding, the node of the string will is NSString type,
 else it is NSData type.
 */

@interface FPNNAnswer : FPNNMessage

@property (readonly, nonatomic) BOOL errorAnswer;

+ (instancetype)emptyAnswer;
+ (instancetype)answerWithPayload:(NSDictionary*)payload;

+ (instancetype)answerWithErrorCode:(int)errorCode;
+ (instancetype)answerWithErrorCode:(int)errorCode andDescription:(NSString*)message;
+ (instancetype)answerWithErrorCode:(int)errorCode andDescription:(NSString*)message withRaiser:(NSString*)raiser;

- (instancetype)initEmptyAnswer;
- (instancetype)initWithPayload:(NSDictionary*)payload;

- (instancetype)initWithErrorCode:(int)errorCode;
- (instancetype)initWithErrorCode:(int)errorCode andDescription:(NSString*)message;
- (instancetype)initWithErrorCode:(int)errorCode andDescription:(NSString*)message withRaiser:(NSString*)raiser;

@end
