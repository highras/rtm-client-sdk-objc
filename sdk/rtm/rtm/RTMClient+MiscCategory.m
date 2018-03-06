//
//  RTMClient+MiscCategory.m
//  rtm
//
//  Created by 施王兴 on 2018/1/12.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#import "../fpnn/FPNNSDK.h"
#import "RTMClient+MiscCategory.h"

@implementation RTMClient (MiscCategory)

//-----------------[addvariables]-----------------//
- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addvariables"];
    [quest param:@"var" value:variables];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables
{
    return [self addVariables:variables timeout:self.questTimeout];
}

- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"addvariables"];
    [quest param:@"var" value:variables];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)addVariables:(NSDictionary<NSString*, NSString*>*)variables withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self addVariables:variables withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[adddebuglog]-----------------//
- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"adddebuglog"];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs
{
    return [self addDebugLog:message attrs:attrs timeout:self.questTimeout];
}

- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"adddebuglog"];
    [quest param:@"msg" value:message];
    [quest param:@"attrs" value:attrs];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)addDebugLog:(NSString*)message attrs:(NSString*)attrs withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self addDebugLog:message attrs:attrs withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[setpushname]-----------------//
- (BOOL)setPushName:(NSString*)pushName timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setpushname"];
    [quest param:@"pushname" value:pushName];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)setPushName:(NSString*)pushName
{
    return [self setPushName:pushName timeout:self.questTimeout];
}

- (BOOL)setPushName:(NSString*)pushName withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setpushname"];
    [quest param:@"pushname" value:pushName];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)setPushName:(NSString*)pushName withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self setPushName:pushName withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getpushname]-----------------//
- (NSString*)getPushName:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getpushname"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return (NSString*)[answer get:@"pushname"];
}

- (NSString*)getPushName
{
    return [self getPushName:self.questTimeout];
}

- (BOOL)getPushNameWithCallbackBlock:(void(^)(NSString* pushName, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getpushname"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        NSString* pushName = nil;
        if (payload)
        {
            errorMessage = [payload objectForKey:@"ex"];
            pushName = [payload objectForKey:@"pushname"];
        }
        
        block(pushName, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)getPushNameWithCallbackBlock:(void(^)(NSString* pushName, int errorCode, NSString* errorMessage))block
{
    return [self getPushNameWithCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[setgeo]-----------------//
- (BOOL)setGeo:(double)latitude longitude:(double)longitude timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setgeo"];
    [quest param:@"lat" value:[NSNumber numberWithDouble:latitude]];
    [quest param:@"lng" value:[NSNumber numberWithDouble:longitude]];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)setGeo:(double)latitude longitude:(double)longitude
{
    return [self setGeo:latitude longitude:longitude timeout:self.questTimeout];
}

- (BOOL)setGeo:(double)latitude longitude:(double)longitude withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"setgeo"];
    [quest param:@"lat" value:[NSNumber numberWithDouble:latitude]];
    [quest param:@"lng" value:[NSNumber numberWithDouble:longitude]];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)setGeo:(double)latitude longitude:(double)longitude withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self setGeo:latitude longitude:longitude withCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[getgeo]-----------------//
- (struct RTMGeoInfo)getGeo:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgeo"];
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    
    NSNumber* lat = (NSNumber*)[answer get:@"lat"];
    NSNumber* lng = (NSNumber*)[answer get:@"lng"];
    
    struct RTMGeoInfo info;
    info.latitude = lat ? lat.doubleValue : 255.0;      //-- 255.0: refer to interface define.
    info.longitude = lng ? lng.doubleValue : 255.0;
    
    return info;
}

- (struct RTMGeoInfo)getGeo
{
    return [self getGeo:self.questTimeout];
}

- (BOOL)getGeoWithCallbackBlock:(void(^)(struct RTMGeoInfo geoInfo, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"getgeo"];
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        
        NSString* errorMessage = nil;
        
        struct RTMGeoInfo info;
        info.latitude = 255.0;      //-- 255.0: refer to interface define.
        info.longitude = 255.0;
        
        if (errorCode == FPNN_EC_OK)
        {
            NSNumber* lat = (NSNumber*)[payload objectForKey:@"lat"];
            NSNumber* lng = (NSNumber*)[payload objectForKey:@"lng"];
            
            info.latitude = lat.doubleValue;
            info.longitude = lng.doubleValue;
        }
        else if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(info, errorCode, errorMessage);
        
    } timeout:timeout];
}

- (BOOL)getGeoWithCallbackBlock:(void(^)(struct RTMGeoInfo geoInfo, int errorCode, NSString* errorMessage))block
{
    return [self getGeoWithCallbackBlock:block timeout:self.questTimeout];
}

//-----------------[adddevice]-----------------//
- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"adddevice"];
    [quest param:@"ptype" value:pType];
    [quest param:@"dtype" value:dType];
    [quest param:@"token" value:token];
    
    FPNNAnswer* answer = [self sendQuest:quest withTimeout:timeout];
    return !answer.errorAnswer;
}

- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token
{
    return [self addDevice:pType dType:dType token:token timeout:self.questTimeout];
}

- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block timeout:(int)timeout
{
    FPNNQuest* quest = [FPNNQuest quest:@"adddevice"];
    [quest param:@"ptype" value:pType];
    [quest param:@"dtype" value:dType];
    [quest param:@"token" value:token];
    
    return [self sendQuest:quest withCallbackBlock:^(int errorCode, NSDictionary* payload){
        NSString* errorMessage = nil;
        if (payload)
            errorMessage = [payload objectForKey:@"ex"];
        
        block(errorCode == FPNN_EC_OK, errorCode, errorMessage);
    } timeout:timeout];
}

- (BOOL)addDevice:(NSString*)pType dType:(NSString*)dType token:(NSString*)token withCallbackBlock:(void(^)(BOOL done, int errorCode, NSString* errorMessage))block
{
    return [self addDevice:pType dType:dType token:token withCallbackBlock:block timeout:self.questTimeout];
}

@end
