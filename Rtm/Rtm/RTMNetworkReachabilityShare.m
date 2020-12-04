//
//  RTMNetworkReachabilityShare.m
//  Rtm
//
//  Created by zsl on 2020/12/2.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMNetworkReachabilityShare.h"
#import "FPNetworkReachabilityManager.h"
@implementation RTMNetworkReachabilityShare
+ (instancetype)sharedManager {
    static RTMNetworkReachabilityShare *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
        
        FPNetworkReachabilityManager *manager = [FPNetworkReachabilityManager sharedManager];
//            @rtmWeakify(self);
            [manager setReachabilityStatusChangeBlock:^(FPNetworkReachabilityStatus status) {
//                @rtmStrongify(self);
                switch(status) {
                        
                 case FPNetworkReachabilityStatusUnknown:
                        [[NSNotificationCenter defaultCenter] postNotificationName:RTMNetworkReachabilityShareDidChangeNotification object:@(0)];
                        
                        break;
                 case FPNetworkReachabilityStatusNotReachable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:RTMNetworkReachabilityShareDidChangeNotification object:@(1)];
                        
                        break;
                 case FPNetworkReachabilityStatusReachableViaWWAN:
                        [[NSNotificationCenter defaultCenter] postNotificationName:RTMNetworkReachabilityShareDidChangeNotification object:@(2)];
                        
                        break;
                 case FPNetworkReachabilityStatusReachableViaWiFi:
                        [[NSNotificationCenter defaultCenter] postNotificationName:RTMNetworkReachabilityShareDidChangeNotification object:@(3)];
                        
                        break;
                }
                
            }];
            
            [manager startMonitoring];
        
    });

    return _sharedManager;
}

@end
