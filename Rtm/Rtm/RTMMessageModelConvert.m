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
//+(RTMMessage*)audioModelConvert:(NSDictionary*)data chatType:(RTMChatType)chatType{
//
//     RTMMessage * msgOb = [[RTMMessage alloc] init];
//     msgOb.fromUid = [[data objectForKey:@"from"] longLongValue];
//     msgOb.messageId = [[data objectForKey:@"mid"] longLongValue];
//     msgOb.messageType = [[data objectForKey:@"mtype"] intValue];
//     msgOb.attrs = [data objectForKey:@"attrs"] ;
//     msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
//
//     switch (chatType) {
//             case RTMP2p:
//             {
//                 msgOb.toId = [[data objectForKey:@"to"] longLongValue];
//             }
//             break;
//             case RTMGroup:
//             {
//                 msgOb.toId = [[data objectForKey:@"gid"] longLongValue];
//             }
//                 break;
//             case RTMRoom:
//             {
//                 msgOb.toId = [[data objectForKey:@"rid"] longLongValue];
//             }
//                 break;
//             case RTMBroadcast:
//             {
//
//             }
//                 break;
//         default:
//             break;
//     }
//
//     if([[data objectForKey:@"msg"] isKindOfClass:[NSString class]]){
//
//         NSString * dicString  =[data objectForKey:@"msg"];
//         NSData *jsonData = [dicString dataUsingEncoding:NSUTF8StringEncoding];
//         NSError * error;
//         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//         if (error == nil) {
//             RTMAudioInfo * audioInfo = [RTMAudioInfo new];
//             audioInfo.sourceLanguage = [resultDic objectForKey:@"sl"];
//             audioInfo.recognizedLanguage = [resultDic objectForKey:@"rl"];
//             audioInfo.recognizedText = [resultDic objectForKey:@"rt"];
//             audioInfo.duration = [[resultDic objectForKey:@"du"] intValue];
//             msgOb.audioInfo = audioInfo;
//         }
//
//     }
//
//     return msgOb;
//
//}
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
     msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[data objectForKey:@"attrs"]];
     msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
     msgOb.fileInfo = [RTMFileInfo fileModelConvert:[data objectForKey:@"msg"] attrs:[data objectForKey:@"attrs"]];
    
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

+(RTMHistoryMessage*)p2pHistoryMessageModelConvert:(NSArray*)itemArray toUserId:(int64_t)toUserId myUserId:(int64_t)myUserId{
    
//    NSLog(@"%@",itemArray);
    RTMHistoryMessage * msgOb = [RTMHistoryMessage new];
    if ([[itemArray objectAtIndex:1] intValue] == 1) {//1是我发的  2不是
        msgOb.fromUid = myUserId;
        msgOb.toId = toUserId;
    }else{
        msgOb.fromUid = toUserId;
        msgOb.toId = myUserId;
    }
    msgOb.cursorId = [[itemArray objectAtIndex:0] longLongValue];
    msgOb.messageType = [[itemArray objectAtIndex:2] intValue];
    msgOb.messageId = [[itemArray objectAtIndex:3] longLongValue];
    msgOb.modifiedTime = [[itemArray objectAtIndex:7] longLongValue];
    msgOb.attrs = [itemArray objectAtIndex:6];
    
    if (msgOb.messageType == 30) {//chat msg
        
        RTMTranslatedInfo * translatedInfo = [RTMTranslatedInfo new];
        translatedInfo.sourceText = [itemArray objectAtIndex:5];
        msgOb.translatedInfo = translatedInfo;
        msgOb.stringMessage = translatedInfo.sourceText;
        
    }else if (msgOb.messageType == 40  || msgOb.messageType == 41 || msgOb.messageType == 42 || msgOb.messageType == 50){//chat audio
        
        if ([[itemArray objectAtIndex:5] isKindOfClass:[NSString class]]) {

            RTMFileInfo * fileInfo = [RTMFileInfo fileModelConvert:[itemArray objectAtIndex:5] attrs:msgOb.attrs];
            msgOb.fileInfo = fileInfo;
            msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[itemArray objectAtIndex:6]];
            
        }
        
    
    }else{
        
        id msg = [itemArray objectAtIndex:5];
        if ([msg isKindOfClass:[NSData class]]) {
            msgOb.binaryMessage = msg;
        }else if ([msg isKindOfClass:[NSString class]]){
            msgOb.stringMessage = msg;
        }
        
    }
        
    
    
    return msgOb;
}

+(RTMHistoryMessage*)groupHistoryMessageModelConvert:(NSArray*)itemArray{
    
    
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
        msgOb.stringMessage = translatedInfo.sourceText;
        
    }else if (msgOb.messageType == 40  || msgOb.messageType == 41 || msgOb.messageType == 42 || msgOb.messageType == 50){//chat audio
        
        if ([[itemArray objectAtIndex:5] isKindOfClass:[NSString class]]) {

            RTMFileInfo * fileInfo = [RTMFileInfo fileModelConvert:[itemArray objectAtIndex:5] attrs:msgOb.attrs];
            msgOb.fileInfo = fileInfo;
            msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[itemArray objectAtIndex:6]];
        }
        
    
    }else{
        
        id msg = [itemArray objectAtIndex:5];
        if ([msg isKindOfClass:[NSData class]]) {
            msgOb.binaryMessage = msg;
        }else if ([msg isKindOfClass:[NSString class]]){
            msgOb.stringMessage = msg;
        }
        
    }
        
    
    
    return msgOb;
    
    
}
+(RTMHistoryMessage*)roomHistoryMessageModelConvert:(NSArray*)itemArray{
    
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
        msgOb.stringMessage = translatedInfo.sourceText;
        
    }else if (msgOb.messageType == 40  || msgOb.messageType == 41 || msgOb.messageType == 42 || msgOb.messageType == 50){//chat audio
        
        if ([[itemArray objectAtIndex:5] isKindOfClass:[NSString class]]) {

            RTMFileInfo * fileInfo = [RTMFileInfo fileModelConvert:[itemArray objectAtIndex:5] attrs:msgOb.attrs];
            msgOb.fileInfo = fileInfo;
            msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[itemArray objectAtIndex:6]];
        }
        
    
    }else{
        
        id msg = [itemArray objectAtIndex:5];
        if ([msg isKindOfClass:[NSData class]]) {
            msgOb.binaryMessage = msg;
        }else if ([msg isKindOfClass:[NSString class]]){
            msgOb.stringMessage = msg;
        }
        
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
        msgOb.stringMessage = translatedInfo.sourceText;
        
    }else if (msgOb.messageType == 40  || msgOb.messageType == 41 || msgOb.messageType == 42 || msgOb.messageType == 50){//chat audio
        
        if ([[itemArray objectAtIndex:5] isKindOfClass:[NSString class]]) {

            RTMFileInfo * fileInfo = [RTMFileInfo fileModelConvert:[itemArray objectAtIndex:5] attrs:msgOb.attrs];
            msgOb.fileInfo = fileInfo;
            msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[itemArray objectAtIndex:6]];
            
        }
        
    
    }else{
        
        id msg = [itemArray objectAtIndex:5];
        if ([msg isKindOfClass:[NSData class]]) {
            msgOb.binaryMessage = msg;
        }else if ([msg isKindOfClass:[NSString class]]){
            msgOb.stringMessage = msg;
        }
        
        
    }
        
    return msgOb;
    
}

+(NSString * )handleAttrsWithAttrsString:(NSString*)attrsString{
    
    NSString * result;
    NSString * attrs = attrsString;
    NSData *jsonDataAttrs = [attrs dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attrsDic = [NSJSONSerialization JSONObjectWithData:jsonDataAttrs
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    if (attrsDic != nil) {
        if ([attrsDic objectForKey:@"custom"] != nil) {
            
            if ([[attrsDic objectForKey:@"custom"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary * custom = [attrsDic objectForKey:@"custom"];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:custom options:NSJSONWritingPrettyPrinted error:nil];
                NSString * customString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                result = customString;
                
            }else if([[attrsDic objectForKey:@"custom"] isKindOfClass:[NSString class]]){
                
                result = [attrsDic objectForKey:@"custom"];
                
            }
            
        }
        
    }
    
    return result;
}

+(RTMGetMessage*)getMessageModelConvert:(NSDictionary*)data{
    
    RTMGetMessage * msgOb = [RTMGetMessage new];
    msgOb.cursorId = [[data objectForKey:@"id"] longLongValue];
    msgOb.messageType = [[data objectForKey:@"mtype"] longLongValue];
    msgOb.attrs = [data objectForKey:@"attrs"];
    msgOb.modifiedTime = [[data objectForKey:@"mtime"] longLongValue];
    
    
    id resultData = [data objectForKey:@"msg"];
    
    if(msgOb.messageType == 40  || msgOb.messageType == 41 || msgOb.messageType == 42 || msgOb.messageType == 50){
        
        if ([resultData isKindOfClass:[NSString class]]) {
            NSString * msg = resultData;
            RTMFileInfo * fileInfo = [RTMFileInfo fileModelConvert:msg attrs:msgOb.attrs];
            msgOb.fileInfo = fileInfo;
            msgOb.attrs = [RTMMessageModelConvert handleAttrsWithAttrsString:[data objectForKey:@"attrs"]];
        }
        
        
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
