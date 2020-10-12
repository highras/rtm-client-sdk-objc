//
//  RTMClient+File.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+File.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "NSData+RTMTools.h"
#import "NSString+RTMTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "RTMIPv6Adapter.h"
#define NSAllLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

@implementation RTMClient (File)
-(void)getP2PFileTokenWithId:(NSNumber*)userId
                     timeout:(int)timeout
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
//-(RTMAnswer*)getP2PFileTokenWithId:(NSNumber*)userId
//                        timeout:(int)timeout{
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userId forKey:@"to"];
//    [dic setValue:@"sendfile" forKey:@"cmd"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
//    BOOL result = [mainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//
//        if (successCallback) {
//            successCallback(data);
//        }
//
//    }fail:^(FPNError * _Nullable error) {
//
//          _failCallback(error);
//
//    }];
//
//    handlerNetworkError;
//
//}



-(void)getGroupFileTokenWithId:(NSNumber*)groupId
                       timeout:(int)timeout
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@"sendgroupfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
//-(RTMAnswer*)getGroupFileTokenWithId:(NSNumber*)groupId
//                        timeout:(int)timeout{
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:groupId forKey:@"gid"];
//    [dic setValue:@"sendgroupfile" forKey:@"cmd"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
//
//    return  handlerResult(quest,timeout);
//
//}


-(void)getRoomFileTokenWithId:(NSNumber*)roomId
                  timeout:(int)timeout
                  success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@"sendroomfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
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
//-(RTMAnswer*)getRoomFileTokenWithId:(NSNumber*)roomId
//                            timeout:(int)timeout{
//
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:roomId forKey:@"rid"];
//    [dic setValue:@"sendroomfile" forKey:@"cmd"];
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
//
//    return  handlerResult(quest,timeout);
//
//}


-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nonnull)fileData
                fileName:(NSString * _Nonnull)fileName
              fileSuffix:(NSString * _Nonnull)fileSuffix
                fileType:(RTMFileType)fileType
                 timeout:(int)timeout
                 success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
        
    [self getP2PFileTokenWithId:userId
                        timeout:RTMClientFileQuestTimeout
                        success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getGroupFileToken return data is nil");
            return ;
        }
        NSDictionary * resultBody = [self _getFileQuestBody:data recvId:userId fileData:fileData fileName:fileName fileSuffix:fileSuffix fileType:fileType];
        [resultBody setValue:userId forKey:@"to"];
//        NSLog(@"%@",resultBody);
        
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self _getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendfile" message:resultBody twoWay:YES];
        [fileClient sendQuest:quest
                      timeout:RTMClientSendQuestTimeout
                      success:^(NSDictionary * _Nullable data) {

            if (successCallback) {
                
                RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
                sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
                sendAnswer.messageId = [[resultBody objectForKey:@"mid"] longLongValue];
                successCallback(sendAnswer);
            }

        } fail:^(FPNError * _Nullable error) {
            _failCallback(error);

        }];
        
//        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:RTMClientSendQuestTimeout];
//        if (answer.responseData) {
//            NSLog(@"answer.responseData  %@",answer.responseData);
////            successCallback([[data objectForKey:@"mtime"] longLongValue]);
//        }else{
//            NSLog(@"answer.responseData  %@",answer.error);
//            failCallback(answer.error);
//        }
       
    } fail:^(FPNError * _Nullable error) {
        
        _failCallback(error);
        
    }];
        
}
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                  fileData:(NSData * _Nonnull)fileData
                  fileName:(NSString * _Nonnull)fileName
                fileSuffix:(NSString * _Nonnull)fileSuffix
                  fileType:(RTMFileType)fileType
                   timeout:(int)timeout
                   success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    [self getGroupFileTokenWithId:groupId
                          timeout:RTMClientFileQuestTimeout
                          success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getGroupFileToken return data is nil");
            return ;
        }
        
        NSDictionary * resultBody = [self _getFileQuestBody:data
                                                     recvId:groupId
                                                   fileData:fileData
                                                   fileName:fileName
                                                 fileSuffix:fileSuffix
                                                   fileType:fileType];
        
        [resultBody setValue:groupId forKey:@"gid"];
//        NSLog(@"%@",resultBody);
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        
        FPNNTCPClient * fileClient = [self _getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupfile" message:resultBody twoWay:YES];
        [fileClient sendQuest:quest
                      timeout:RTMClientSendQuestTimeout
                      success:^(NSDictionary * _Nullable data) {
            
            if (successCallback) {
                RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
                sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
                sendAnswer.messageId = [[resultBody objectForKey:@"mid"] longLongValue];
                successCallback(sendAnswer);
            }
            
        } fail:^(FPNError * _Nullable error) {
            
            _failCallback(error);
            
        }];
//        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:timeout];
//        if (answer.responseData) {
//            successCallback(answer.responseData,tag);
//        }else{
//            failCallback(answer.error,tag);
//        }
       
    } fail:^(FPNError * _Nullable error) {
        _failCallback(error);
    }];
    
}
//
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nonnull)fileData
                 fileName:(NSString * _Nonnull)fileName
               fileSuffix:(NSString * _Nonnull)fileSuffix
                 fileType:(RTMFileType)fileType
                  timeout:(int)timeout
                  success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    
    [self getRoomFileTokenWithId:roomId
                         timeout:RTMClientFileQuestTimeout
                         success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getGroupFileToken return data is nil");
            return ;
        }
        
        NSDictionary * resultBody = [self _getFileQuestBody:data
                                                     recvId:roomId
                                                   fileData:fileData
                                                   fileName:fileName
                                                 fileSuffix:fileSuffix
                                                   fileType:fileType];
        [resultBody setValue:roomId forKey:@"rid"];
//        NSLog(@"%@",resultBody);
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        
        FPNNTCPClient * fileClient = [self _getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroomfile" message:resultBody twoWay:YES];
        [fileClient sendQuest:quest
                      timeout:RTMClientSendQuestTimeout
                      success:^(NSDictionary * _Nullable data) {
            
            if (successCallback) {
                RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
                sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
                sendAnswer.messageId = [[resultBody objectForKey:@"mid"] longLongValue];
                successCallback(sendAnswer);
            }
            
        } fail:^(FPNError * _Nullable error) {
            
            _failCallback(error);
            
        }];
//        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:timeout];
//        if (answer.responseData) {
//            successCallback(answer.responseData);
//        }else{
//            failCallback(answer.error);
//        }
       
    } fail:^(FPNError * _Nullable error) {
        _failCallback(error);
    }];
    
}

-(NSDictionary*)_getFileQuestBody:(NSDictionary *)data
                           recvId:(NSNumber *)recvId
                         fileData:(NSData * _Nonnull)fileData
                         fileName:(NSString * _Nonnull)fileName
                       fileSuffix:(NSString * _Nonnull)fileSuffix
                         fileType:(RTMFileType)fileType{
    
    NSString * token = data[@"token"];
//    NSString * endpoint = data[@"endpoint"];
    
    NSMutableDictionary * questDic = [NSMutableDictionary dictionary];
    [questDic setValue:@(self.projectId) forKey:@"pid"];
    [questDic setValue:token forKey:@"token"];
    [questDic setValue:@(self.userId) forKey:@"from"];
    [questDic setValue:mid forKey:@"mid"];
    [questDic setValue:fileData forKey:@"file"];
    [self _fileType:fileType questDic:questDic];
    
    NSString * codeStr = [NSString stringWithFormat:@"%@:%@",[self getMD5Data:fileData].lowercaseString,token];
    NSString * sign = [self md5HashToLower32Bit:codeStr].lowercaseString;
    //tolower(md5(tolower(toString(md5(filecontent))) + ":" + token))
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    [attrs setValue:sign forKey:@"sign"];
    [attrs setValue:fileSuffix forKey:@"ext"];
    [attrs setValue:fileName forKey:@"fileName"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:attrs options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [questDic setValue:jsonStr forKey:@"attrs"];
    
    return questDic;
}
-(FPNNTCPClient*)_getFileClient:(NSString*)endPoint{
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
-(void)_fileType:(RTMFileType)fileType questDic:(NSMutableDictionary*)questDic{
    
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


@end
