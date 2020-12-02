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
#import "RTMClient+FileToken.h"
#define NSAllLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

@implementation RTMClient (File)
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nullable)fileData
                fileName:(NSString * _Nullable)fileName
              fileSuffix:(NSString * _Nullable)fileSuffix
                fileType:(RTMFileType)fileType
                   attrs:(NSDictionary * _Nullable)attrs
              audioModel:(RTMAudioModel * _Nullable)audioModel
                 timeout:(int)timeout
                 success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    BOOL isAudio = NO;
    BOOL isFile = NO;
    
    if (audioModel.audioFilePath.length > 0 && audioModel.duration > 0 && audioModel.lang.length > 0 && userId != 0){
        isAudio = YES;
    }
    if (userId != 0 && fileData != nil && fileName.length > 0 && fileSuffix.length > 0) {
        isFile = YES;
    }
    if (isAudio == NO && isFile == NO) {
        FPNSLog(@"rtm sendP2PFileWithId error. invalid parameter");
        return;
    }
        
    [self getP2PFileTokenWithId:userId
                        timeout:RTMClientFileQuestTimeout
                        success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getP2PFileTokenWithId return data is nil");
            return ;
        }
        NSDictionary * resultBody;
        
        if (isAudio == YES) {//audio
            
            NSString * audioFilePath = audioModel.audioFilePath;
            int duration = audioModel.duration;
            NSString * lang = audioModel.lang;
            
            NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
            if (audioData == nil) {
                FPNSLog(@"rtm P2P audioMessage get audioData error");
                return ;
            }
            if ([RTMAudioTools isAmrVerify:audioData] == NO) {
                FPNSLog(@"rtm P2P sendAudioMessageChatWithId no amr type");
                return ;
            }
            
            resultBody = [self getAudioFileQuestBody:data
                                              recvId:userId
                                            fileData:audioData
                                                lang:lang
                                            duration:duration
                                               attrs:attrs];
        }else if(isFile == YES){// file
            
            resultBody =    [self getFileQuestBody:data
                                            recvId:userId
                                            fileData:fileData
                                            fileName:fileName
                                            fileSuffix:fileSuffix
                                            fileType:fileType
                                            attrs:attrs];
       
                                                        
        }
        
        
        [resultBody setValue:userId forKey:@"to"];
//        NSLog(@"%@",resultBody);
//
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
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
        
       
    } fail:^(FPNError * _Nullable error) {
        
        _failCallback(error);
        
    }];
        
}
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                  fileData:(NSData * _Nullable)fileData
                  fileName:(NSString * _Nullable)fileName
                fileSuffix:(NSString * _Nullable)fileSuffix
                  fileType:(RTMFileType)fileType
                     attrs:(NSDictionary * _Nullable)attrs
                 audioModel:(RTMAudioModel * _Nullable)audioModel
                    timeout:(int)timeout
                    success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                      fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    BOOL isAudio = NO;
    BOOL isFile = NO;
    
    if (audioModel.audioFilePath.length > 0 && audioModel.duration > 0  && audioModel.lang.length > 0 && groupId != 0){
        isAudio = YES;
    }
    NSLog(@"%@  %@  %@  %@",groupId,fileData,fileName,fileSuffix);
    if (groupId != 0 && fileData != nil && fileName.length > 0 && fileSuffix.length > 0) {
        isFile = YES;
    }
    if (isAudio == NO && isFile == NO) {
        FPNSLog(@"rtm sendGroupFileWithId error. invalid parameter  %d   %d",isAudio,isFile);
        return;
    }
    
    [self getGroupFileTokenWithId:groupId
                          timeout:RTMClientFileQuestTimeout
                          success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getGroupFileToken return data is nil");
            return ;
        }
        
        NSDictionary * resultBody;
        
        if (isAudio == YES) {//audio
            
            NSString * audioFilePath = audioModel.audioFilePath;
            int duration = audioModel.duration;
            NSString * lang = audioModel.lang;
            
            NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
            if (audioData == nil) {
                FPNSLog(@"rtm group audioMessage get audioData error");
                return ;
            }
            if ([RTMAudioTools isAmrVerify:audioData] == NO) {
                FPNSLog(@"rtm group sendAudioMessageChatWithId no amr type");
                return ;
            }
            
            resultBody = [self getAudioFileQuestBody:data
                                              recvId:groupId
                                            fileData:audioData
                                                lang:lang
                                            duration:duration
                                               attrs:attrs];
        }else if(isFile == YES){// file
            
            resultBody =    [self getFileQuestBody:data
                                            recvId:groupId
                                            fileData:fileData
                                            fileName:fileName
                                            fileSuffix:fileSuffix
                                            fileType:fileType
                                            attrs:attrs];
       
                                                        
        }
        
        
        
        [resultBody setValue:groupId forKey:@"gid"];
//        NSLog(@"%@",resultBody);
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
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

       
    } fail:^(FPNError * _Nullable error) {
        _failCallback(error);
    }];
    
}
//
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nullable)fileData
                 fileName:(NSString * _Nullable)fileName
               fileSuffix:(NSString * _Nullable)fileSuffix
                 fileType:(RTMFileType)fileType
                    attrs:(NSDictionary * _Nullable)attrs
               audioModel:(RTMAudioModel * _Nullable)audioModel
                  timeout:(int)timeout
                  success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback{
    
    BOOL isAudio = NO;
    BOOL isFile = NO;
    
    if (audioModel.audioFilePath.length > 0 && audioModel.duration > 0  && audioModel.lang.length > 0 && roomId != 0){
        isAudio = YES;
    }
    if (roomId != 0 && fileData != nil && fileName.length > 0 && fileSuffix.length > 0) {
        isFile = YES;
    }
    if (isAudio == NO && isFile == NO) {
        FPNSLog(@"rtm sendRoomFileWithId error. invalid parameter");
        return;
    }
    
    [self getRoomFileTokenWithId:roomId
                         timeout:RTMClientFileQuestTimeout
                         success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getRoomFileTokenWithId return data is nil");
            return ;
        }
        
        NSDictionary * resultBody;
        
        if (isAudio == YES) {//audio
            
            NSString * audioFilePath = audioModel.audioFilePath;
            int duration = audioModel.duration;
            NSString * lang = audioModel.lang;
            
            NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
            if (audioData == nil) {
                FPNSLog(@"rtm room audioMessage get audioData error");
                return ;
            }
            if ([RTMAudioTools isAmrVerify:audioData] == NO) {
                FPNSLog(@"rtm room sendAudioMessageChatWithId no amr type");
                return ;
            }
            
            resultBody = [self getAudioFileQuestBody:data
                                              recvId:roomId
                                            fileData:audioData
                                                lang:lang
                                            duration:duration
                                               attrs:attrs];
        }else if(isFile == YES){// file
            
            resultBody =    [self getFileQuestBody:data
                                            recvId:roomId
                                            fileData:fileData
                                            fileName:fileName
                                            fileSuffix:fileSuffix
                                            fileType:fileType
                                            attrs:attrs];
       
                                                        
        }
        
        
        
        [resultBody setValue:roomId forKey:@"rid"];
//        NSLog(@"%@",resultBody);
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
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

       
    } fail:^(FPNError * _Nullable error) {
        _failCallback(error);
    }];
    
}





@end
