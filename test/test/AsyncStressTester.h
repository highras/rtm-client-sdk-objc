//
//  AsyncStressTester.h
//  test
//
//  Created by dixun on 2019/3/22.
//  Copyright © 2019 funplus. All rights reserved.
//

#ifndef AsyncStressTester_h
#define AsyncStressTester_h

#import <Foundation/Foundation.h>

@interface AsyncStressTester : NSObject

@end

@class RTMClient, FPData;

@interface Tester : NSObject

@property (nonatomic, readonly, strong) FPData * buffer;
@property (nonatomic, readonly, strong) RTMClient * client;
@property(nonatomic, readonly, assign) NSInteger sleepMills;
@property(nonatomic, readonly, assign) NSInteger batchCount;

- (instancetype) initWithQPS:(NSInteger)qps;
- (void) doTest;

@end

@interface AsyncStressTest : NSObject

- (instancetype) initWithEndpoint:(NSString *)endpoint andCount:(NSInteger)clientCount andQPS:(NSInteger)totalQPS;
- (void) launch;
- (void) showStatistics;

@end

#endif /* AsyncStressTester_h */
