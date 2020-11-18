//
//  RtmVoiceConverterManager.h
//  Test
//
//  Created by zsl on 2020/2/12.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtmVoiceConverterManager : NSObject

//wav->amr
+(NSString*)voiceConvertWavToAmrFromFilePath:(NSString *)filePath;
//amr->wav
+(NSString*)voiceConvertAmrToWavWithData:(NSData *)voiceData;

+ (NSTimeInterval)audioDurationFromURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
