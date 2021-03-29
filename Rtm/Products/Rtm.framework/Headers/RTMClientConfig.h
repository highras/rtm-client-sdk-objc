//
//  RTMClientConfig.h
//  Rtm
//
//  Created by zsl on 2020/7/21.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMClientConfig : NSObject

//此config为全局配置  单独接口的可独立设置
@property(nonatomic,assign)int sendQuestTimeout; //默认30
@property(nonatomic,assign)int fileQuestTimeout; //默认60
@property(nonatomic,assign)int translateTimeout; //默认120

@end

NS_ASSUME_NONNULL_END
