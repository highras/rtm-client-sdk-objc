//
//  RTMAudioModel.h
//  Rtm
//
//  Created by zsl on 2020/10/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMAudioModel : NSObject
@property(nonatomic,strong)NSString * _Nonnull audioFilePath;//文件路径   音频要求 16KHZ 16位 单声道 amr  必传
@property(nonatomic,assign)int duration;//duration 音频时长 毫秒 必传
@property(nonatomic,strong)NSString * _Nonnull lang;//lang 音频语言 必传
@end

NS_ASSUME_NONNULL_END
