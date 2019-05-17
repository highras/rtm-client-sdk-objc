//
//  RTMClient.m
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#import "RTMClient.h"
#import <MPMessagePack/MPMessagePack.h>
#import <CommonCrypto/CommonCrypto.h>

#import "RTMConfig.h"
#import "RTMProcessor.h"

#import "FPEvent.h"
#import "EventData.h"
#import "CallbackData.h"
#import "FPData.h"
#import "FPPackage.h"
#import "ThreadPool.h"

@interface RTMClient() {
    
}
@end


@implementation RTMClient

- (NSInteger) midGen {
    
    @synchronized (self) {

        extern NSInteger count;

        if (++count >= 999) {
            
            count = 0;
        }

        NSString * strFix = [NSString stringWithFormat:@"%ld", (long)count];
        
        if (count < 100) {
            
            strFix = [@"0" stringByAppendingString:strFix];
        }
        
        if (count < 10) {
            
            strFix = [@"0" stringByAppendingString:strFix];
        }

        NSInteger timestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000;
        return [[[NSString stringWithFormat:@"%ld", (long)timestamp] stringByAppendingString:strFix] integerValue];
    }
}

- (instancetype) initWithDispatch:(NSString *)dispatch andPid:(NSInteger)pid andUid:(NSInteger)uid andToken:(NSString *)token andVersion:(NSString *)version andAttrs:(NSDictionary *)attrs andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread {
    
    if (self = [super init]) {
        
        _dispatch = dispatch;
        _pid = pid;
        _uid = uid;
        _token = token;
        _version = (version != nil) ? version:@"";
        _attrs = attrs;
        _reconnect = reconnect;
        _timeout = timeout ? timeout : 30 * 1000;
        _startTimerThread = startTimerThread;
        
        _event = [[FPEvent alloc] init];
        _processor = [[RTMProcessor alloc] initWithEvent:_event];
    }
    
    [self initProcessor];
    return self;
}

/*
 *  Private Method
 */
- (void) initProcessor {
    
    [self.processor.event addType:RTMConfig.SERVER_PUSH_kickOut andListener:^(EventData *evd) {
       
        self.isClose = YES;
    }];
}

- (void) sendQuestWithData:(FPData *)data andBlock:(CallbackBlock)callback {
    
    if (self.baseClient != nil) {
        
        [self.baseClient sendQuest:data andBlock:callback];
    }
}

- (void) sendQuestWithData:(FPData *)data andBlock:(CallbackBlock)callback andTimeout:(NSInteger)timeout {
    
    if (self.baseClient != nil) {
        
        [self.baseClient sendQuest:data andBlock:callback andTimeout:timeout];
    }
}

- (void) destroy {
    
    [self close];
    
    [self.baseClient destroy];
    _baseClient = nil;
    
    [self.dispatchClient destroy];
    _dispatchClient = nil;
    
    [self.event removeAll];
}

- (void) loginWithEndpoint:(NSString *)endpoint andIPv6:(BOOL)ipv6 {
    
    _endpoint = endpoint;
    _ipv6 = ipv6;
    _isClose = NO;

    if (self.endpoint != nil) {
        
        [self connGateWithTimeout:self.timeout];
        return;
    }
    
    if (self.dispatchClient == nil) {
        
        _dispatchClient = [[DispatchClient alloc] init];

        [self.dispatchClient.event addType:@"close" andListener:^(EventData * evd) {
            
            NSLog(@"[DispatchClient] closed.");
            
            if (self.dispatchClient != nil) {
                
                [self.dispatchClient destroy];
                self.dispatchClient = nil;
            }

            if (self.endpoint == nil) {
                
                [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"dispatch client close with err!" code:0 userInfo:nil]]];
                
                [self reConnect];
            }
        }];
        
        [self.dispatchClient initWithEndpoint:self.dispatch andTimeout:self.timeout andStartTimerThread:self.startTimerThread];
    }
    
    NSDictionary * payload = @{ @"pid": @(self.pid), @"uid": @(self.uid), @"what": @"rtmGated", @"addrType": self.ipv6 ? @"ipv6" : @"ipv4", @"version": self.version };

    [self.dispatchClient whichWithPayload:payload andTimeout:self.timeout andBlock:^(CallbackData *cbd) {
        
        NSError * err = (NSError *)cbd.error;
        NSDictionary * dict = (NSDictionary *)cbd.payload;

        if (dict != nil) {

            NSString * endpoint = [dict objectForKey:@"endpoint"];
            [self loginWithEndpoint:endpoint andIPv6:self.ipv6];
        }

        if (err != nil) {
            
            [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:err]];
        }
    }];
}

/*
 * rtmGate (2)
 */
- (void) sendMessage:(NSInteger)to andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (mid == 0) {
        
        mid = [self midGen];
    }
    
    if ([self.baseClient isBlankString:attrs]) {
        
        attrs = @"";
    }
    
    if ([self.baseClient isBlankString:msg]) {
        
        msg = @"";
    }
    
    NSDictionary * payload = @{ @"to":@(to), @"mid":@(mid), @"mtype":@(mtype), @"msg":msg, @"attrs":attrs };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"sendmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        cbd.mid = mid;
        
        if (callback != nil) {
            
            callback(cbd);
        }
    } andTimeout:timeout];
}

/*
 * rtmGate (3)
 */
- (void) sendGroupMessage:(NSInteger)gid andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (mid == 0) {
        
        mid = [self midGen];
    }
    
    if ([self.baseClient isBlankString:attrs]) {
        
        attrs = @"";
    }
    
    if ([self.baseClient isBlankString:msg]) {
        
        msg = @"";
    }
    
    NSDictionary * payload = @{ @"gid":@(gid), @"mid":@(mid), @"mtype":@(mtype), @"msg":msg, @"attrs":attrs };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"sendgroupmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        cbd.mid = mid;
        
        if (callback != nil) {
            
            callback(cbd);
        }
    } andTimeout:timeout];
}

/*
 * rtmGate (4)
 */
- (void) sendRoomMessage:(NSInteger)rid andMtype:(NSInteger)mtype andMessage:(NSString *)msg andAttrs:(NSString *)attrs andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (mid == 0) {
        
        mid = [self midGen];
    }
    
    if ([self.baseClient isBlankString:attrs]) {
        
        attrs = @"";
    }
    
    if ([self.baseClient isBlankString:msg]) {
        
        msg = @"";
    }
    
    NSDictionary * payload = @{ @"rid":@(rid), @"mid":@(mid), @"mtype":@(mtype), @"msg":msg, @"attrs":attrs };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"sendroommsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        cbd.mid = mid;
        
        if (callback != nil) {
            
            callback(cbd);
        }
    } andTimeout:timeout];
}

/*
 * rtmGate (5)
 */
- (void) getUnreadMessage:(NSInteger)timeout andBlock:(CallbackBlock)callback {

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getunreadmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (6)
 */
- (void) cleanUnreadMessage:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"cleanunreadmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (7)
 */
- (void) getSession:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getsession";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (8)
 */
- (void) getGroupMessage:(NSInteger)gid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:@(gid) forKey:@"gid"];
    [payload setObject:@(desc) forKey:@"desc"];
    [payload setObject:@(num) forKey:@"num"];
    
    if (begin > 0) {
        
        [payload setObject:@(begin) forKey:@"begin"];
    }
    
    if (end > 0) {
        
        [payload setObject:@(end) forKey:@"end"];
    }
    
    if (lastid > 0) {
        
        [payload setObject:@(lastid) forKey:@"lastid"];
    }
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getgroupmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSMutableDictionary * dict = nil;
        
        if (cbd.payload != nil) {
            
            dict = [[NSMutableDictionary alloc] initWithDictionary: (NSDictionary *)cbd.payload];
        }

        if (dict != nil) {
            
            NSArray * arr = [dict objectForKey:@"msgs"];
            NSInteger count = arr.count;
            
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];

            for ( int index = 0; index < count; index++) {
                
                NSArray * tmp_arr = (NSArray *)[arr objectAtIndex:index];
                NSDictionary * tmp_dict = @{
                                            @"id":[tmp_arr objectAtIndex:0],
                                            @"from":[tmp_arr objectAtIndex:1],
                                            @"mtype":[tmp_arr objectAtIndex:2],
                                            @"mid":[tmp_arr objectAtIndex:3],
                                            @"deleted":[tmp_arr objectAtIndex:4],
                                            @"msg":[tmp_arr objectAtIndex:5],
                                            @"attrs":[tmp_arr objectAtIndex:6],
                                            @"mtime":[tmp_arr objectAtIndex:7]
                                            };
                
                [marr replaceObjectAtIndex:index withObject:tmp_dict];
            }
            
            [dict setObject:marr forKey:@"msgs"];
            
            callback([[CallbackData alloc] initWithPayload:dict]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (9)
 */
- (void) getRoomMessage:(NSInteger)rid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:@(rid) forKey:@"rid"];
    [payload setObject:@(desc) forKey:@"desc"];
    [payload setObject:@(num) forKey:@"num"];
    
    if (begin > 0) {
        
        [payload setObject:@(begin) forKey:@"begin"];
    }
    
    if (end > 0) {
        
        [payload setObject:@(end) forKey:@"end"];
    }
    
    if (lastid > 0) {
        
        [payload setObject:@(lastid) forKey:@"lastid"];
    }
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getroommsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSMutableDictionary * dict = nil;
        
        if (cbd.payload != nil) {
            
            dict = [[NSMutableDictionary alloc] initWithDictionary: (NSDictionary *)cbd.payload];
        }
        
        if (dict != nil) {
            
            NSArray * arr = [dict objectForKey:@"msgs"];
            NSInteger count = arr.count;
            
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];
            
            for ( int index = 0; index < count; index++) {
                
                NSArray * tmp_arr = (NSArray *)[arr objectAtIndex:index];
                NSDictionary * tmp_dict = @{
                                            @"id":[tmp_arr objectAtIndex:0],
                                            @"from":[tmp_arr objectAtIndex:1],
                                            @"mtype":[tmp_arr objectAtIndex:2],
                                            @"mid":[tmp_arr objectAtIndex:3],
                                            @"deleted":[tmp_arr objectAtIndex:4],
                                            @"msg":[tmp_arr objectAtIndex:5],
                                            @"attrs":[tmp_arr objectAtIndex:6],
                                            @"mtime":[tmp_arr objectAtIndex:7]
                                            };
                
                [marr replaceObjectAtIndex:index withObject:tmp_dict];
            }
            
            [dict setObject:marr forKey:@"msgs"];
            
            callback([[CallbackData alloc] initWithPayload:dict]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (10)
 */
- (void) getBroadcastMessage:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:@(desc) forKey:@"desc"];
    [payload setObject:@(num) forKey:@"num"];
    
    if (begin > 0) {
        
        [payload setObject:@(begin) forKey:@"begin"];
    }
    
    if (end > 0) {
        
        [payload setObject:@(end) forKey:@"end"];
    }
    
    if (lastid > 0) {
        
        [payload setObject:@(lastid) forKey:@"lastid"];
    }
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getbroadcastmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSMutableDictionary * dict = nil;
        
        if (cbd.payload != nil) {
            
            dict = [[NSMutableDictionary alloc] initWithDictionary: (NSDictionary *)cbd.payload];
        }
        
        if (dict != nil) {
            
            NSArray * arr = [dict objectForKey:@"msgs"];
            NSInteger count = arr.count;
            
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];
            
            for ( int index = 0; index < count; index++) {
                
                NSArray * tmp_arr = (NSArray *)[arr objectAtIndex:index];
                NSDictionary * tmp_dict = @{
                                            @"id":[tmp_arr objectAtIndex:0],
                                            @"from":[tmp_arr objectAtIndex:1],
                                            @"mtype":[tmp_arr objectAtIndex:2],
                                            @"mid":[tmp_arr objectAtIndex:3],
                                            @"deleted":[tmp_arr objectAtIndex:4],
                                            @"msg":[tmp_arr objectAtIndex:5],
                                            @"attrs":[tmp_arr objectAtIndex:6],
                                            @"mtime":[tmp_arr objectAtIndex:7]
                                            };
                
                [marr replaceObjectAtIndex:index withObject:tmp_dict];
            }
            
            [dict setObject:marr forKey:@"msgs"];
            
            callback([[CallbackData alloc] initWithPayload:dict]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (11)
 */
- (void) getP2PMessage:(NSInteger)ouid andDesc:(BOOL)desc andNumber:(NSInteger)num andBegin:(NSInteger)begin andEnd:(NSInteger)end andLastID:(NSInteger)lastid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:@(ouid) forKey:@"ouid"];
    [payload setObject:@(desc) forKey:@"desc"];
    [payload setObject:@(num) forKey:@"num"];
    
    if (begin > 0) {
        
        [payload setObject:@(begin) forKey:@"begin"];
    }
    
    if (end > 0) {
        
        [payload setObject:@(end) forKey:@"end"];
    }
    
    if (lastid > 0) {
        
        [payload setObject:@(lastid) forKey:@"lastid"];
    }
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getp2pmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSMutableDictionary * dict = nil;
        
        if (cbd.payload != nil) {
            
            dict = [[NSMutableDictionary alloc] initWithDictionary: (NSDictionary *)cbd.payload];
        }
        
        if (dict != nil) {
            
            NSArray * arr = [dict objectForKey:@"msgs"];
            NSInteger count = arr.count;
            
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];
            
            for ( int index = 0; index < count; index++) {
                
                NSArray * tmp_arr = (NSArray *)[arr objectAtIndex:index];
                NSDictionary * tmp_dict = @{
                                            @"id":[tmp_arr objectAtIndex:0],
                                            @"direction":[tmp_arr objectAtIndex:1],
                                            @"mtype":[tmp_arr objectAtIndex:2],
                                            @"mid":[tmp_arr objectAtIndex:3],
                                            @"deleted":[tmp_arr objectAtIndex:4],
                                            @"msg":[tmp_arr objectAtIndex:5],
                                            @"attrs":[tmp_arr objectAtIndex:6],
                                            @"mtime":[tmp_arr objectAtIndex:7]
                                            };
                
                [marr replaceObjectAtIndex:index withObject:tmp_dict];
            }
            
            [dict setObject:marr forKey:@"msgs"];
            
            callback([[CallbackData alloc] initWithPayload:dict]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (12)
 */
- (void) fileToken:(NSString *)cmd andTos:(NSArray *)tos andTo:(NSInteger)to andRid:(NSInteger)rid andGid:(NSInteger)gid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:cmd forKey:@"cmd"];
    
    if (tos != nil && tos.count > 0) {
        
        [payload setObject:tos forKey:@"tos"];
    }
    
    if (to > 0) {
        
        [payload setObject:@(to) forKey:@"to"];
    }
    
    if (rid > 0) {
        
        [payload setObject:@(rid) forKey:@"rid"];
    }
    
    if (gid > 0) {
        
        [payload setObject:@(gid) forKey:@"gid"];
    }
    
    [self fileTokenWithPayload:payload andTimeout:timeout andBlock:callback];
}

/*
 * rtmGate (13)
 */
- (void) close {
    
    _isClose = YES;
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"bye";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        [self.baseClient close];
    }];
}

/*
 * rtmGate (14)
 */
- (void) addAttrs:(NSDictionary *)attrs andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"attrs":attrs };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"addattrs";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (15)
 */
- (void) getAttrs:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getattrs";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (16)
 */
- (void) addDebugLog:(NSString *)msg andAttrs:(NSString *)attrs andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"msg":msg, @"attrs":attrs };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"adddebuglog";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (17)
 */
- (void) addDevice:(NSString *)apptype andDeviceToken:(NSString *)devicetoken andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"apptype":apptype, @"devicetoken":devicetoken };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"adddevice";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (18)
 */
- (void) removeDevice:(NSString *)devicetoken andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"devicetoken":devicetoken };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"removedevice";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (19)
 */
- (void) setTranslationLanguage:(NSString *)targetLanguage andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"lang":targetLanguage };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"setlang";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (20)
 */
- (void) translate:(NSString *)originalMessage andOriginalLanguage:(NSString *)originalLanguage andTargetLanguage:(NSString *)targetLanguage andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];
    
    [payload setObject:originalMessage forKey:@"text"];
    [payload setObject:targetLanguage forKey:@"dst"];
    
    if (![self.baseClient isBlankString:originalLanguage]) {
        
        [payload setObject:targetLanguage forKey:@"src"];
    }

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"translate";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (21)
 */
- (void) addFriends:(NSArray *)friends andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"friends":friends };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"addfriends";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (22)
 */
- (void) deleteFriends:(NSArray *)friends andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"friends":friends };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"delfriends";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (23)
 */
- (void) getFriends:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getfriends";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (24)
 */
- (void) addGroupMembers:(NSInteger)gid andUIDs:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"gid":@(gid), @"uids":uids };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"addgroupmembers";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (25)
 */
- (void) deleteGroupMembers:(NSInteger)gid andUIDs:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"gid":@(gid), @"uids":uids };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"delgroupmembers";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (26)
 */
- (void) getGroupMembers:(NSInteger)gid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"gid":@(gid) };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getgroupmembers";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            callback([[CallbackData alloc] initWithPayload:[dict objectForKey:@"uids"]]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (27)
 */
- (void) getUserGroups:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getusergroups";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            callback([[CallbackData alloc] initWithPayload:[dict objectForKey:@"gids"]]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (28)
 */
- (void) enterRoom:(NSInteger)rid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"rid":@(rid) };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"enterroom";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (29)
 */
- (void) leaveRoom:(NSInteger)rid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"rid":@(rid) };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"leaveroom";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (30)
 */
- (void) getUserRooms:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getuserrooms";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:@{} error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            callback([[CallbackData alloc] initWithPayload:[dict objectForKey:@"rooms"]]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (31)
 */
- (void) getOnlineUsers:(NSArray *)uids andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"uids":uids };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"getonlineusers";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            callback([[CallbackData alloc] initWithPayload:[dict objectForKey:@"uids"]]);
            return;
        }
        
        callback(cbd);
    } andTimeout:timeout];
}

/*
 * rtmGate (32)
 */
- (void) deleteMessage:(NSInteger)mid andXID:(NSInteger)xid andType:(NSInteger)type andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"mid":@(mid), @"xid":@(xid), @"type":@(type) };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"delmsg";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (33)
 */
- (void) kickout:(NSString *)ce andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"ce":ce };

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"kickout";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (34)
 */
- (void) dbGet:(NSString *)key andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"key":key };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"dbget";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * rtmGate (35)
 */
- (void) dbSet:(NSString *)key andValue:(NSString *)value andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSDictionary * payload = @{ @"key":key, @"val":value };
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"dbset";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 * fileGate (1)
 */
- (void) sendFile:(NSInteger)mtype andTo:(NSInteger)to andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (fileData == nil || fileData.length <= 0) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"empty file bytes!" code:0 userInfo:nil]]];
        return;
    }
    
    NSDictionary * payload = @{ @"cmd":@"sendfile", @"to":@(to), @"mtype":@(mtype), @"file":fileData };
    
    [self fileSendProcessWithOptions:payload andMid:mid andTimeout:timeout andBlock:callback];
}

/*
 * fileGate (3)
 */
- (void) sendGroupFile:(NSInteger)mtype andGid:(NSInteger)gid andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (fileData == nil || fileData.length <= 0) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"empty file bytes!" code:0 userInfo:nil]]];
        return;
    }
    
    NSDictionary * payload = @{ @"cmd":@"sendgroupfile", @"gid":@(gid), @"mtype":@(mtype), @"file":fileData };
    
    [self fileSendProcessWithOptions:payload andMid:mid andTimeout:timeout andBlock:callback];
}

/*
 * fileGate (4)
 */
- (void) sendRoomFile:(NSInteger)mtype andRid:(NSInteger)rid andFile:(NSData *)fileData andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (fileData == nil || fileData.length <= 0) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"empty file bytes!" code:0 userInfo:nil]]];
        return;
    }
    
    NSDictionary * payload = @{ @"cmd":@"sendroomfile", @"rid":@(rid), @"mtype":@(mtype), @"file":fileData };
    
    [self fileSendProcessWithOptions:payload andMid:mid andTimeout:timeout andBlock:callback];
}

/*
 *  Private Method
 */
- (void) reConnect {
    
    if (!self.reconnect) {
        
        return;
    }
    
    if (self.isClose) {
        
        return;
    }
    
    [self loginWithEndpoint:self.endpoint andIPv6:self.ipv6];
}

/*
 *  Private Method
 */
- (void) fileSendProcessWithOptions:(NSDictionary *)options andMid:(NSInteger)mid andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSArray * keys = [options allKeys];
    NSMutableDictionary * payload = [NSMutableDictionary dictionary];

    [payload setObject:[options objectForKey:@"cmd"] forKey:@"cmd"];

    if ([keys containsObject:@"tos"]) {
        
        [payload setObject:[options objectForKey:@"tos"] forKey:@"tos"];
    }
    
    if ([keys containsObject:@"to"]) {
        
        [payload setObject:[options objectForKey:@"to"] forKey:@"to"];
    }
    
    if ([keys containsObject:@"rid"]) {
        
        [payload setObject:[options objectForKey:@"rid"] forKey:@"rid"];
    }
    
    if ([keys containsObject:@"gid"]) {
        
        [payload setObject:[options objectForKey:@"gid"] forKey:@"gid"];
    }

    [self fileTokenWithPayload:payload andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        if (cbd.error != nil) {
            
            [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:cbd.error]];
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSString * token = [dict objectForKey:@"token"];
            NSString * endpoint = [dict objectForKey:@"endpoint"];

            if ([self.baseClient isBlankString:token] || [self.baseClient isBlankString:endpoint]) {
                
                [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"file token error" code:0 userInfo:nil]]];
                return;
            }
            
            FileClient * fileClient = [[FileClient alloc] init];
            [fileClient initWithEndpoint:endpoint andTimeout:timeout andStartTimerThread:NO];
            
            NSInteger num_mid = mid != 0 ? mid : [self midGen];
            NSMutableDictionary * data = [NSMutableDictionary dictionary];

            [data setObject:@(self.pid) forKey:@"pid"];
            [data setObject:[options objectForKey:@"mtype"] forKey:@"mtype"];
            [data setObject:@(num_mid) forKey:@"mid"];
            [data setObject:@(self.uid) forKey:@"from"];
            
            if ([keys containsObject:@"tos"]) {
                
                [data setObject:[options objectForKey:@"tos"] forKey:@"tos"];
            }
            
            if ([keys containsObject:@"to"]) {
                
                [data setObject:[options objectForKey:@"to"] forKey:@"to"];
            }
            
            if ([keys containsObject:@"rid"]) {
                
                [data setObject:[options objectForKey:@"rid"] forKey:@"rid"];
            }
            
            if ([keys containsObject:@"gid"]) {
                
                [data setObject:[options objectForKey:@"gid"] forKey:@"gid"];
            }
            
            [fileClient sendWithMethod:[options objectForKey:@"cmd"] andFileData:[options objectForKey:@"file"] andToken:token andPayload:data andTimeout:timeout andBlock:callback];
        }
    }];
}

/*
 *  Private Method
 */
- (void) fileTokenWithPayload:(NSDictionary *)payload andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    FPData * buffer = [[FPData alloc] init];
    
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"filetoken";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    [self sendQuestWithData:buffer andBlock:callback andTimeout:timeout];
}

/*
 *  Private Method
 */
- (void) connGateWithTimeout:(NSInteger)timeout {
    
    if (self.baseClient != nil) {
        
        [self.baseClient destroy];
    }
    
    _baseClient = [[BaseClient alloc] init];
    
    [self.baseClient initWithEndpoint:self.endpoint andReconnect:NO andTimeout:timeout andStartTimerThread:self.startTimerThread];

    [self.baseClient.event addType:@"connect" andListener:^(EventData * evd) {
        
        [self authWithTimeout:timeout];
    }];
    
    [self.baseClient.event addType:@"close" andListener:^(EventData * evd) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"close" andRetry:!self.isClose && self.reconnect]];
        
        self.endpoint = nil;
        [self reConnect];
    }];
    
    [self.baseClient.event addType:@"error" andListener:^(EventData * evd) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:evd.error]];
    }];
    
    self.baseClient.psr.processor = self.processor;
    [self.baseClient connect];
}

/*
 *  Private Method
 *  rtmGate (1)
 */
- (void) authWithTimeout:(NSInteger)timeout {
    
    NSDictionary * payload = @{ @"pid": @(self.pid), @"uid": @(self.uid), @"token": self.token, @"version": self.version, @"attrs": self.attrs };
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }

    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"auth";
    buffer.msgpack = data;

    [self sendQuestWithData:buffer andBlock:^(CallbackData *cbd) {
        
        if (cbd.error != nil) {
            
            [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:cbd.error]];
            [self reConnect];
            return;
        }
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;

        if (dict != nil) {
            
            BOOL OK = [[dict objectForKey:@"ok"] boolValue];
            
            if (OK) {
                
                [self.event fireEvent:[[EventData alloc] initWithType:@"login" andPayload:self.endpoint]];
                return;
            }
            
            NSString * gate = [dict objectForKey:@"gate"];
            
            if (gate != nil) {
                
                self.endpoint = gate;
                [self reConnect];
                return;
            }
            
            if (!OK) {
                
                [self.event fireEvent:[[EventData alloc] initWithType:@"login" andError:[NSError errorWithDomain:@"token error" code:0 userInfo:nil]]];
                return;
            }
        }
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"auth error" code:0 userInfo:nil]]];
    } andTimeout:timeout];
}

// just for testcase
- (void) connect:(NSString *)endpoint andTimeout:(NSInteger)timeout {
    
    self.endpoint = endpoint;
    
    if (self.baseClient != nil) {
        
        [self.baseClient destroy];
    }
    
    _baseClient = [[BaseClient alloc] init];
    
    [self.baseClient initWithEndpoint:self.endpoint andReconnect:NO andTimeout:timeout andStartTimerThread:self.startTimerThread];

    [self.baseClient.event addType:@"connect" andListener:^(EventData * evd) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"connect"]];
    }];
    
    [self.baseClient.event addType:@"close" andListener:^(EventData * evd) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"close" andRetry:!self.isClose && self.reconnect]];
        [self.baseClient.event removeAll];
        [self reConnect];
    }];
    
    [self.baseClient.event addType:@"error" andListener:^(EventData * evd) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:evd.error]];
    }];
    
    self.baseClient.psr.processor = self.processor;
    [self.baseClient connect];
}

@end


@implementation BaseClient

- (void) initWithEndpoint:(NSString *)endpoint andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread {
    
    [super initWithEndpoint:endpoint andReconnect:reconnect andTimeout:timeout];
    
    if (startTimerThread) {
        
        [[ThreadPool shareInstance] startTimerThread];
    }
}

- (void) sendQuest:(FPData *)data andBlock:(CallbackBlock)callback {
    
    [super sendQuest:data andBlock:[self questWithBlock:callback]];
}

- (void) sendQuest:(FPData *)data andBlock:(CallbackBlock)callback andTimeout:(NSInteger)timeout {
    
    [super sendQuest:data andBlock:[self questWithBlock:callback] andTimeout:timeout];
}

- (NSString *) md5WithData:(NSData *)data {
    
    const char * charStr = [data bytes];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(charStr, (CC_LONG)data.length, result);
    
    NSMutableString * hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

- (NSString *) md5WithString:(NSString *)str {
    
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self md5WithData:data];
}

- (BOOL) isBlankString:(NSString *)str {
    
    if (!str) {
        
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * trimmedStr = [str stringByTrimmingCharactersInSet:set];
    
    if (!trimmedStr.length) {
        
        return YES;
    }
    
    return NO;
}

/*
 *  Private Method
 */
- (CallbackBlock) questWithBlock:(CallbackBlock)callback {
    
    CallbackBlock block = ^(CallbackData *cbd) {
        
        if (callback == nil) {
            
            return;
        }
        
        [self checkWithData:cbd];
        callback(cbd);
    };
    
    return block;
}

/*
 *  Private Method
 */
- (void) checkWithData:(CallbackData *)cbd{
    
    NSError * error = nil;
    NSDictionary * payload = nil;
    
    FPData * data = cbd.data;
    
    BOOL isAnswerErr = NO;
    
    if (data != nil) {
        
        if (data.flag == 0) {
            
            payload = [NSJSONSerialization JSONObjectWithData:[data.json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        }
        
        if (data.flag == 1) {
            
            payload = [MPMessagePackReader readData:data.msgpack error:&error];
        }
        
        if (error != nil) {
            
            [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
        }
        
        if ([self.pkg isAnswer:data]) {
            
            isAnswerErr = data.ss != 0 ? YES : NO;
        }
    }
    
    [cbd checkError:payload andIsAnswerErr:isAnswerErr];
}

@end


@implementation DispatchClient

- (void) initWithEndpoint:(NSString *)endpoint andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread {
    
    [super initWithEndpoint:endpoint andReconnect:NO andTimeout:timeout andStartTimerThread:startTimerThread];

    [self.event addType:@"connect" andListener:^(EventData * evd) {
        
        [self onConnect_DispatchClient];
    }];
    
    [self.event addType:@"error" andListener:^(EventData * evd) {
        
        [self onError_DispatchClient:evd.error];
    }];
}

- (void) whichWithPayload:(NSDictionary *)payload andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    if (![self hasConnect]) {
        
        [self connect];
    }
    
    FPData * buffer = [[FPData alloc] init];
    
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = @"which";
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:payload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;

    [self sendQuest:buffer andBlock:callback andTimeout:timeout];
}

/*
 *  Private Method
 */
- (void) onConnect_DispatchClient {
    
    NSLog(@"[DispatchClient] connected.");
}

/*
 *  Private Method
 */
- (void) onError_DispatchClient:(NSError *)error {
    
//    NSLog(@"[DispatchClient] error: %@", error);
}

@end


@implementation FileClient

- (void) initWithEndpoint:(NSString *)endpoint andTimeout:(NSInteger)timeout andStartTimerThread:(BOOL)startTimerThread {
    
    [super initWithEndpoint:endpoint andReconnect:NO andTimeout:timeout andStartTimerThread:startTimerThread];

    [self.event addType:@"connect" andListener:^(EventData * evd) {
        
        [self onConnect_FileClient];
    }];
    
    [self.event addType:@"close" andListener:^(EventData * evd) {
        
        [self onClose_FileClient];
    }];
    
    [self.event addType:@"error" andListener:^(EventData * evd) {
        
        [self onError_FileClient:evd.error];
    }];
}

- (void) sendWithMethod:(NSString *)method andFileData:(NSData *)file andToken:(NSString *)token andPayload:(NSDictionary *)payload andTimeout:(NSInteger)timeout andBlock:(CallbackBlock)callback {
    
    NSString * fileMD5 = [self md5WithData:file];
    NSString * sign = [self md5WithString:[NSString stringWithFormat:@"%@:%@", fileMD5, token]];

    if ([self isBlankString:sign]) {
        
        [self.event fireEvent: [[EventData alloc] initWithType:@"error" andError:[NSError errorWithDomain:@"wrong sign" code:0 userInfo:nil]]];
        return;
    }
    
    if (![self hasConnect]) {
        
        [self connect];
    }
    
    NSDictionary * attrs = @{@"sign":sign};
    NSData * json = [NSJSONSerialization dataWithJSONObject:attrs options:NSJSONWritingPrettyPrinted error:nil];
    
    
    NSMutableDictionary * mutPayload = [payload mutableCopy];
    
    mutPayload[@"token"] = token;
    mutPayload[@"file"] = file;
    mutPayload[@"attrs"] = json;
    
    FPData * buffer = [[FPData alloc] init];
    buffer.flag = 0x1;
    buffer.mtype = 0x1;
    buffer.method = method;
    
    NSError * error = nil;
    NSData * data = [MPMessagePackWriter writeObject:mutPayload error:&error];
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
    }
    
    buffer.msgpack = data;
    
    NSInteger mid = [[payload objectForKey:@"mid"] integerValue];
    
    [self sendQuest:buffer andBlock:^(CallbackData *cbd) {
        
        cbd.mid = mid;
        
        [self destroy];
        
        if (callback != nil) {
            
            callback(cbd);
        }
    } andTimeout:timeout];
}

/*
 *  Private Method
 */
- (void) onConnect_FileClient {
    
    NSLog(@"[FileClient] connected.");
}

/*
 *  Private Method
 */
- (void) onClose_FileClient {
    
    NSLog(@"[FileClient] closed.");
    [self destroy];
}

/*
 *  Private Method
 */
- (void) onError_FileClient:(NSError *)error {
    
    NSLog(@"[FileClient] error: %@", error);
}

@end

