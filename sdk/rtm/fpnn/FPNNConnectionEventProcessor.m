//
//  FPNNConnectionEventProcessor.m
//  fpnn
//
//  Created by 施王兴 on 2017/12/29.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNConnectionEventProcessor.h"

typedef void(^ConnectionConnectedCallbackBlock)(void);
typedef void(^ConnectionWillCloseCallbackBlock)(BOOL closeByError);


@implementation FPNNConnectionEventProcessor
{
    ConnectionConnectedCallbackBlock _connectedBlock;
    ConnectionWillCloseCallbackBlock _closeBlock;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectedBlock = nil;
        _closeBlock = nil;
    }
    return self;
}

- (void)connected
{
    if (_connectedBlock)
        _connectedBlock();
}
- (void)connectionWillClose:(BOOL)closeByError
{
    if (_closeBlock)
        _closeBlock(closeByError);
}

- (void)setConnectedCallback:(void(^)(void))block
{
    _connectedBlock = block;
}
- (void)setConnectionWillCloseCallback:(void(^)(BOOL causedByError))block
{
    _closeBlock = block;
}

@end
