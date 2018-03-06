//
//  FPNNQuest.h
//  fpnn
//
//  Created by 施王兴 on 2017/12/28.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNMessage.h"

/*
 For String:
 If original string can be used to init NSString with UTF-8 encoding, the node of the string will is NSString type,
 else it is NSData type.
 */

@interface FPNNQuest : FPNNMessage

@property (readonly, nonatomic) BOOL twoway;
@property (readonly, strong, nonatomic) NSString* method;

+ (instancetype)quest:(NSString*)method;
+ (instancetype)quest:(NSString*)method withPayload:(NSDictionary*)payload;

+ (instancetype)oneWayQuest:(NSString*)method;
+ (instancetype)oneWayQuest:(NSString*)method withPayload:(NSDictionary*)payload;


- (instancetype)init:(NSString*)method;
- (instancetype)init:(NSString*)method withPayload:(NSDictionary*)payload;

- (instancetype)initOneWayQuest:(NSString*)method;
- (instancetype)initOneWayQuest:(NSString*)method withPayload:(NSDictionary*)payload;

@end
