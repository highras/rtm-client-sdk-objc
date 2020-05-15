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
+(BOOL)encodeWavToAmrFromPath:(NSString*)fromPath amrSaveToPath:(NSString*)toPath;
+(BOOL)decodeAmrToWavFromPath:(NSString*)fromPath wavSaveToPath:(NSString*)toPath;
@end

NS_ASSUME_NONNULL_END
