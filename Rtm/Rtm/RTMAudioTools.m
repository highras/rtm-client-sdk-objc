//
//  RTMAudioTools.m
//  Rtm
//
//  Created by zsl on 2020/3/11.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMAudioTools.h"
#import "MPMessagePackReader.h"
#import "MPMessagePackWriter.h"

@implementation RTMAudioTools
+ (NSData*)audioDataAddHeader:(NSData*)audioData lang:(NSString*)lang time:(long long)time srate:(int)srate{
    
    Byte version[] = {1};
    Byte containerType[] = {0};
    Byte codecType[] = {1};
    
    NSMutableDictionary * amrParameterDic = [NSMutableDictionary dictionary];
//    [amrParameterDic setValue:@"zh-cn" forKey:@"lang"];
    [amrParameterDic setValue:lang forKey:@"lang"];
    [amrParameterDic setValue:@(time) forKey:@"dur"];
    [amrParameterDic setValue:@(srate) forKey:@"srate"];
    
    NSError *error = nil;
    NSData * amrParameterData = [MPMessagePackWriter writeObject:amrParameterDic error:&error];
    
//    [RTMAudioTools printByte:amrParameterData];
    
    if (error || amrParameterData == nil) {
        return nil;
    }
    Byte infoDataCount[] = {1};
    NSInteger dataLength = amrParameterData.length;
    if (dataLength > 255 * 4) {
        return nil;
    }
    Byte amrParameterLength[4];
    for (int i = 0 ; i<4; i++) {
        if (dataLength > 255) {
            amrParameterLength[i] = 255;
            dataLength = dataLength - 255;
        }else{
            amrParameterLength[i] = dataLength;
            dataLength = 0;
        }
    }
    
   
    NSMutableData * resultData = [NSMutableData data];
    [resultData appendBytes:version length:sizeof(version)];
    [resultData appendBytes:containerType length:sizeof(containerType)];
    [resultData appendBytes:codecType length:sizeof(codecType)];
    [resultData appendBytes:infoDataCount length:sizeof(infoDataCount)];
    [resultData appendBytes:amrParameterLength length:sizeof(amrParameterLength)];
    [resultData appendData:amrParameterData];
    [resultData appendData:audioData];

//        [RTMAudioTools printByte:resultData];

    return resultData;
}

+ (NSData*)audioDataRemoveHeader:(NSData*)audioData{
//     [RTMAudioTools printByte:audioData];
    //{1,2,3,0,1,1,1,1,2,2,2,2,3,3,3,3};
    if (audioData == nil || audioData.length == 0) {
        return nil;
    }
    Byte byteDataArray[audioData.length];
    for (int i = 0 ; i < audioData.length; i++) {
        NSData *idata = [audioData subdataWithRange:NSMakeRange(i, 1)];
        byteDataArray[i] =((Byte*)[idata bytes])[0];
    }
    
    if (audioData.length >= 4) {
        
        int version = byteDataArray[0];
        int containerType = byteDataArray[1];
        int codecType = byteDataArray[2];
        int infoDataCount = byteDataArray[3];
        
        FPNSLog(@" %d %d %d %d",version,containerType,codecType,infoDataCount);
        
        
        if (infoDataCount == 0) {
            
            NSData * amrData = [audioData subdataWithRange:NSMakeRange(4, audioData.length-4)];
//            [RTMAudioTools printByte:amrData];
            return amrData;
            
        }else if(infoDataCount == 1){
            
            if (audioData.length >= 8) {
                int infoDataLength = 0;
                for (int i = 0; i<4; i++) {
                    infoDataLength = infoDataLength + byteDataArray[i+4];
                }
                
                int amrDataStart = 8 + infoDataLength;
                
                if (audioData.length > amrDataStart && audioData.length - amrDataStart >=0) {
                    NSData * amrData = [audioData subdataWithRange:NSMakeRange(amrDataStart, audioData.length - amrDataStart)];
                    
//                    [RTMAudioTools printByte:amrData];
                    
                    
                    return amrData;
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
    
    return nil;
}

+(void)printByte:(NSData*)dd{
    Byte codeKeyByteAry2[dd.length];
    for (int i = 0 ; i < dd.length; i++) {
        NSData *idata = [dd subdataWithRange:NSMakeRange(i, 1)];
        codeKeyByteAry2[i] =((Byte*)[idata bytes])[0];
    }
              
            
    for (int i=0; i<sizeof(codeKeyByteAry2); i++) {
        FPNSLog(@"~~i==%d   value==%d",i,codeKeyByteAry2[i]);
    
    }

                               
}


@end

