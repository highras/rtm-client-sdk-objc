//
//  RTMNetworkReachabilityShare.h
//  Rtm
//
//  Created by zsl on 2020/12/2.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const RTMNetworkReachabilityShareDidChangeNotification = @"FPNetworkingReachabilityDidChangeNotification";
@interface RTMNetworkReachabilityShare : NSObject
+ (instancetype)sharedManager ;
@end

NS_ASSUME_NONNULL_END
