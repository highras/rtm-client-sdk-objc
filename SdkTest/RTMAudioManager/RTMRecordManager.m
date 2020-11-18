//
//  RTMRecordManager.m
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import "RtmVoiceConverterManager.h"
#import <Rtm/RTMAudioTools.h>
@interface RTMRecordManager ()

@property (strong, nonatomic)   AVAudioRecorder  *recorder;
@property (strong, nonatomic)   AVAudioPlayer    *player;
@property (strong, nonatomic)   NSString         *recordFileName;
@property (strong, nonatomic)   NSString         *recordFilePath;
@property (strong, nonatomic)   NSString         *lang;

@end
@implementation RTMRecordManager
-(void)stopRecord:(void(^)(RTMAudioModel * audioModel))recorderFinish{
    if (self.recorder.recording) {
        [self.recorder stop];
        double time = [RtmVoiceConverterManager audioDurationFromURL:self.recordFilePath];
        NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:self.recordFilePath];//wav->amr
        if (recorderFinish && amrPath != nil && time > 1) {
            RTMAudioModel * audioModel = [RTMAudioModel new];
            audioModel.audioFilePath = amrPath;
            audioModel.duration = time * 1000;
            audioModel.lang = self.lang;
            recorderFinish(audioModel);
//            [[NSFileManager defaultManager] removeItemAtPath:self.recordFilePath error:nil];
        }
        self.recorder = nil;
    }
}
-(void)startRecordWithLang:(NSString*)lang{
    
    if (self.recorder.recording) {
        return;
    }
    
    if (lang.length == 0) {
        return;
    }
    
    self.lang = lang;
    self.recordFileName = [self getCurrentTimeString];
    self.recordFilePath = [self getPathByFileName:self.recordFileName ofType:@"wav"];
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
    [NSNumber numberWithFloat: 16000.0],AVSampleRateKey, //采样率
    [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数
    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
    nil];
    
    //初始化录音 16KHZ
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:self.recordFilePath]
                                               settings:recordSetting
                                                  error:nil];
    
    //准备录音
    if ([self.recorder prepareToRecord]){
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //开始录音
        if ([self.recorder record]){
            
            NSLog(@"开始录音");
            
        }
    }
}

//路径 以及 删除策略可根据业务自行修改
- (NSString *)getCurrentTimeString{
    return [NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]];
}
- (NSString*)getPathByFileName:(NSString *)fileName ofType:(NSString *)_type{
    NSString * directory = NSTemporaryDirectory();
//    directory = [directory stringByAppendingPathComponent:@"16KHZFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}



@end
