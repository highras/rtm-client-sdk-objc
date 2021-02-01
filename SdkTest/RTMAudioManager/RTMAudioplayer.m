//
//  RTMAudioplayer.m
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMAudioplayer.h"
#import <AVFoundation/AVFoundation.h>
#import "RtmVoiceConverterManager.h"
#import <Rtm/RTMAudioTools.h>
@interface RTMAudioplayer ()<AVAudioPlayerDelegate>
@property(nonatomic,strong) AVAudioPlayer * _Nullable audioPlayer;
@end

@implementation RTMAudioplayer
+ (instancetype)shareInstance{
    static RTMAudioplayer * _mySingle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mySingle = [[RTMAudioplayer alloc] init];
    });
    return _mySingle;
}
-(void)playWithAudioModel:(RTMAudioModel*)audioModel{

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if ([self _playing]) {
        [self stop];
    }
    
    if (audioModel.audioFilePath != nil && audioModel.audioFilePath.length > 0) {
        NSData * amrData = [NSData dataWithContentsOfFile:audioModel.audioFilePath];
        if (amrData) {
            NSString * wavPath = [RtmVoiceConverterManager voiceConvertAmrToWavWithData:amrData];
            if (wavPath) {
                NSData * wavData = [NSData dataWithContentsOfFile:wavPath];
                if (wavData) {
                    [self _initAudioPlayer:wavData];
                    if (self.audioPlayer != nil) {
                        [self.audioPlayer play];
                    }
                            
                }
            }
        }
    }
    
        
    
}
-(void)playWithAmrData:(NSData*)amrData{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if ([self _playing]) {
        [self stop];
    }
    if ([RTMAudioTools isAmrVerify:amrData]) {
        NSString * wavPath = [RtmVoiceConverterManager voiceConvertAmrToWavWithData:amrData];
        if (wavPath) {
            NSData * wavData = [NSData dataWithContentsOfFile:wavPath];
            if (wavData) {
                [self _initAudioPlayer:wavData];
                if (self.audioPlayer != nil) {
                    [self.audioPlayer play];
                }
                        
            }
        }
    }
}
//-(void)playWithWavPath:(NSString*)wavAudioPath{
//    
//    if ([self _playing]) {
//        [self stop];
//    }
//       
//    NSData * wavData = [NSData dataWithContentsOfFile:wavAudioPath];
//    if (wavData) {
//        if (wavData) {
//            [self _initAudioPlayer:wavData];
//            if (self.audioPlayer != nil) {
//                [self.audioPlayer play];
//            }
//                    
//        }
//    }
//        
//}
//-(void)playWithAmrPath:(NSString*)amrAudioPath{
//     
//    NSData * amrData = [NSData dataWithContentsOfFile:amrAudioPath];
//    [self playWithAmrData:amrData];
//    
//}
-(void)stop{
    if (self.audioPlayer != nil) {
        [self.audioPlayer stop];
    }
}
-(BOOL)_playing{
    if (self.audioPlayer != nil) {
        return self.audioPlayer.playing;
    }
    return NO;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == self.audioPlayer) {
        if (self.playFinish) {
            self.playFinish();
        }
    }
}
-(void)_initAudioPlayer:(NSData*)audioData{
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    self.audioPlayer.delegate = self;
}

@end
