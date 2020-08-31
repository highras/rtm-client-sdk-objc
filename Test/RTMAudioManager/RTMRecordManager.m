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
@interface RTMRecordManager ()

@property (strong, nonatomic)   AVAudioRecorder  *recorder;
@property (strong, nonatomic)   AVAudioPlayer    *player;
@property (strong, nonatomic)   NSString         *recordFileName;
@property (strong, nonatomic)   NSString         *recordFilePath;


@end
@implementation RTMRecordManager
-(void)stopRecord:(void(^)(NSString * _Nullable amrAudioPath,NSString * _Nullable wavAudioPath,double durationTime))recorderFinish{
    if (self.recorder.recording) {
        [self.recorder stop];
        NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:self.recordFilePath];
        double time = [RtmVoiceConverterManager audioDurationFromURL:self.recordFilePath];
        if (recorderFinish && amrPath != nil && time > 1) {
            recorderFinish(amrPath,self.recordFilePath,time);
        }
        self.recorder = nil;
    }
}
-(void)startRecord{
    
    if (self.recorder.recording) {
        return;
    }
    
    self.recordFileName = [self getCurrentTimeString];
    self.recordFilePath = [self GetPathByFileName:self.recordFileName ofType:@"wav"];
    //NSLog(@"录音文件的路径是：%@",self.recordFilePath);
    //wav格式文件保存到这
    
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

- (NSString *)getCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [dateformat stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"16KHZWAV%@",dateStr];
}
- (NSString*)GetPathByFileName:(NSString *)fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    directory = [directory stringByAppendingPathComponent:@"16KHZFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}



@end
