//
//  EventData.h
//  fpnn
//
//  Created by dixun on 2018/5/28.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef EventData_h
#define EventData_h

#import <Foundation/Foundation.h>

@class FPData;

@interface EventData : NSObject

@property(nonatomic, readonly, assign) BOOL retry;

@property(nonatomic, readonly, strong) NSString * type;
@property(nonatomic, readonly, strong) FPData * data;
@property(nonatomic, readonly, strong) NSError * error;
@property(nonatomic, readonly, strong) NSObject * payload;
@property(nonatomic, readonly, assign) NSInteger timestamp;

- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithType:(NSString *)type andData:(FPData *)data;
- (instancetype)initWithType:(NSString *)type andError:(NSError *)error;
- (instancetype)initWithType:(NSString *)type andPayload:(NSObject *)payload;
- (instancetype)initWithType:(NSString *)type andTimestamp:(NSInteger)timestamp;
- (instancetype)initWithType:(NSString *)type andRetry:(BOOL)retry;
@end

#endif /* EventData_h */
