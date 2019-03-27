//
//  FPEncryptor.h
//  fpnn
//
//  Created by dixun on 2018/6/12.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPEncryptor_h
#define FPEncryptor_h

#import <Foundation/Foundation.h>

@class FPPackage, FPData;

@interface FPEncryptor : NSObject

@property(nonatomic, readonly, assign) BOOL streamMode;
@property(nonatomic, readonly, assign) BOOL cryptoed;

@property(nonatomic, readonly, strong) FPPackage * pkg;

- (instancetype)initWithPkg:(FPPackage *)pkg;

- (BOOL) isCrypto;
- (void) clear;

- (NSData *) deCode:(NSData *)bytes;
- (NSData *) enCode:(NSData *)bytes;
- (FPData *) peekHead:(NSData *)bytes;
- (FPData *) peekHeadWithData:(FPData *)peek;
@end

#endif /* FPEncryptor_h */
