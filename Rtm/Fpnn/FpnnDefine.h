//
//  FpnnDefine.h
//  Rtm
//
//  Created by zsl on 2020/12/8.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Client *(fpnn::TCPClientPtr*)((void* (*)(id, SEL))[self methodForSelector:NSSelectorFromString(@"getPrivateClient")])(self, NSSelectorFromString(@"getPrivateClient"))
#define Quest(quest) *(fpnn::FPQuestPtr*)((void* (*)(id, SEL))[quest methodForSelector:NSSelectorFromString(@"getQuest")])(quest, NSSelectorFromString(@"getQuest"))
#define Listen *(FPNNCppConnectionListenPtr*)((void* (*)(id, SEL))[self methodForSelector:NSSelectorFromString(@"getPrivatelistenCall")])(self, NSSelectorFromString(@"getPrivatelistenCall"))
#define ListenWithClient(client) *(FPNNCppConnectionListenPtr*)((void* (*)(id, SEL))[client methodForSelector:NSSelectorFromString(@"getPrivatelistenCall")])(client, NSSelectorFromString(@"getPrivatelistenCall"))


@interface FpnnDefine : NSObject

@end

NS_ASSUME_NONNULL_END
