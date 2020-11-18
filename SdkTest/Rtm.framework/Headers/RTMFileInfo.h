//
//  RTMFileInfo.h
//  Rtm
//
//  Created by zsl on 2020/10/20.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMFileInfo : NSObject
@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)NSString * surl;//图片缩略图
@property(nonatomic,assign)long size;
@property(nonatomic,strong)NSString * lang;//rtm audio 语言        可根据此字段是否为空判断是rtm audio 还是 用户自己的file
@property(nonatomic,assign)int duration;//rtm audio 语音消息时长     可根据此字段是否为0判断是rtm audio 还是 用户自己的file
@property(nonatomic,assign)int srate;//rtm audio 采样率
@property(nonatomic,strong)NSString * codec;//rtm audio 编码格式
@property(nonatomic,assign)BOOL isRtmAudio;//是否为rtm音频消息
+(BOOL)isRtmAudio:(NSString*)attrsString;
+(RTMFileInfo*)fileModelConvert:(NSString*)msg attrs:(NSString*)attrs;

@end

NS_ASSUME_NONNULL_END
