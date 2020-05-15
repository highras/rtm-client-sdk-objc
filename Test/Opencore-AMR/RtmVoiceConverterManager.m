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

@end

