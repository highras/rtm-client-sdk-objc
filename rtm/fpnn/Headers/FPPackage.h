//
//  FPPackage.h
//  fpnn
//
//  Created by dixun on 2018/5/30.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPPackage_h
#define FPPackage_h

#import <Foundation/Foundation.h>

@class FPData, FPConfig;

@interface FPPackage : NSObject

- (NSString *) getKey:(FPData *)data;

- (BOOL) isHttp:(FPData *) data;
- (BOOL) isTcp:(FPData *) data;
- (BOOL) isMsgPack:(FPData *) data;
- (BOOL) isJson:(FPData *) data;
- (BOOL) isOneWay:(FPData *) data;
- (BOOL) isTwoWay:(FPData *) data;
- (BOOL) isQuest:(FPData *) data;
- (BOOL) isAnswer:(FPData *) data;
- (BOOL) isSupportPack:(FPData *) data;
- (BOOL) checkVersion:(FPData *) data;

- (NSData *) enCode:(FPData *)data;
- (FPData *) peekHead:(NSData *)bytes;
- (BOOL) deCode:(FPData *)data;
@end

#endif /* FPPackage_h */
