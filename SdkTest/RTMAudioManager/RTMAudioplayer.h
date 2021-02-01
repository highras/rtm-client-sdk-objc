//
//  RTMAudioplayer.h
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Rtm/Rtm.h>
NS_ASSUME_NONNULL_BEGIN

@interface RTMAudioplayer : NSObject

+(instancetype)shareInstance;
@property(nonatomic,copy) void(^playFinish)(void);
-(void)playWithAudioModel:(RTMAudioModel*)audioModel;//audioFilePath is not nil
-(void)playWithAmrData:(NSData*)amrData;//通过音频url获取的二进制数据
-(void)stop;

@end

NS_ASSUME_NONNULL_END
