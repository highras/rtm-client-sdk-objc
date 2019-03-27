//
//  FPClient.h
//  fpnn
//
//  Created by dixun on 2018/5/22.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPClient_h
#define FPClient_h

#import <Foundation/Foundation.h>
#import "FPEvent.h"
#import "FPCallback.h"

@class FPPackage, FPSocket, FPProcessor, FPEncryptor;

@interface FPClient : NSObject

@property(nonatomic, readonly, assign) NSInteger seq;
@property(nonatomic, readonly, assign) NSInteger timeout;
@property(nonatomic, readonly, assign) BOOL reconnect;

@property(nonatomic, readwrite, assign) NSInteger wpos;
@property(nonatomic, readwrite, strong) FPData * peekData;
@property(nonatomic, readwrite, strong) NSMutableData * buffer;

@property(nonatomic, readonly, strong) FPSocket * sock;
@property(nonatomic, readonly, strong) FPPackage * pkg;
@property(nonatomic, readonly, strong) FPEncryptor * cyr;
@property(nonatomic, readonly, strong) FPEvent * event;
@property(nonatomic, readonly, strong) FPCallback * callback;
@property(nonatomic, readonly, strong) FPProcessor * psr;

@property(nonatomic, readonly, strong) EventBlock secondBlock;

- (void) initWithEndpoint:(NSString *)endpoint andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout;
- (void) initWithHost:(NSString *)host andPort:(NSInteger)port andReconnect:(BOOL)reconnect andTimeout:(NSInteger)timeout;

- (BOOL) isOpen;
- (BOOL) hasConnect;
- (void) connect;
- (void) close;
- (void) destroy;
- (void) closeWithError:(NSError *)error;

- (void) sendQuest:(FPData *)data andBlock:(CallbackBlock)block;
- (void) sendQuest:(FPData *)data andBlock:(CallbackBlock)block andTimeout:(NSInteger)timeout;
@end


#endif /* FPClient_h */
