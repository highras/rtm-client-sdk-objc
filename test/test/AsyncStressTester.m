//
//  AsyncStressTester.m
//  test
//
//  Created by dixun on 2019/3/22.
//  Copyright © 2019 funplus. All rights reserved.
//

#import "AsyncStressTester.h"
#import <MPMessagePack/MPMessagePack.h>

#import "ThreadPool.h"
#import "RTMClient.h"
#import "FPData.h"
#import "CallbackData.h"

@interface AsyncStressTester() {
    
}
@end

static NSInteger sendCount;
static NSInteger recvCount;
static NSInteger recvError;
static NSInteger timecost;
static NSString * gate;
static NSMutableArray * threads;

@implementation AsyncStressTester

+ (void) incSend {
    
    @synchronized (AsyncStressTester.class) {
        
        sendCount += 1;
//        NSLog(@"sendCount: %ld", (long)sendCount);
    }
}

+ (void) incRecv {
    
    @synchronized (AsyncStressTester.class) {

        recvCount += 1;
//        NSLog(@"recvCount: %ld", (long)recvCount);
    }
}

+ (void) incRecvError {
    
    @synchronized (AsyncStressTester.class) {
        
        recvError += 1;
//        NSLog(@"recvError: %ld", (long)recvError);
    }
}

+ (void) addTimecost:(NSInteger)cost {
    
    @synchronized (AsyncStressTester.class) {
        
        timecost += cost;
//        NSLog(@"timecost: %ld", (long)timecost);
    }
}

@end


@implementation Tester

- (instancetype) initWithQPS:(NSInteger)qps {
    
    if (self = [super init]) {
        
        _client = [[RTMClient alloc] initWithDispatch:@"52.83.245.22:13325" andPid:1000012 andUid:654321 andToken:@"E397902F2C03C4216D115A488E2F687C" andVersion:@"" andAttrs:@{} andReconnect:YES andTimeout:20 * 1000 andStartTimerThread:YES];
        
        _sleepMills = 1000 / qps;
        _batchCount = 1;
        
        while (_sleepMills == 0) {
            
            _batchCount += 1;
            _sleepMills = 1000 * _batchCount / qps;
        }
        
        NSLog(@"-- single client qps: %ld, sleep millisecond interval: %ld, batch count: %ld", qps, _sleepMills, _batchCount);
    }
    
    _buffer = [self buildStandardTestQuest];
    return self;
}

- (void) doTest {
    
    [self.client connect:gate andTimeout:20 * 1000];

    while (YES) {
        
        NSInteger startTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
        
        for (int i = 0; i < self.batchCount; i++) {
            
            NSInteger sendTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
            
            self.buffer.seq++;
            
            [self.client sendQuestWithData:self.buffer andBlock:^(CallbackData *cbd) {
                
                NSError * err = (NSError *)cbd.error;
                NSDictionary * dict = (NSDictionary *)cbd.payload;
                
                if (err != nil) {
                    
                    [AsyncStressTester incRecvError];
                }
                
                if (dict != nil) {
                    
                    [AsyncStressTester incRecv];
                    
                    NSInteger recvTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
                    NSInteger diffTime = recvTime - sendTime;
                    
                    [AsyncStressTester addTimecost:diffTime / 1000];
                }
            } andTimeout:5 * 1000];
            
            [AsyncStressTester incSend];
        }
        
        NSInteger finishTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
        NSInteger sleepTime = self.sleepMills - (finishTime - startTime) / 1000;
        
        if (sleepTime > 0) {
            
            usleep((int)sleepTime * 1000);
        }
    }
}

- (FPData *) buildStandardTestQuest {
    
    NSArray * arr = @[ @"first_vec", @4 ];
    NSDictionary * dict = @{ @"map1":@"first_map", @"map2":@YES, @"map3":@5, @"map4":@5.4, @"map5":@"中文" };
    NSDictionary * payload = @{ @"quest":@"one", @"int":@2, @"double":@3.3, @"boolean":@YES, @"ARRAY":arr, @"MAP":dict };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"two way demo";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        NSLog(@"%@", error);
    }
    
    buffer.msgpack = data;
    return buffer;
}

@end


@implementation AsyncStressTest

- (instancetype) initWithEndpoint:(NSString *)endpoint andCount:(NSInteger)clientCount andQPS:(NSInteger)totalQPS {
    
    if (self = [super init]) {
        
        [[ThreadPool shareInstance] startTimerThread];
        
        gate = endpoint;
        threads = [[NSMutableArray alloc] init];

        NSInteger qps = totalQPS / clientCount;
        
        if (qps == 0) {
            
            qps = 1;
        }
        
        NSInteger remain = totalQPS - qps * clientCount;
        
        for (int i = 0; i < clientCount; i++) {
            
            [threads addObject:[[Tester alloc] initWithQPS:qps]];
        }
        
        if (remain > 0) {
            
            [threads addObject:[[Tester alloc] initWithQPS:qps]];
        }
    }
    
    return self;
}

- (void) launch {
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    for (Tester * tester in threads) {
        
        NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
            
            [tester doTest];
        }];
        
        [queue addOperation:operation];
    }
}

- (void) showStatistics {
    
    NSInteger sleepSeconds = 3;
    
    NSInteger sendSt;
    NSInteger recvSt;
    NSInteger recvErrorSt;
    NSInteger timecostSt;
    
    @synchronized(self) {
        
        sendSt = sendCount;
        recvSt = recvCount;
        recvErrorSt = recvError;
        timecostSt = timecost;
    }

    while (YES) {
        
        NSInteger start = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
        
        usleep((int)(sleepSeconds * 1000 * 1000));
        
        NSInteger s;
        NSInteger r;
        NSInteger re;
        NSInteger tc;
        
        @synchronized(self) {
            
            s = sendCount;
            r = recvCount;
            re = recvError;
            tc = timecost;
        }

        NSInteger ent = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000 * 1000;
        
        NSInteger ds = s - sendSt;
        NSInteger dr = r - recvSt;
        NSInteger dre = re - recvErrorSt;
        NSInteger dtc = tc - timecostSt;
        
        sendSt = s;
        recvSt = r;
        recvErrorSt = re;
        timecostSt = tc;
        
        NSInteger real_time = ent - start;
        
        if (dr > 0) {
            
            dtc = dtc / dr;
        }

        ds = ds * 1000 * 1000 / real_time;
        dr = dr * 1000 * 1000 / real_time;

        NSLog(@"time interval: @%f ms, recv error: @%ld", real_time / 1000.0, dre);
        NSLog(@"[QPS] send: @%ld, recv: @%ld, per quest time cost: @%ld usec", ds, dr, dtc);
    }
}

@end

