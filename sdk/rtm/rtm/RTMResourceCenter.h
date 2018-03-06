//
//  RTMResourceCenter.h
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../fpnn/FPNNSDK.h"

@class RTMClient;

@interface RTMResourceCenter : NSObject

@property (nonatomic) int pingInterval;     //-- in seconds

+ (instancetype)instance;

+ (FPNNTCPClient*)getFileClientWithEndpoint:(NSString*)endpoint questTimeout:(int)questTimeout;

+ (void)registerRTMClient:(RTMClient*)client;
+ (void)unregisterRTMClient:(RTMClient*)client;

@end
