//
//  FPNNConnectionEventProcessor.h
//  fpnn
//
//  Created by 施王兴 on 2017/12/29.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "FPNNQuestProcessor.h"

@interface FPNNConnectionEventProcessor : FPNNQuestProcessor

- (instancetype)init;
- (void)connected;
- (void)connectionWillClose:(BOOL)closeByError;

- (void)setConnectedCallback:(void(^)(void))block;
- (void)setConnectionWillCloseCallback:(void(^)(BOOL closeByError))block;

@end
