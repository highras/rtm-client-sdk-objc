//
//  RTMClient+FileToken.m
//  Rtm
//
//  Created by zsl on 2020/10/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMClient+FileToken.h"
#import "FPNNQuest.h"
#import "NSData+RTMTools.h"
#import "NSString+RTMTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "RTMIPv6Adapter.h"
#import "RTMClient+FileToken.h"

@implementation RTMClient (FileToken)
-(void)getP2PFileTokenWithId:(NSNumber*)userId
                     timeout:(int)timeout
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback(data);
        }
    
    }fail:^(FPNError * _Nullable error) {
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(FPNNAnswer*)getP2PFileTokenWithId:(NSNumber*)userId
                              timeout:(int)timeout{
    
    
    FPNNAnswer * model = [FPNNAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest timeout:RTMClientSendQuestTimeout];
    return answer;
    
}




-(void)getGroupFileTokenWithId:(NSNumber*)groupId
                       timeout:(int)timeout
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@"sendgroupfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback(data);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(FPNNAnswer*)getGroupFileTokenWithId:(NSNumber*)groupId
                              timeout:(int)timeout{
    
    FPNNAnswer * model = [FPNNAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest timeout:RTMClientSendQuestTimeout];
    return answer;
    
}

-(void)getRoomFileTokenWithId:(NSNumber*)roomId
                  timeout:(int)timeout
                  success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@"sendroomfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback(data);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(FPNNAnswer*)getRoomFileTokenWithId:(NSNumber*)roomId
                             timeout:(int)timeout{
    
    FPNNAnswer * model = [FPNNAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest timeout:RTMClientSendQuestTimeout];
    return answer;
    
}



-(FPNNTCPClient*)getFileClient:(NSString*)endPoint{
    @synchronized (self) {
        NSCache * fileClientCache = (NSCache *)[self valueForKey:@"fileClientCache"];
        if (fileClientCache) {
            FPNNTCPClient * cacheClient = [fileClientCache objectForKey:endPoint];
            if (cacheClient) {
                return cacheClient;
            }else{
                FPNNTCPClient * newClient = [FPNNTCPClient clientWithEndpoint:endPoint];
                [fileClientCache setObject:newClient forKey:endPoint];
                return newClient;
            }
        }else{
            FPNNTCPClient * newClient = [FPNNTCPClient clientWithEndpoint:endPoint];
            [fileClientCache setObject:newClient forKey:endPoint];
            return newClient;
        }
    }
}
-(void)fileType:(RTMFileType)fileType questDic:(NSMutableDictionary*)questDic{
    
    switch (fileType) {
        case RTMImage:
        {
            [questDic setValue:@(40) forKey:@"mtype"];
        }
            break;
            
        case RTMVoice:
        {
            [questDic setValue:@(41) forKey:@"mtype"];
        }
            break;
            
        case RTMVideo:
        {
            [questDic setValue:@(42) forKey:@"mtype"];
        }
            break;
            
        default:
        {
            [questDic setValue:@(50) forKey:@"mtype"];
        }
            break;
    }
}



-(NSString *)getMD5Data:(NSData*)data{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
}
-(NSString *)md5HashToLower32Bit:(NSString*)str {
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}
-(NSDictionary*)getFileQuestBody:(NSDictionary *)data
                           recvId:(NSNumber *)recvId
                         fileData:(NSData * _Nonnull)fileData
                         fileName:(NSString * _Nonnull)fileName
                       fileSuffix:(NSString * _Nonnull)fileSuffix
                         fileType:(RTMFileType)fileType
                            attrs:(NSDictionary*)attrs{
    
    NSString * token = data[@"token"];
    
    NSMutableDictionary * questDic = [NSMutableDictionary dictionary];
    [questDic setValue:@(self.projectId) forKey:@"pid"];
    [questDic setValue:token forKey:@"token"];
    [questDic setValue:@(self.userId) forKey:@"from"];
    [questDic setValue:mid forKey:@"mid"];
    [questDic setValue:fileData forKey:@"file"];
    [self fileType:fileType questDic:questDic];
    
    NSString * codeStr = [NSString stringWithFormat:@"%@:%@",[self getMD5Data:fileData].lowercaseString,token];
    NSString * sign = [self md5HashToLower32Bit:codeStr].lowercaseString;
    //tolower(md5(tolower(toString(md5(filecontent))) + ":" + token))
    NSMutableDictionary * attrString = [NSMutableDictionary dictionary];
    [attrString setValue:@{@"sign":sign,@"ext":fileSuffix,@"filename":fileName} forKey:@"rtm"];
    [attrString setValue:attrs forKey:@"custom"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:attrString options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [questDic setValue:jsonStr forKey:@"attrs"];
//    NSLog(@"%@",questDic);
    return questDic;
}

-(NSDictionary*)getAudioFileQuestBody:(NSDictionary *)data
                               recvId:(NSNumber *)recvId
                             fileData:(NSData * _Nonnull)fileData
                                 lang:(NSString * _Nonnull)lang
                             duration:(long long)duration
                                attrs:(NSDictionary*)attrs{
    
    NSString * token = data[@"token"];
//    NSString * endpoint = data[@"endpoint"];
    
    NSMutableDictionary * questDic = [NSMutableDictionary dictionary];
    [questDic setValue:@(self.projectId) forKey:@"pid"];
    [questDic setValue:token forKey:@"token"];
    [questDic setValue:@(self.userId) forKey:@"from"];
    [questDic setValue:mid forKey:@"mid"];
    [questDic setValue:fileData forKey:@"file"];
    [self fileType:RTMVoice questDic:questDic];
    
    NSString * codeStr = [NSString stringWithFormat:@"%@:%@",[self getMD5Data:fileData].lowercaseString,token];
    NSString * sign = [self md5HashToLower32Bit:codeStr].lowercaseString;
    //tolower(md5(tolower(toString(md5(filecontent))) + ":" + token))
    NSMutableDictionary * attrString = [NSMutableDictionary dictionary];
    [attrString setValue:@{
        @"type":@"audiomsg",
        @"sign":sign,
        @"ext":@"amr",
        @"filename":@"",
        @"lang":lang,
        @"duration":@(duration),
        @"codec":@"AMR-WB",
        @"srate":@(16000)
    }
                  forKey:@"rtm"];
    [attrString setValue:attrs forKey:@"custom"];
//    NSLog(@"%@",attrString);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:attrString options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [questDic setValue:jsonStr forKey:@"attrs"];
    
//    NSLog(@"%@",questDic);
    return questDic;
}
@end
