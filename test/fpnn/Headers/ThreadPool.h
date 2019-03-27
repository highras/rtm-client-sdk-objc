//
//  ThreadPool.h
//  fpnn
//
//  Created by dixun on 2018/6/4.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef ThreadPool_h
#define ThreadPool_h

#import <Foundation/Foundation.h>

@class FPEvent, FPConfig;

@protocol ThreadPoolDelegate <NSObject>

@required
- (void) executeOperation:(NSOperation *)operation andQueue:(NSOperationQueue *)queue;

@end


@interface ThreadPool : NSObject

@property (nonatomic, readwrite, strong) dispatch_queue_t queue;
@property (nonatomic, readwrite, strong) dispatch_source_t timer;
@property (nonatomic, readwrite, strong) id <ThreadPoolDelegate> threadPool;

@property(nonatomic, readonly, strong) FPEvent * event;

+ (instancetype) shareInstance;
- (void) executeOperation:(NSOperation *)operation andQueue:(NSOperationQueue *)queue;

- (void) onSecond;
- (void) startTimerThread;
@end


@interface BaseThreadPool : NSObject<ThreadPoolDelegate> {
    
    @private
    NSOperationQueue * _concurrencyQueue;
}
@end

#endif /* ThreadPool_h */
