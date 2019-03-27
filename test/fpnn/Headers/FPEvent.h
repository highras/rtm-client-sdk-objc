//
//  FPEvent.h
//  fpnn
//
//  Created by dixun on 2018/5/25.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPEvent_h
#define FPEvent_h

#import <Foundation/Foundation.h>

@class EventData;

typedef void(^EventBlock)(EventData * event);

@interface FPEvent : NSObject

@property(nonatomic, readwrite, strong) NSMutableDictionary * listeners;

- (void) addType:(NSString *)type andListener:(EventBlock)listener;

- (void) fireEvent:(EventData *)event;

- (void) removeAll;
- (void) removeType:(NSString *)type;
- (void) removeType:(NSString *)type andListener:(EventBlock)listener;
@end


#endif /* FPEvent_h */
