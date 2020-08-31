//
//  RTMMessageModelConvert.m
//  Rtm
//
//  Created by zsl on 2020/8/5.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMMessageModelConvert.h"
#import "RTMTranslatedInfo.h"
#import "RTMAudioInfo.h"
#import "RTMAudioTools.h"
@implementation RTMMessageModelConvert
+(RTMMessage*)messageModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType{
    
    RTMMessage * msgOb = [[RTMMessage alloc] init];
    msgOb.fromUid = [[data objectForKey:@"from"] longLongValue];
    msgOb.messageId = [[data objectForKey:@"mid"] longLongValue];
    msgOb.messageType = [[data objectForKey:@"mtype"] intValue];
    msgOb.attrs = [data objectForKey:@"attrs"] ;
    msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
    
    switch (chatType) {
            case RTMP2p:
            {
                msgOb.toId = [[data objectForKey:@"to"] longLongValue];
            }
            break;
            case RTMGroup:
            {
                msgOb.toId = [[data objectForKey:@"gid"] longLongValue];
            }
                break;
            case RTMRoom:
            {
                msgOb.toId = [[data objectForKey:@"rid"] longLongValue];
            }
                break;
            case RTMBroadcast:
            {
               
            }
                break;
        default:
            break;
    }
    
    if ([[data objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary * msgDic = [data objectForKey:@"msg"];
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        
        translatedInfo.source = [msgDic objectForKey:@"source"];
        translatedInfo.sourceText = [msgDic objectForKey:@"sourceText"];
        translatedInfo.target = [msgDic objectForKey:@"target"];
        translatedInfo.targetText = [msgDic objectForKey:@"targetText"];
        
        msgOb.translatedInfo = translatedInfo;
        
    }else if([[data objectForKey:@"msg"] isKindOfClass:[NSString class]]){
        msgOb.stringMessage = [data objectForKey:@"msg"];
    }else if([[data objectForKey:@"msg"] isKindOfClass:[NSData class]]){
        msgOb.binaryMessage = [data objectForKey:@"msg"];
    }
   
    return msgOb;
}
+(RTMMessage*)audioModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType{
    
     RTMMessage * msgOb = [[RTMMessage alloc] init];
     msgOb.fromUid = [[data objectForKey:@"from"] longLongValue];
     msgOb.messageId = [[data objectForKey:@"mid"] longLongValue];
     msgOb.messageType = [[data objectForKey:@"mtype"] intValue];
     msgOb.attrs = [data objectForKey:@"attrs"] ;
     msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
     
     switch (chatType) {
             case RTMP2p:
             {
                 msgOb.toId = [[data objectForKey:@"to"] longLongValue];
             }
             break;
             case RTMGroup:
             {
                 msgOb.toId = [[data objectForKey:@"gid"] longLongValue];
             }
                 break;
             case RTMRoom:
             {
                 msgOb.toId = [[data objectForKey:@"rid"] longLongValue];
             }
                 break;
             case RTMBroadcast:
             {
                
             }
                 break;
         default:
             break;
     }
     
     if([[data objectForKey:@"msg"] isKindOfClass:[NSString class]]){
         
         NSString * dicString  =[data objectForKey:@"msg"];
         NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
         NSError * error;
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
         if (error == nil) {
             RTMAudioInfo * audioInfo = [RTMAudioInfo new];
             audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
             audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
             audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
             audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
             msgOb.audioInfo = audioInfo;
         }
         
     }
    
     return msgOb;
    
}
+(RTMMessage*)cmdModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType{
    
     RTMMessage * msgOb = [[RTMMessage alloc] init];
     msgOb.fromUid = [[data objectForKey:@"from"] longLongValue];
     msgOb.messageId = [[data objectForKey:@"mid"] longLongValue];
     msgOb.messageType = [[data objectForKey:@"mtype"] intValue];
     msgOb.attrs = [data objectForKey:@"attrs"] ;
     msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
     msgOb.stringMessage = [data objectForKey:@"msg"];
     
    switch (chatType) {
            case RTMP2p:
            {
                msgOb.toId = [[data objectForKey:@"to"] longLongValue];
            }
            break;
            case RTMGroup:
            {
                msgOb.toId = [[data objectForKey:@"gid"] longLongValue];
            }
                break;
            case RTMRoom:
            {
                msgOb.toId = [[data objectForKey:@"rid"] longLongValue];
            }
                break;
            case RTMBroadcast:
            {
               
            }
                break;
        default:
            break;
    }
    
     return msgOb;
    
}
+(RTMMessage*)fileModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType{
    
    RTMMessage * msgOb = [[RTMMessage alloc] init];
     msgOb.fromUid = [[data objectForKey:@"from"] longLongValue];
     msgOb.messageId = [[data objectForKey:@"mid"] longLongValue];
     msgOb.messageType = [[data objectForKey:@"mtype"] intValue];
     msgOb.attrs = [data objectForKey:@"attrs"] ;
     msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
     msgOb.stringMessage = [data objectForKey:@"msg"];
     
    switch (chatType) {
            case RTMP2p:
            {
                msgOb.toId = [[data objectForKey:@"to"] longLongValue];
            }
            break;
            case RTMGroup:
            {
                msgOb.toId = [[data objectForKey:@"gid"] longLongValue];
            }
                break;
            case RTMRoom:
            {
                msgOb.toId = [[data objectForKey:@"rid"] longLongValue];
            }
                break;
            case RTMBroadcast:
            {
               
            }
                break;
        default:
            break;
    }
    
     return msgOb;
    
}

+(RTMHistoryMessage*)p2pHistoryMessageModelConvert:(NSArray*)itemArray{
    
    RTMHistoryMessage * msgOb = [RTMHistoryMessage new];
    msgOb.cursorId = [[itemArray objectAtIndex:0] longLongValue];
    msgOb.messageType = [[itemArray objectAtIndex:2] intValue];
    msgOb.messageId = [[itemArray objectAtIndex:3] longLongValue];
    msgOb.attrs = [itemArray objectAtIndex:6];
    msgOb.modifiedTime = [[itemArray objectAtIndex:7] longLongValue];
    
    if (msgOb.messageType == 30) {//chat msg
        
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.sourceText = [itemArray objectAtIndex:5];
        msgOb.translatedInfo = translatedInfo;
        
    }else if (msgOb.messageType == 31){//chat audio
        
        NSString * dicString = [itemArray objectAtIndex:5];
        NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            RTMAudioInfo * audioInfo = [RTMAudioInfo new];
            audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
            audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
            audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
            audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
            msgOb.audioInfo = audioInfo;
        }
    
    }else{
        msgOb.stringMessage = [itemArray objectAtIndex:5];
    }
        
    
    
    return msgOb;
}

+(RTMHistoryMessage*)groupHistoryMessageModelConvert:(NSArray*)itemArray{
    
    
    RTMHistoryMessage * msgOb = [RTMHistoryMessage new];
    msgOb.cursorId = [[itemArray objectAtIndex:0] longLongValue];
    msgOb.fromUid = [[itemArray objectAtIndex:1] longLongValue];
    msgOb.messageType = [[itemArray objectAtIndex:2] intValue];
    msgOb.messageId = [[itemArray objectAtIndex:3] longLongValue];
    msgOb.attrs = [itemArray objectAtIndex:5];
    msgOb.modifiedTime = [[itemArray objectAtIndex:6] longLongValue];
    
    if (msgOb.messageType == 30) {//chat msg
        
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.sourceText = [itemArray objectAtIndex:5];
        msgOb.translatedInfo = translatedInfo;
        
    }else if (msgOb.messageType == 31){//chat audio
        
        NSString * dicString = [itemArray objectAtIndex:5];
        NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            RTMAudioInfo * audioInfo = [RTMAudioInfo new];
            audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
            audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
            audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
            audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
            msgOb.audioInfo = audioInfo;
        }
    
    }else{
        msgOb.stringMessage = [itemArray objectAtIndex:5];
    }
        
    
    
    return msgOb;
    
    
}
+(RTMHistoryMessage*)roomHistoryMessageModelConvert:(NSArray*)itemArray{
    
    RTMHistoryMessage * msgOb = [RTMHistoryMessage new];
    msgOb.cursorId = [[itemArray objectAtIndex:0] longLongValue];
    msgOb.fromUid = [[itemArray objectAtIndex:1] longLongValue];
    msgOb.messageType = [[itemArray objectAtIndex:2] intValue];
    msgOb.messageId = [[itemArray objectAtIndex:3] longLongValue];
    msgOb.attrs = [itemArray objectAtIndex:5];
    msgOb.modifiedTime = [[itemArray objectAtIndex:6] longLongValue];
    
    if (msgOb.messageType == 30) {//chat msg
        
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.sourceText = [itemArray objectAtIndex:5];
        msgOb.translatedInfo = translatedInfo;
        
    }else if (msgOb.messageType == 31){//chat audio
        
        NSString * dicString = [itemArray objectAtIndex:5];
        NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            RTMAudioInfo * audioInfo = [RTMAudioInfo new];
            audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
            audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
            audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
            audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
            msgOb.audioInfo = audioInfo;
        }
    
    }else{
        msgOb.stringMessage = [itemArray objectAtIndex:5];
    }
        
    
    
    return msgOb;
    
}
+(RTMHistoryMessage*)broadcastHistoryMessageModelConvert:(NSArray*)itemArray{
    
    RTMHistoryMessage * msgOb = [RTMHistoryMessage new];
    msgOb.cursorId = [[itemArray objectAtIndex:0] longLongValue];
    msgOb.fromUid = [[itemArray objectAtIndex:1] longLongValue];
    msgOb.messageType = [[itemArray objectAtIndex:2] intValue];
    msgOb.messageId = [[itemArray objectAtIndex:3] longLongValue];
    msgOb.attrs = [itemArray objectAtIndex:6];
    msgOb.modifiedTime = [[itemArray objectAtIndex:7] longLongValue];
    
    if (msgOb.messageType == 30) {//chat msg
        
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.sourceText = [itemArray objectAtIndex:5];
        msgOb.translatedInfo = translatedInfo;
        
    }else if (msgOb.messageType == 31){//chat audio
        
        NSString * dicString = [itemArray objectAtIndex:5];
        NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            RTMAudioInfo * audioInfo = [RTMAudioInfo new];
            audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
            audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
            audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
            audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
            msgOb.audioInfo = audioInfo;
        }
    
    }else{
        msgOb.stringMessage = [itemArray objectAtIndex:5];
    }
        
    return msgOb;
    
}

+(RTMGetMessage*)getMessageModelConvert:(NSDictionary*)data{
    
    RTMGetMessage * msgOb = [RTMGetMessage new];
    msgOb.cursorId = [[data objectForKey:@"id"] longLongValue];
    msgOb.messageType = [[data objectForKey:@"mtype"] longLongValue];
    msgOb.attrs = [data objectForKey:@"attrs"];
    msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
    
    
    id resultData = [data objectForKey:@"msg"];
    if (msgOb.messageType == 31 && [resultData isKindOfClass:[NSData class]]) {
        
        msgOb.audioMessage = [RTMAudioTools audioDataRemoveHeader:resultData];
        
    }else{
        
        if ([resultData isKindOfClass:[NSData class]]) {
            msgOb.binaryMessage = resultData;
        }else if([ resultData isKindOfClass:[NSString class]]){
            msgOb.stringMessage = resultData;
        }
        
    
    }
    
    return msgOb;
    
}

@end
