//
//  RTMClient+MiscCategory.h
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "RTMClient.h"

struct RTMGeoInfo
{
    double latitude;
    double longitude;
};

@interface RTMClient (MiscCategory)

//-----------------[addvariables]-----------------//
- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables timeout:(int)timeout;
- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables;
- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[adddebuglog]-----------------//
- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout;
- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs;
- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[setpushname]-----------------//
- (BOOL)setPushName:(NSString*)pushName timeout:(int)timeout;
- (BOOL)setPushName:(NSString*)pushName;
- (BOOL)setPushName:(NSString*)pushName withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)setPushName:(NSString*)pushName withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[getpushname]-----------------//
- (NSString*)getPushName:(int)timeout;
- (NSString*)getPushName;
- (BOOL)getPushNameWithCallbackBlock:(void(^)(NSString* pushName, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getPushNameWithCallbackBlock:(void(^)(NSString* pushName, int errorCode, NSString* errorMessage))block;

//-----------------[setgeo]-----------------//
- (BOOL)setGeo:(double)latitude longitude:(double)longitude timeout:(int)timeout;
- (BOOL)setGeo:(double)latitude longitude:(double)longitude;
- (BOOL)setGeo:(double)latitude longitude:(double)longitude withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)setGeo:(double)latitude longitude:(double)longitude withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

//-----------------[getgeo]-----------------//
- (struct RTMGeoInfo)getGeo:(int)timeout;
- (struct RTMGeoInfo)getGeo;
- (BOOL)getGeoWithCallbackBlock:(void(^)(struct RTMGeoInfo geoInfo, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)getGeoWithCallbackBlock:(void(^)(struct RTMGeoInfo geoInfo, int errorCode, NSString* errorMessage))block;

//-----------------[adddevice]-----------------//
- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token timeout:(int)timeout;
- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token;
- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout;
- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block;

@end
