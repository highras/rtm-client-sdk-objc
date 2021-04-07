//
//  RtmErrorLog.m
//  Rtm
//
//  Created by 张世良 on 2021/2/26.
//  Copyright © 2021 FunPlus. All rights reserved.
//

#import "RtmErrorLog.h"

@implementation RtmErrorLog
+ (instancetype)sharedManager {
    static RtmErrorLog *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RtmErrorLog alloc] init] ;
        _sharedManager.weakTable = [NSHashTable weakObjectsHashTable];
    });

    return _sharedManager;
}
+(void)exportErrorLog:(NSString*)log{
//    NSLog(@"exportErrorLog %@",log);
    for (RTMClient * client in [RtmErrorLog sharedManager].weakTable) {
        if ([log containsString:[NSString stringWithFormat:@"(pid:%lld)",client.projectId]]) {
            if ([client.delegate respondsToSelector:@selector(rtmErrorLog:)]) {
                [client.delegate rtmErrorLog:log];
            }
        }
    }
}
+(void)exportErrorLogNeedTime:(NSString*)log{
    if (log.length > 0) {
        NSString * logResult = [NSString stringWithFormat:@"[%@]~%@",[RtmErrorLog getTime],log];
        [RtmErrorLog exportErrorLog:logResult];
    }
}
+ (NSString*)getTime{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    fmt.dateFormat = @"yyyy-MM-dd kk:mm:ss";
    NSDate *date = [NSDate date];
    NSString *timeString = [fmt stringFromDate:date];
    return timeString;
}
+(void)registerClient:(RTMClient*)client{
    @synchronized ([RtmErrorLog sharedManager]) {
        @autoreleasepool {
            NSHashTable * tmpTab = [NSHashTable weakObjectsHashTable];
            [tmpTab addObject:client];
            for (RTMClient * client in [RtmErrorLog sharedManager].weakTable) {
                [tmpTab addObject:client];
            }
            [RtmErrorLog sharedManager].weakTable = tmpTab;
        }
    }
}
@end

void RtmErrorLogCppToOc::logString(char * log){
    
    @autoreleasepool {
        NSString * ocString = [NSString stringWithFormat:@"%s",log];
        if (ocString != nil && ocString.length > 0) {
            [RtmErrorLog exportErrorLog:ocString];
        }
    }
    
}


