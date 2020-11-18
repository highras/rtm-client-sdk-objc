//
//  RtmVoiceConverterManager.m
//  Test
//
//  Created by zsl on 2020/2/12.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RtmVoiceConverterManager.h"
#import "VoiceConverter.h"
@implementation RtmVoiceConverterManager
//amr->wav
+(NSString*)voiceConvertAmrToWavWithData:(NSData *)voiceData{
    
    if (voiceData) {
        //tmp路径  可自行修改
        NSString * tmpDir = NSTemporaryDirectory();
        NSString * amrTmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
        NSString * wavTmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
        

        if ([voiceData writeToFile:amrTmpDir atomically:YES]) {
            
            if ([RtmVoiceConverterManager decodeAmrToWavFromPath:amrTmpDir wavSaveToPath:wavTmpDir]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:amrTmpDir error:nil];
//                NSLog(@"wav 路径 === %@",wavTmpDir);
                return wavTmpDir;
                
                
            }else{
                
                return nil;
            }
            
            
        }else{
            
            return nil;
            
        }
        
        
    }else{
        
        return nil;
        
    }
    
    
}
//wav->amr
+(NSString*)voiceConvertWavToAmrFromFilePath:(NSString *)filePath{
    
    NSString * tmpDir = NSTemporaryDirectory();
    tmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_rtm_voice.amr",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
    
    if ([RtmVoiceConverterManager encodeWavToAmrFromPath:filePath amrSaveToPath:tmpDir]) {
        
//        NSLog(@"amr 路径 === %@",tmpDir);
        return tmpDir;
        
    }else{
        
        return nil;
        
    }
    
}


+ (BOOL)encodeWavToAmrFromPath:(NSString*)fromPath amrSaveToPath:(NSString*)toPath{
    //16000用wb    8000用nb
    if ([VoiceConverter EncodeWavToAmr:fromPath amrSavePath:toPath sampleRateType:Sample_Rate_16000] == 1){
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]){
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
        
    }else{
        
        return NO;
        
    }
}

+ (BOOL)decodeAmrToWavFromPath:(NSString*)fromPath wavSaveToPath:(NSString*)toPath{
    
    if ([VoiceConverter  DecodeAmrToWav:fromPath wavSavePath:toPath sampleRateType:Sample_Rate_16000] == 1){
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]){
            
            return YES;
            
        }else{
            
            return NO;  
        }
        
        
    }else{
        
        return NO;
        
    }
    
}
+ (NSTimeInterval)audioDurationFromURL:(NSString *)url {
    AVURLAsset *audioAsset = nil;
    NSDictionary *dic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    if ([url hasPrefix:@"http://"]) {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:dic];
    }else {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:dic];
    }
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
//    NSLog(@"NSTimeInterval  %f",audioDurationSeconds);
    return audioDurationSeconds;
}


@end

