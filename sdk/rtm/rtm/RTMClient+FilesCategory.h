//
//  RTMClient+FilesCategory.h
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"

@interface RTMClient (FilesCategory)

//-----------------[sendfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toUser:(int64_t)uid withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendfiles]-----------------//
- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout;
- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids;
- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFiles:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids timeout:(int)timeout;
- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids;
- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFiles:(NSString*)filePath mType:(int8_t)mType toUsers:(NSSet<NSNumber*>*)uids withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendgroupfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toGroup:(int64_t)groupId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[sendroomfile]-----------------//
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filename withFileContent:(NSData*)fileContent mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)sendFile:(NSString*)filePath mType:(int8_t)mType toRoom:(int64_t)roomId withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

@end
