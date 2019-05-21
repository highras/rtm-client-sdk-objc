//
//  RTMProcessor.m
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#import <MPMessagePack/MPMessagePack.h>
#import "FPEvent.h"
#import "EventData.h"
#import "FPData.h"
#import "RTMProcessor.h"
#import "RTMConfig.h"


@interface RTMProcessor() {
    
}
@end


@implementation RTMProcessor

- (instancetype) initWithEvent:(FPEvent *)event {
    
    if (self = [super init]) {
        
        _event = event;
        _midMap = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}

- (void) destroy {
    
    [self.midMap removeAllObjects];
}

- (void) service:(FPData *)data andAnswer:(AnswerBlock)answer {
    
    NSError * error = nil;
    NSDictionary * payload = nil;
    
    if (data.flag == 0) {
        
        payload = [NSJSONSerialization JSONObjectWithData:[data.json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        NSString * jsonString = @"{}";
        
        id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        answer(json, NO);
    }
    
    if (data.flag == 1) {
        
        payload = [MPMessagePackReader readData:data.msgpack error:&error];
        
        answer([MPMessagePackWriter writeObject:@{} error:nil], NO);
    }
    
    if (error != nil) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:@"error" andError:error]];
        return;
    }
    
    if (payload != nil) {
        
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", data.method]);
        
        if ([self respondsToSelector:sel]) {
            
            typedef void(* QuestMethod) (id, SEL, NSDictionary *);
            IMP imp = [self methodForSelector:sel];
            
            QuestMethod func = (QuestMethod)imp;
            func(self, sel, payload);
        }else{
            
            [self.event fireEvent:[[EventData alloc] initWithType:data.method andPayload:payload]];
        }
    }
}

- (FPEvent *) getEvent {
    
    return self.event;
}

/*
 * @param {NSDictionary}    data
 */
- (void) kickout:(NSDictionary *)data {
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_kickOut andPayload:data]];
}

/*
 * @param {NSInteger}   data.rid
 */
- (void) kickoutroom:(NSDictionary *)data {
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_kickOutRoom andPayload:data]];
}

/*
 * @param {NSInteger}   data.from
 * @param {NSInteger}   data.to
 * @param {NSInteger}   data.mtype
 * @param {NSInteger}   data.mid
 * @param {NSString}    data.msg
 * @param {NSString}    data.attrs
 * @param {NSInteger}   data.mtime
 */
- (void) pushmsg:(NSDictionary *)data {
    
    NSArray * keys = [data allKeys];
    
    if ([keys containsObject:@"mid"]) {
        
        if (![self checkMid:1 :[[data objectForKey:@"mid"] integerValue] :[[data objectForKey:@"from"] integerValue] :0]) {
            
            return;
        }
    }
    
    if ([[data objectForKey:@"mtype"] integerValue] >= 40 && [[data objectForKey:@"mtype"] integerValue] <= 50) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvFile andPayload:data]];
        return;
    }
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvMessage andPayload:data]];
}

/*
 * @param {NSInteger}   data.from
 * @param {NSInteger}   data.gid
 * @param {NSInteger}   data.mtype
 * @param {NSInteger}   data.mid
 * @param {NSString}    data.msg
 * @param {NSString}    data.attrs
 * @param {NSInteger}   data.mtime
 */
- (void) pushgroupmsg:(NSDictionary *)data {
    
    NSArray * keys = [data allKeys];
    
    if ([keys containsObject:@"mid"]) {
        
        if (![self checkMid:2 :[[data objectForKey:@"mid"] integerValue] :[[data objectForKey:@"from"] integerValue] :[[data objectForKey:@"gid"] integerValue]]) {
            
            return;
        }
    }
    
    if ([[data objectForKey:@"mtype"] integerValue] >= 40 && [[data objectForKey:@"mtype"] integerValue] <= 50) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvGroupFile andPayload:data]];
        return;
    }
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvGroupMessage andPayload:data]];
}

/*
 * @param {NSInteger}   data.from
 * @param {NSInteger}   data.rid
 * @param {NSInteger}   data.mtype
 * @param {NSInteger}   data.mid
 * @param {NSString}    data.msg
 * @param {NSString}    data.attrs
 * @param {NSInteger}   data.mtime
 */
- (void) pushroommsg:(NSDictionary *)data {
    
    NSArray * keys = [data allKeys];
    
    if ([keys containsObject:@"mid"]) {
        
        if (![self checkMid:3 :[[data objectForKey:@"mid"] integerValue] :[[data objectForKey:@"from"] integerValue] :[[data objectForKey:@"rid"] integerValue]]) {

            return;
        }
    }
    
    if ([[data objectForKey:@"mtype"] integerValue] >= 40 && [[data objectForKey:@"mtype"] integerValue] <= 50) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvRoomFile andPayload:data]];
        return;
    }
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvRoomMessage andPayload:data]];
}

/*
 * @param {NSInteger}   data.from
 * @param {NSInteger}   data.mtype
 * @param {NSInteger}   data.mid
 * @param {NSString}    data.msg
 * @param {NSString}    data.attrs
 * @param {NSInteger}   data.mtime
 */
- (void) pushbroadcastmsg:(NSDictionary *)data {
    
    NSArray * keys = [data allKeys];
    
    if ([keys containsObject:@"mid"]) {
        
        if (![self checkMid:4 :[[data objectForKey:@"mid"] integerValue] :[[data objectForKey:@"from"] integerValue] :0]) {
            
            return;
        }
    }
    
    if ([[data objectForKey:@"mtype"] integerValue] >= 40 && [[data objectForKey:@"mtype"] integerValue] <= 50) {
        
        [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvBroadcastFile andPayload:data]];
        return;
    }
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvBroadcastMessage andPayload:data]];
}

/*
 * @param {NSDictionary} data
 */
- (void) ping:(NSDictionary *)data {
    
    [self.event fireEvent:[[EventData alloc] initWithType:RTMConfig.SERVER_PUSH_recvPing andPayload:data]];
}

- (void) onSecond:(NSInteger)timestamp {
    
    [self checkExpire:timestamp];
}

- (BOOL) checkMid:(NSInteger)type :(NSInteger)mid :(NSInteger)uid :(NSInteger)rgid {
    
    NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:@(type), @(mid), @(uid), nil];
    
    if (rgid > 0) {
        
        [array addObject:@(rgid)];
    }
    
    NSString * key = [array componentsJoinedByString:@"_"];
    
    @synchronized (self.midMap) {
        
        NSInteger timestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000;
        NSArray * keys = [self.midMap allKeys];
        
        if ([keys containsObject:key]) {
            
            NSInteger expire = [[self.midMap objectForKey:key] integerValue];
            
            if (expire > timestamp) {
                
                return NO;
            }
            
            [self.midMap removeObjectForKey:key];
        }
        
        [self.midMap setObject:@(RTMConfig.MID_TTL + timestamp) forKey:key];
        return YES;
    }
}

- (void) checkExpire:(NSInteger)timestamp {
    
    @synchronized (self.midMap) {
        
        NSMutableArray * keys = [[NSMutableArray alloc] initWithCapacity:0];
        NSEnumerator * keyEnumer = [self.midMap keyEnumerator];
        
        id key = nil;
        
        while (key = [keyEnumer nextObject]) {
            
            NSInteger expire = [[self.midMap objectForKey:key] integerValue];
            
            if (expire > timestamp) {
                
                continue;
            }
            
            [keys addObject:key];
        }
        
        for (id rmkey in keys) {
            
            [self.midMap removeObjectForKey:rmkey];
        }
    }
}
@end
