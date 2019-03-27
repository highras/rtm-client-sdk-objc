//
//  RTMProcessor.h
//  rtm
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef RTMProcessor_h
#define RTMProcessor_h

#import <Foundation/Foundation.h>
#import "FPProcessor.h"

@interface RTMProcessor : NSObject<ProcessorDelegate>

@property(nonatomic, readonly, weak) FPEvent * event;
@property(nonatomic, readwrite, strong) NSMutableDictionary * midMap;

- (instancetype) initWithEvent:(FPEvent *)event;
- (void) destroy;

@end

#endif /* RTMProcessor_h */
