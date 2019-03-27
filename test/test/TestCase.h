//
//  TestCase.h
//  test
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef TestCase_h
#define TestCase_h

#import <Foundation/Foundation.h>

@class RTMClient;

@interface TestCase : NSObject

@property(nonatomic, readonly, strong) NSData * fileData;
@property (nonatomic, readonly, strong) RTMClient * client;

@property(nonatomic, readonly, assign) NSInteger sleep_count;

- (instancetype) initWithFile:(NSData *)fileData;
- (void) beginTest;

@end

#endif /* TestCase_h */
