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
-(void)playWithData:(NSData*)audioData{

    
    if ([self _playing]) {
           
        [self stop];
        
    }
            
    NSString * wavPath = [RtmVoiceConverterManager voiceConvertAmrToWavFromFilePath:audioData];
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
-(void)playWithWavPath:(NSString*)wavAudioPath{
    
    if ([self _playing]) {
        [self stop];
    }
       
    NSData * wavData = [NSData dataWithContentsOfFile:wavAudioPath];
    if (wavData) {
        if (wavData) {
            [self _initAudioPlayer:wavData];
            if (self.audioPlayer != nil) {
                [self.audioPlayer play];
            }
                    
        }
    }
        
}
-(void)playWithAmrPath:(NSString*)amrAudioPath{
    
    if ([self _playing]) {
        [self stop];
    }
       
    NSData * amrData = [NSData dataWithContentsOfFile:amrAudioPath];
    NSString * wavPath = [RtmVoiceConverterManager voiceConvertAmrToWavFromFilePath:amrData];
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
-(void)_initAudioPlayer:(NSData*)audioData{
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    self.audioPlayer.delegate = self;
}

@end
