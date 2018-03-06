//
//  RTMQuestProcessor.h
//  rtm
//
//  Created by 施王兴 on 2018/1/8.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "FPNNQuestProcessor.h"
#import "RTMEventHandlerDelegate.h"

@class RTMClient;

@interface RTMQuestProcessor : FPNNQuestProcessor

@property (nonatomic) int64_t connectionId;
@property (strong, nonatomic) id<RTMEventHandlerDelegate> eventHandler;

- (void)prepareForNewConnection:(RTMClient*)client;
- (void)resetRTMClientReference;

- (void)connectionWillClose:(BOOL)closeByError;

- (FPNNAnswer*)bye:(NSDictionary*)params;
- (FPNNAnswer*)kickout:(NSDictionary*)params;

- (FPNNAnswer*)pushmsg:(NSDictionary*)params;
- (FPNNAnswer*)pushgroupmsg:(NSDictionary*)params;
- (FPNNAnswer*)pushroommsg:(NSDictionary*)params;
- (FPNNAnswer*)pushbroadcastmsg:(NSDictionary*)params;

- (FPNNAnswer*)transmsg:(NSDictionary*)params;
- (FPNNAnswer*)transgroupmsg:(NSDictionary*)params;
- (FPNNAnswer*)transroommsg:(NSDictionary*)params;
- (FPNNAnswer*)transbroadcastmsg:(NSDictionary*)params;

- (FPNNAnswer*)pushunread:(NSDictionary*)params;
 
@end
