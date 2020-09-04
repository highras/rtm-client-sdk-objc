//
//  RTMHistory.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMHistoryMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMHistory : NSObject
@property(nonatomic,strong)NSArray <RTMHistoryMessage*> *  messageArray;
@property(nonatomic,assign)int64_t begin;
@property(nonatomic,assign)int64_t end;
@property(nonatomic,assign)int64_t lastid;
@end

NS_ASSUME_NONNULL_END

