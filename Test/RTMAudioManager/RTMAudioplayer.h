//
//  RTMAudioplayer.h
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMAudioplayer : NSObject

+(instancetype)shareInstance;
-(void)playWithData:(NSData*)audioData;//通过RTM SDK getMessage接口获取的binary音频消息
-(void)playWithWavPath:(NSString*)wavAudioPath;
-(void)playWithAmrPath:(NSString*)amrAudioPath;
-(void)stop;

@end

NS_ASSUME_NONNULL_END
