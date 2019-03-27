//
//  FPCallback.h
//  fpnn
//
//  Created by dixun on 2018/5/28.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPCallback_h
#define FPCallback_h

#import <Foundation/Foundation.h>

@class CallbackData, FPData;

typedef void(^CallbackBlock)(CallbackData * cbd);

@interface FPCallback : NSObject

@property(nonatomic, readwrite, strong) NSMutableDictionary * cbMap;
@property(nonatomic, readwrite, strong) NSMutableDictionary * exMap;

- (void) addKey:(NSString *)key andCallback:(CallbackBlock)callback;
- (void) addKey:(NSString *)key andCallback:(CallbackBlock)callback andTimeout:(NSInteger)timeout;

- (void) removeAll;

- (void) execKey:(NSString *)key andData:(FPData *)data;
- (void) execKey:(NSString *)key andError:(NSError *)error;

- (void) onSecond:(NSInteger)timestamp;

@end

#endif /* FPCallback_h */
