//
//  FPNNMessage.h
//  fpnn
//
//  Created by 施王兴 on 2017/12/28.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 For String:
 If original string can be used to init NSString with UTF-8 encoding, the node of the string will is NSString type,
 else it is NSData type.
 */

@interface FPNNMessage : NSObject

@property (readonly, strong, nonatomic) NSMutableDictionary *payload;

+ (instancetype)message;
+ (instancetype)messageWithPayload:(NSDictionary*)payload;

- (instancetype)init;
- (instancetype)initWithPayload:(NSDictionary*)payload;

- (void)param:(NSString*)key value:(NSObject*)value;
- (NSObject*)get:(NSString*)key default:(NSObject*)value;
- (NSObject*)get:(NSString*)key;

@end
