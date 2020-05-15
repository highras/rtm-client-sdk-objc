//
//  NSData+RTMTools.m
//  Rtm
//
//  Created by zsl on 2019/12/19.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "NSData+RTMTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (RTMTools)
-(NSString*)md5{
    CC_MD5_CTX md5;
    //2: 初始化MD5
    CC_MD5_Init(&md5);
    //3: 准备MD5加密
    CC_MD5_Update(&md5, self.bytes, (CC_LONG)self.length);
    //4: 准备一个字符串数组, 存储MD5加密之后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //5: 结束MD5加密
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    //6:从result数组中获取最终结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
}
-(void)setMd5:(NSString *)md5{
    
}
@end
