//
//  NSString+RTMTools.m
//  Rtm
//
//  Created by zsl on 2019/12/16.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "NSString+RTMTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RTMTools)
-(NSString*)md5_32_lower{
    const char *input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}
-(void)setMd5_32_lower:(NSString *)md5_32_lower{
    
}
@end
