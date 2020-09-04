//
//  RTMClient+MessagesManager.m
//  Rtm
//
//  Created by zsl on 2020/7/22.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMClient+MessagesManager.h"
#import <objc/runtime.h>
#import "RTMMessageModelConvert.h"

@interface RTMClient()
@property(nonatomic,strong)NSCache * messageDuplicatedCache;
@end
@implementation RTMClient (MessagesManager)

-(void)messageShareCenter:(NSDictionary*)data method:(NSString*)method{
    
    if (self.messageDuplicatedCache == nil) {
        self.messageDuplicatedCache = [[NSCache alloc]init];
        self.messageDuplicatedCache.countLimit = 10000;
    }
    
    if ([method isEqualToString:@"pushmsg"]){
        [self _pushmsg:data method:method];
    }else if ([method isEqualToString:@"pushgroupmsg"]){
        [self _pushgroupmsg:data method:method];
    }else if ([method isEqualToString:@"pushroommsg"]){
        [self _pushroommsg:data method:method];
    }else if ([method isEqualToString:@"pushbroadcastmsg"]){
        [self _pushbroadcastmsg:data method:method];
    }
    
}

#pragma mark p2p msg
-(void)_pushmsg:(NSDictionary*)data method:(NSString*)method{
    
    if ([self _duplicatedPushMsgFilter:method data:data] == NO) {
        int mtype = [[data objectForKey:@"mtype"] intValue];
        
        if (mtype == 30) {
            //chat 文字
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushP2PChatMessage:message:)]) {
                [self.delegate rtmPushP2PChatMessage:self message:msgModel];
            }
            
        }else if(mtype == 31){
            //语音
            RTMMessage * msgModel = [RTMMessageModelConvert audioModelConvert:data chatType:RTMP2p];
             if ([self.delegate respondsToSelector:@selector(rtmPushP2PChatAudio:message:)]) {
                [self.delegate rtmPushP2PChatAudio:self message:msgModel];
             }
        }else if(mtype == 32){
            //chat cmd
            RTMMessage * msgModel = [RTMMessageModelConvert cmdModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushP2PChatCmd:message:)]) {
                [self.delegate rtmPushP2PChatCmd:self message:msgModel];
            }
        }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
            //文件
            RTMMessage * msgModel = [RTMMessageModelConvert fileModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushP2PFile:message:)]) {
                [self.delegate rtmPushP2PFile:self message:msgModel];
            }
        }else if(mtype >= 51 && mtype <= 127){
            
            //normal message
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            
            if([self.delegate respondsToSelector:@selector(rtmPushP2PBinary:message:)] && msgModel.binaryMessage != nil){
                                                    
                [self.delegate rtmPushP2PBinary:self message:msgModel];
                                                    
            }else if ([self.delegate respondsToSelector:@selector(rtmPushP2PMessage:message:)] && msgModel.stringMessage != nil) {
                
                [self.delegate rtmPushP2PMessage:self message:msgModel];
                                                    
            }
            
        }
    }
                                              
}
#pragma mark  group
-(void)_pushgroupmsg:(NSDictionary*)data method:(NSString*)method{
    
    if ([self _duplicatedPushMsgFilter:method data:data] == NO) {
        int mtype = [[data objectForKey:@"mtype"] intValue];
        
        if (mtype == 30) {
            //chat 文字
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushGroupChatMessage:message:)]) {
                [self.delegate rtmPushGroupChatMessage:self message:msgModel];
            }
            
        }else if(mtype == 31){
            //语音
            RTMMessage * msgModel = [RTMMessageModelConvert audioModelConvert:data chatType:RTMP2p];
             if ([self.delegate respondsToSelector:@selector(rtmPushGroupChatAudio:message:)]) {
                [self.delegate rtmPushGroupChatAudio:self message:msgModel];
             }
        }else if(mtype == 32){
            //chat cmd
            RTMMessage * msgModel = [RTMMessageModelConvert cmdModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushGroupChatCmd:message:)]) {
                [self.delegate rtmPushGroupChatCmd:self message:msgModel];
            }
        }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
            //文件
            RTMMessage * msgModel = [RTMMessageModelConvert fileModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushGroupFile:message:)]) {
                [self.delegate rtmPushGroupFile:self message:msgModel];
            }
        }else{
            
            //normal message
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            
            if([self.delegate respondsToSelector:@selector(rtmPushGroupBinary:message:)] && msgModel.binaryMessage != nil){
                                                    
                [self.delegate rtmPushGroupBinary:self message:msgModel];
                                                    
            }else if ([self.delegate respondsToSelector:@selector(rtmPushGroupMessage:message:)] && msgModel.stringMessage != nil) {
                
                [self.delegate rtmPushGroupMessage:self message:msgModel];
                                                    
            }
            
        }
    }
}
#pragma mark  room
-(void)_pushroommsg:(NSDictionary*)data method:(NSString*)method{
    if ([self _duplicatedPushMsgFilter:method data:data] == NO) {
        int mtype = [[data objectForKey:@"mtype"] intValue];
        
        if (mtype == 30) {
            //chat 文字
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushRoomChatMessage:message:)]) {
                [self.delegate rtmPushRoomChatMessage:self message:msgModel];
            }
            
        }else if(mtype == 31){
            //语音
            RTMMessage * msgModel = [RTMMessageModelConvert audioModelConvert:data chatType:RTMP2p];
             if ([self.delegate respondsToSelector:@selector(rtmPushRoomChatAudio:message:)]) {
                [self.delegate rtmPushRoomChatAudio:self message:msgModel];
             }
        }else if(mtype == 32){
            //chat cmd
            RTMMessage * msgModel = [RTMMessageModelConvert cmdModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushRoomChatCmd:message:)]) {
                [self.delegate rtmPushRoomChatCmd:self message:msgModel];
            }
        }else if(mtype == 40 || mtype == 41 || mtype == 42 || mtype == 50){
            //文件
            RTMMessage * msgModel = [RTMMessageModelConvert fileModelConvert:data chatType:RTMP2p];
            if ([self.delegate respondsToSelector:@selector(rtmPushRoomFile:message:)]) {
                [self.delegate rtmPushRoomFile:self message:msgModel];
            }
        }else{
            
            //normal message
            RTMMessage * msgModel = [RTMMessageModelConvert messageModelConvert:data chatType:RTMP2p];
            
            if([self.delegate respondsToSelector:@selector(rtmPushRoomBinary:message:)] && msgModel.binaryMessage != nil){
                                                    
                [self.delegate rtmPushRoomBinary:self message:msgModel];
                                                    
            }else if ([self.delegate respondsToSelector:@selector(rtmPushRoomMessage:message:)] && msgModel.stringMessage != nil) {
                
                [self.delegate rtmPushRoomMessage:self message:msgModel];
                                                    
            }
            
        }
    }
}
#pragma mark  broadcast
-(void)_pushbroadcastmsg:(NSDictionary*)data method:(NSString*)method{
   
}
#pragma mark duplicate msg
-(BOOL)_duplicatedPushMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@",self.projectId,self.userId,method,[data objectForKey:@"mid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
}
-(BOOL)_duplicatedPushGroupMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@-%@",self.projectId,self.userId,method,[data objectForKey:@"mid"],[data objectForKey:@"gid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
}
-(BOOL)_duplicatedPushRoomMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@-%@",self.projectId,self.userId,method,[data objectForKey:@"mid"],[data objectForKey:@"rid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
}
-(BOOL)_duplicatedPushBroadcastMsgFilter:(NSString*)method data:(NSDictionary*)data {
    if ([data objectForKey:@"mid"] == nil) {
        return NO;
    }
    NSString * msgCacheKey = [NSString stringWithFormat:@"%d-%lld-%@-%@-%@",self.projectId,self.userId,method,[data objectForKey:@"mid"],[data objectForKey:@"from"]];
    return [self _isExistMessage:msgCacheKey];
}
-(BOOL)_isExistMessage:(NSString*)msgCacheKey{
    @synchronized (self) {
        if (self.messageDuplicatedCache != nil && [self.messageDuplicatedCache objectForKey:msgCacheKey] == nil) {
            [self.messageDuplicatedCache setObject:@(YES) forKey:msgCacheKey];
            return NO;
        }else{
            return YES;
        }
    }
}
-(void)setMessageDuplicatedCache:(NSCache *)messageDuplicatedCache{
    objc_setAssociatedObject(self, "messageDuplicatedCache", messageDuplicatedCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSCache*)messageDuplicatedCache{
    return objc_getAssociatedObject(self, "messageDuplicatedCache");
}
@end