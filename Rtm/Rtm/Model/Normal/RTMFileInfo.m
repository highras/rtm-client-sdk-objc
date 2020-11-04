//
//  RTMFileInfo.m
//  Rtm
//
//  Created by zsl on 2020/10/20.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMFileInfo.h"

@implementation RTMFileInfo
//-(NSString*)description{
//    return [NSString stringWithFormat:@"_url = %@      _surl = %@     _size = %ld     _lang = %@      _duration = %d   ",_url,_surl,_size,_lang,_duration];
//}

+(BOOL)isRtmAudio:(NSString*)attrsString{
    BOOL isRtmAudio = NO;
    if ([attrsString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [attrsString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if (dic != nil) {
            //rtm audio
            if ([[dic objectForKey:@"rtm"] isKindOfClass:[NSDictionary class]]) {
                if ([[[dic objectForKey:@"rtm"] objectForKey:@"type"] isEqualToString:@"audiomsg"]) {
                    isRtmAudio = YES;
                }
            }
        }
        
    }
    
    
    return isRtmAudio;
}
+(RTMFileInfo*)fileModelConvert:(NSString*)msg attrs:(NSString*)attrs{
    
    RTMFileInfo * fileInfo;
    NSData *jsonDataAttrs = [attrs dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attrsDic = [NSJSONSerialization JSONObjectWithData:jsonDataAttrs
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    NSData *jsonDataMsg = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *msgDic = [NSJSONSerialization JSONObjectWithData:jsonDataMsg
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    NSDictionary * rtmDic = [attrsDic objectForKey:@"rtm"];
    if (attrsDic != nil && msgDic != nil && rtmDic != nil) {
        fileInfo = [RTMFileInfo new];
        fileInfo.url = [msgDic objectForKey:@"url"];
        fileInfo.surl = [msgDic objectForKey:@"surl"];
        fileInfo.size =  [[msgDic objectForKey:@"size"] longValue];
        fileInfo.lang = [rtmDic objectForKey:@"lang"];
        fileInfo.duration = [[rtmDic objectForKey:@"duration"] intValue];
        fileInfo.codec = [rtmDic objectForKey:@"codec"];
        fileInfo.srate = [[rtmDic objectForKey:@"srate"] intValue];
        fileInfo.isRtmAudio = [RTMFileInfo isRtmAudio:attrs];
    }
    
        
    
        
    
    return fileInfo;
}
@end
