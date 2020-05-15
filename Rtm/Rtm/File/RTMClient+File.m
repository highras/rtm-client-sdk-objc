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


@implementation RTMClient (File)
-(BOOL)getP2PFileTokenWithId:(NSNumber*)userId
                     timeout:(int)timeout
                         tag:(id)tag
                     success:(RTMAnswerSuccessCallBack)successCallback
                        fail:(RTMAnswerFailCallBack)failCallback{
    
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getP2PFileTokenWithId:(NSNumber*)userId
                        timeout:(int)timeout{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:@"sendfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(BOOL)getGroupFileTokenWithId:(NSNumber*)groupId
                  timeout:(int)timeout
                           tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@"sendgroupfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    
    return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getGroupFileTokenWithId:(NSNumber*)groupId
                        timeout:(int)timeout{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:groupId forKey:@"gid"];
    [dic setValue:@"sendgroupfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(BOOL)getRoomFileTokenWithId:(NSNumber*)roomId
                  timeout:(int)timeout
                          tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                         fail:(RTMAnswerFailCallBack)failCallback{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@"sendroomfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    
    return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getRoomFileTokenWithId:(NSNumber*)roomId
                            timeout:(int)timeout{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@"sendroomfile" forKey:@"cmd"];
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"filetoken" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nonnull)fileData
                fileName:(NSString * _Nonnull)fileName
              fileSuffix:(NSString * _Nonnull)fileSuffix
                fileType:(RTMFileType)fileType
                 timeout:(int)timeout
                     tag:(id)tag
                 success:(RTMAnswerSuccessCallBack)successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    if (fileData == nil) {
//        FPNError * error = [FPNError errorWithEx:@"rtm sendP2PFile error. fileData is nil" code:0];
//        failCallback(error,tag);
        FPNSLog(@"rtm sendP2PFile error. fileData is nil");
        return;
    }
    
    [self getP2PFileTokenWithId:userId
                        timeout:timeout
                            tag:tag
                        success:^(NSDictionary * _Nullable data,id _Nullable tag) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNError * error = [FPNError errorWithEx:@"rtm sendP2PFile error. getP2PFileToken return data is nil" code:0];
            failCallback(error,tag);
            return ;
        }
        
        NSDictionary * resultBody = [self _getFileQuestBody:data recvId:userId fileData:fileData fileName:fileName fileSuffix:fileSuffix fileType:fileType];
        [resultBody setValue:userId forKey:@"to"];
//        NSLog(@"%@",resultBody);
        FPNNTCPClient * fileClient = [self _getFileClient:data[@"endpoint"]];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendfile" message:resultBody twoWay:YES];
        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:timeout];
        if (answer.responseData) {
            successCallback(answer.responseData,tag);
        }else{
            failCallback(answer.error,tag);
        }
       
    } fail:^(FPNError * _Nullable error,id _Nullable tag) {
        failCallback(error,tag);
    }];
        
}
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                   fileData:(NSData * _Nonnull)fileData
                   fileName:(NSString * _Nonnull)fileName
                 fileSuffix:(NSString * _Nonnull)fileSuffix
                   fileType:(RTMFileType)fileType
                    timeout:(int)timeout
                       tag:(id)tag
                    success:(RTMAnswerSuccessCallBack)successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    if (fileData == nil) {
//        FPNError * error = [FPNError errorWithEx:@"rtm sendGroupFile error. fileData is nil" code:0];
//        failCallback(error,tag);
        FPNSLog(@"rtm sendGroupFile error. fileData is nil");
        return;
    }
    
    [self getGroupFileTokenWithId:groupId
                          timeout:timeout
                              tag:tag
                          success:^(NSDictionary * _Nullable data,id _Nullable tag) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNError * error = [FPNError errorWithEx:@"rtm sendGroupFile error. getP2PFileToken return data is nil" code:0];
            failCallback(error,tag);
            return ;
        }
        
        NSDictionary * resultBody = [self _getFileQuestBody:data recvId:groupId fileData:fileData fileName:fileName fileSuffix:fileSuffix fileType:fileType];
        [resultBody setValue:groupId forKey:@"gid"];
//        NSLog(@"%@",resultBody);
        FPNNTCPClient * fileClient = [self _getFileClient:data[@"endpoint"]];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendgroupfile" message:resultBody twoWay:YES];
        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:timeout];
        if (answer.responseData) {
            successCallback(answer.responseData,tag);
        }else{
            failCallback(answer.error,tag);
        }
       
    } fail:^(FPNError * _Nullable error,id _Nullable tag) {
        failCallback(error,tag);
    }];
    
}

-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nonnull)fileData
                 fileName:(NSString * _Nonnull)fileName
               fileSuffix:(NSString * _Nonnull)fileSuffix
                 fileType:(RTMFileType)fileType
                  timeout:(int)timeout
                      tag:(id)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    if (fileData == nil) {
//        FPNError * error = [FPNError errorWithEx:@"rtm sendRoomFile error. fileData is nil" code:0];
//        failCallback(error,tag);
        FPNSLog(@"rtm sendRoomFile error. fileData is nil");
        return;
    }
    
    [self getRoomFileTokenWithId:roomId
                         timeout:timeout
                             tag:tag
                         success:^(NSDictionary * _Nullable data,id _Nullable tag) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNError * error = [FPNError errorWithEx:@"rtm sendRoomFile error. getP2PFileToken return data is nil" code:0];
            failCallback(error,tag);
            return ;
        }
        
        NSDictionary * resultBody = [self _getFileQuestBody:data recvId:roomId fileData:fileData fileName:fileName fileSuffix:fileSuffix fileType:fileType];
        [resultBody setValue:roomId forKey:@"rid"];
//        NSLog(@"%@",resultBody);
        FPNNTCPClient * fileClient = [self _getFileClient:data[@"endpoint"]];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroomfile" message:resultBody twoWay:YES];
        FPNNAnswer* answer = [fileClient sendQuest:quest timeout:timeout];
        if (answer.responseData) {
            successCallback(answer.responseData,tag);
        }else{
            failCallback(answer.error,tag);
        }
       
    } fail:^(FPNError * _Nullable error,id _Nullable tag) {
        failCallback(error,tag);
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
    [questDic setValue:@(self.pid) forKey:@"pid"];
    [questDic setValue:token forKey:@"token"];
    [questDic setValue:@(self.uid) forKey:@"from"];
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
