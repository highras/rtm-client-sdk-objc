//
//  FPProcessor.h
//  fpnn
//
//  Created by dixun on 2018/5/31.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPProcessor_h
#define FPProcessor_h

#import <Foundation/Foundation.h>

@class FPEvent, FPData;

typedef void(^AnswerBlock)(NSObject * payload, BOOL error);

@protocol ProcessorDelegate <NSObject>

@required
- (void) service:(FPData *)data andAnswer:(AnswerBlock)answer;

@required
- (FPEvent *) getEvent;

@optional
- (void) onSecond:(NSInteger)timestamp;
@end

@interface FPProcessor : NSObject

@property (nonatomic, readwrite, strong) id <ProcessorDelegate> processor;

- (void) service:(FPData *)data andAnswer:(AnswerBlock)answer;
- (void) onSecond:(NSInteger)timestamp;
- (FPEvent *) getEvent;
- (void) destroy;
@end

@interface BaseProcessor : NSObject<ProcessorDelegate>

@property(nonatomic, readonly, weak) FPEvent * event;

- (instancetype)initWithEvent:(FPEvent *)event;
@end

#endif /* FPProcessor_h */
