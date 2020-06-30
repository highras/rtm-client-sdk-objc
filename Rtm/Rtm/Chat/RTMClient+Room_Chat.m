//
//  RTMClient+Room_Chat.m
//  Rtm
//
//  Created by zsl on 2019/12/24.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Room_Chat.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAnswer.h"
#import "RTMAudioTools.h"

@implementation RTMClient (Room_Chat)
-(void)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                           message:(NSString * _Nonnull)message
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                               tag:(id)tag
                           success:(RTMAnswerSuccessCallBack)successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                                 message:(NSString * _Nonnull)message
                                   attrs:(NSString * _Nonnull)attrs
                               timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}


-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                        audioFilePath:(NSString * _Nonnull)audioFilePath
                                attrs:(NSDictionary * )attrs
                                 lang:(NSString * _Nonnull)lang
                             duration:(long long)duration
                              timeout:(int)timeout
                                  tag:(id)tag
                              success:(RTMAnswerSuccessCallBack)successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm room audioMessage duration or audioFile is nil");
        return ;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm P2P audioMessage get audioData error");
        return ;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(31) forKey:@"mtype"];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
    if (resultData) {
        [dic setValue:resultData forKey:@"msg"];
    }else{
        FPNSLog(@"rtm P2P audioDataAddHeader error");
        return ;
    }
    
    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setValue:@(duration) forKey:@"duration"];
    [attrsDic setValue:lang forKey:@"lang"];
    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                              audioFilePath:(NSString * _Nonnull)audioFilePath
                                       attrs:(NSDictionary * )attrs
                                        lang:(NSString * _Nonnull)lang
                                    duration:(long long)duration
                                    timeout:(int)timeout{
    
    
    clientStatueVerify
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm room audioMessage duration or audioFile is nil");
        return nil;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm P2P audioMessage get audioData error");
        return nil;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(31) forKey:@"mtype"];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
    if (resultData) {
        [dic setValue:resultData forKey:@"msg"];
    }else{
        FPNSLog(@"rtm P2P audioDataAddHeader error");
        return nil;
    }
    
    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setValue:@(duration) forKey:@"duration"];
    [attrsDic setValue:lang forKey:@"lang"];
    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}


-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                            audioData:(NSData * _Nonnull)audioData
                                attrs:(NSDictionary * )attrs
                                 lang:(NSString * _Nonnull)lang
                             duration:(long long)duration
                              timeout:(int)timeout
                                  tag:(id)tag
                              success:(RTMAnswerSuccessCallBack)successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    if (duration == 0 || audioData == nil) {
        FPNSLog(@"rtm room audioMessage duration or audioData is nil");
        return ;
    }
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(31) forKey:@"mtype"];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
    if (resultData) {
        [dic setValue:resultData forKey:@"msg"];
    }else{
        FPNSLog(@"rtm P2P audioDataAddHeader error");
        return ;
    }
    
    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setValue:@(duration) forKey:@"duration"];
    [attrsDic setValue:lang forKey:@"lang"];
    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                                  audioData:(NSData * _Nonnull)audioData
                                       attrs:(NSDictionary * )attrs
                                        lang:(NSString * _Nonnull)lang
                                    duration:(long long)duration
                                    timeout:(int)timeout{
    
    
    clientStatueVerify
    if (duration == 0 || audioData == nil) {
        FPNSLog(@"rtm room audioMessage duration or audioData is nil");
        return nil;
    }
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(31) forKey:@"mtype"];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
    if (resultData) {
        [dic setValue:resultData forKey:@"msg"];
    }else{
        FPNSLog(@"rtm P2P audioDataAddHeader error");
        return nil;
    }
    
    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setValue:@(duration) forKey:@"duration"];
    [attrsDic setValue:lang forKey:@"lang"];
    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



-(void)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                           message:(NSString * _Nonnull)message
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                               tag:(id)tag
                           success:(RTMAnswerSuccessCallBack)successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                                 message:(NSString * _Nonnull)message
                                   attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}


-(void)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
                                        desc:(BOOL)desc
                                         num:(NSNumber * _Nonnull)num
                                       begin:(NSNumber * _Nullable)begin
                                         end:(NSNumber * _Nullable)end
                                      lastid:(NSNumber * _Nullable)lastid
                                     timeout:(int)timeout
                                         tag:(id)tag
                                     success:(RTMAnswerSuccessCallBack)successCallback
                                      fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    
    BOOL result = [mainClient sendQuest:quest
                                timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)
                                success:^(NSDictionary * _Nullable data) {

        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
            int mType = [[itemArray objectAtIndex:2] intValue];
            if (mType == 31) {//音频的要去头再返回
                NSData * msg = [itemArray objectAtIndex:5];
                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
            }
        }];
        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
        [newData setValue:msgArray forKey:@"msgs"];
        _successCallback(newData,tag);
        
    }
                                   fail:^(FPNError * _Nullable error) {
        _failCallback(error,tag);
        
    }];
    
    handlerResultFail;
    
}
-(RTMAnswer*)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
                                              desc:(BOOL)desc
                                               num:(NSNumber * _Nonnull)num
                                             begin:(NSNumber * _Nullable)begin
                                               end:(NSNumber * _Nullable)end
                                            lastid:(NSNumber * _Nullable)lastid
                                         timeout:(int)timeout{
    
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    
    RTMAnswer * answer = (RTMAnswer*)[mainClient sendQuest:quest timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)];
    if (answer.error == nil && answer.responseData != nil) {
        
        NSDictionary * data = answer.responseData;
        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
            int mType = [[itemArray objectAtIndex:2] intValue];
            if (mType == 31) {//音频的要去头再返回
                NSData * msg = [itemArray objectAtIndex:5];
                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
            }
        }];
        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
        [newData setValue:msgArray forKey:@"msgs"];
        answer.responseData = newData;
    }
    return  answer;
    
}
@end

