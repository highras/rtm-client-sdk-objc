//
//  RTMClient+FilesCategory.m
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "../fpnn/FPNNSDK.h"
#import "RTMResourceCenter.h"
#import "RTMClient+FilesCategory.h"

@implementation RTMClient (FilesCategory)

- (int)getGlobalQuestTimeout
{
    /*
     This will be implemented in future with RTM SDK class & FPPN SDK class.
     */
    return 5;
}

- (NSString*)buildFileAttrs:(NSString*)fileName withFileContent:(NSData*)fileContent andToken:(NSString*)token
{
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(fileContent.bytes, (CC_LONG)fileContent.length, md5Buffer);
    
    NSMutableString *rawDigest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [rawDigest appendFormat:@"%02x",md5Buffer[i]];
    
    [rawDigest appendString:@":"];
    [rawDigest appendString:token];
    
    uint32_t rawDigestLength = (uint32_t)[rawDigest lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    CC_MD5([rawDigest UTF8String], (CC_LONG)rawDigestLength, md5Buffer);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [digest appendFormat:@"%02x",md5Buffer[i]];
    
    return [NSString stringWithFormat:@"{\"sign\":\"%@\", \"filename\":\"%@\", \"ext\":\"%@\"}", digest, fileName, fileName.pathExtension];
}

//-----------------[Common]-----------------//
- (BOOL)internalSyncSendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType fileTokenQuest:(FPNNQuest*)fileTokenQuest fileSendQuest:(FPNNQuest*)fileSendQuest timeout:(int)timeout
{
    NSString* fileGateEndpoint;
    NSString* token;
    
    NSDate* date = [NSDate date];
    NSTimeInterval begin = date.timeIntervalSince1970;
    
    {
        FPNNAnswer* answer = [self sendQuest:fileTokenQuest withTimeout:timeout];
        if (answer.errorAnswer)
            return NO;
        
        fileGateEndpoint = (NSString*)[answer get:@"endpoint"];
        token = (NSString*)[answer get:@"token"];
    }
    
    {
        int64_t mid = [self genNewId];
        NSString* attrs = [self buildFileAttrs:filename withFileContent:fileContent andToken:token];
        
        [fileSendQuest param:@"token" value:token];
        [fileSendQuest param:@"mtype" value:[NSNumber numberWithInt:mType]];
        [fileSendQuest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
        [fileSendQuest param:@"file" value:fileContent];
        [fileSendQuest param:@"attrs" value:attrs];
        
        [self internalCompleteFilesAPIQuest:fileSendQuest];
        
        if (timeout == 0)
            timeout = [self getGlobalQuestTimeout];
        
        timeout = timeout - (int)(date.timeIntervalSince1970 - begin);
        if (timeout <= 0)
            return NO;
        
        FPNNTCPClient* fileGate = [RTMResourceCenter getFileClientWithEndpoint:fileGateEndpoint questTimeout:timeout];
        
        FPNNAnswer* answer = [fileGate sendQuest:fileSendQuest withTimeout:timeout];
        return !answer.errorAnswer;
    }
}

- (BOOL)internalAsyncSendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType fileTokenQuest:(FPNNQuest*)fileTokenQuest fileSendQuest:(FPNNQuest*)fileSendQuest withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    NSDate* date = [NSDate date];
    NSTimeInterval begin = date.timeIntervalSince1970;
    
    return [self sendQuest:fileTokenQuest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        
        if (errorCode != FPNN_EC_OK)
        {
            NSString* errorMessage = nil;
            if (payload)
                errorMessage = [payload objectForKey:@"ex"];
            
            block(NO, errorCode, errorMessage);
            return;
        }
        
        NSString* fileGateEndpoint = (NSString*)[payload valueForKey:@"endpoint"];
        NSString* token = (NSString*)[payload valueForKey:@"token"];
        
        //-- send data
        int64_t mid = [self genNewId];
        NSString* attrs = [self buildFileAttrs:filename withFileContent:fileContent andToken:token];
        
        [fileSendQuest param:@"token" value:token];
        [fileSendQuest param:@"mtype" value:[NSNumber numberWithInt:mType]];
        [fileSendQuest param:@"mid" value:[NSNumber numberWithLongLong:mid]];
        [fileSendQuest param:@"file" value:fileContent];
        [fileSendQuest param:@"attrs" value:attrs];
        
        [self internalCompleteFilesAPIQuest:fileSendQuest];
        
        int localTimeout = timeout;
        if (localTimeout == 0)
            localTimeout = [self getGlobalQuestTimeout];
        
        localTimeout = localTimeout - (int)(date.timeIntervalSince1970 - begin);
        if (localTimeout <= 0)
        {
            block(NO, FPNN_EC_CORE_TIMEOUT, @"Timeout. Prepare sending file is ready, but no data sent.");
            return;
        }
        
        FPNNTCPClient* fileGate = [RTMResourceCenter getFileClientWithEndpoint:fileGateEndpoint questTimeout:timeout];
        BOOL status = [fileGate sendQuest:fileSendQuest withCallbackBlock:^(int errorCode, NSDictionary* payload){
            
            NSString* errorMessage = nil;
            if (payload)
                errorMessage = [payload objectForKey:@"ex"];
            
            block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
            
        } timeout:localTimeout];
        
        if (!status)
        {
            block(NO, FPNN_EC_CORE_SEND_ERROR, @"Prepare file is ready, but sent failed.");
            return;
        }
    } timeout:timeout];
}

//-----------------[sendfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendfile"];
    [fileTokenQuest param:@"to" value:[NSNumber numberWithLongLong:uid]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendfile"];
    [fileSendQuest param:@"to" value:[NSNumber numberWithLongLong:uid]];
    
    return [self internalSyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toUser:uid timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendfile"];
    [fileTokenQuest param:@"to" value:[NSNumber numberWithLongLong:uid]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendfile"];
    [fileSendQuest param:@"to" value:[NSNumber numberWithLongLong:uid]];
    
    return [self internalAsyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toUser:uid withCallbackBlock:block timeout:self.questTimeout];
}

//----------------

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toUser:uid timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid
{
    return [self sendFile:filePath mType:mType toUser:uid timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toUser:uid withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filePath mType:mType toUser:uid withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendfiles]-----------------//
- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendfiles"];
    [fileTokenQuest param:@"tos" value:uids];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendfiles"];
    [fileSendQuest param:@"tos" value:uids];
    
    return [self internalSyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest timeout:timeout];
}

- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids
{
    return [self sendFiles:filename withFileContent:fileContent mType:mType toUsers:uids timeout:self.questTimeout];
}

- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendfiles"];
    [fileTokenQuest param:@"tos" value:uids];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendfiles"];
    [fileSendQuest param:@"tos" value:uids];
    
    return [self internalAsyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFiles:filename withFileContent:fileContent mType:mType toUsers:uids withCallbackBlock:block timeout:self.questTimeout];
}

//----------------

- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFiles:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toUsers:uids timeout:self.questTimeout];
}

- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids
{
    return [self sendFiles:filePath mType:mType toUsers:uids timeout:self.questTimeout];
}
- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFiles:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toUsers:uids withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFiles:filePath mType:mType toUsers:uids withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendgroupfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendgroupfile"];
    [fileTokenQuest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendgroupfile"];
    [fileSendQuest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    return [self internalSyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toGroup:groupId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendgroupfile"];
    [fileTokenQuest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendgroupfile"];
    [fileSendQuest param:@"gid" value:[NSNumber numberWithLongLong:groupId]];
    
    return [self internalAsyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toGroup:groupId withCallbackBlock:block timeout:self.questTimeout];
}

//----------------

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toGroup:groupId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId
{
    return [self sendFile:filePath mType:mType toGroup:groupId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toGroup:groupId withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filePath mType:mType toGroup:groupId withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[sendroomfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendroomfile"];
    [fileTokenQuest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendroomfile"];
    [fileSendQuest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    return [self internalSyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toRoom:roomId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* fileTokenQuest = [FPNNQuest quest:@"filetoken"];
    [fileTokenQuest param:@"cmd" value:@"sendroomfile"];
    [fileTokenQuest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    FPNNQuest* fileSendQuest = [FPNNQuest quest:@"sendroomfile"];
    [fileSendQuest param:@"rid" value:[NSNumber numberWithLongLong:roomId]];
    
    return [self internalAsyncSendFile:filename withFileContent:fileContent mType:mType fileTokenQuest:fileTokenQuest fileSendQuest:fileSendQuest withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filename withFileContent:fileContent mType:mType toRoom:roomId withCallbackBlock:block timeout:self.questTimeout];
}

//----------------

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toRoom:roomId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId
{
    return [self sendFile:filePath mType:mType toRoom:roomId timeout:self.questTimeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    if (filePath == nil || [filePath length] == 0)
        return NO;
    
    int idx = (int)[filePath.pathComponents count];
    NSString* filename = (NSString*)[filePath.pathComponents objectAtIndex:(idx - 1)];
    
    return [self sendFile:filename withFileContent:[NSData dataWithContentsOfFile:filePath] mType:mType toRoom:roomId withCallbackBlock:block timeout:timeout];
}

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self sendFile:filePath mType:mType toRoom:roomId withCallbackBlock:block timeout:self.questTimeout];
}

@end
