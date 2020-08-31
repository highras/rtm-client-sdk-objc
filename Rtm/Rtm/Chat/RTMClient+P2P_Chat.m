//
//  RTMClient+PtoP_Chat.m
//  Rtm
//
//  Created by zsl on 2019/12/24.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+P2P_Chat.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAnswer.h"
#import "RTMAudioTools.h"
#import <Foundation/Foundation.h>
#import "RTMMessageModelConvert.h"
@implementation RTMClient (P2P_Chat)
-(void)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(int64_t mtime))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{

    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback([[data objectForKey:@"mtime"] longLongValue]);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;

}
-(RTMSendAnswer*)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout{
    
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}




-(void)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                    audioFilePath:(NSString * _Nonnull)audioFilePath
                            attrs:(NSDictionary * )attrs
                             lang:(NSString * _Nonnull)lang
                         duration:(long long)duration
                          timeout:(int)timeout
                          success:(void(^)(int64_t mtime))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm P2P audioMessage duration or audioFile is nil");
        return ;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm P2P audioMessage get audioData error");
        return ;
    }
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
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
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback([[data objectForKey:@"mtime"] longLongValue]);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                              audioFilePath:(NSString * _Nonnull)audioFilePath
                                      attrs:(NSDictionary * _Nullable)attrs
                                       lang:(NSString * _Nonnull)lang
                                   duration:(long long)duration
                                    timeout:(int)timeout{
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    
    if (duration == 0 || audioFilePath == nil) {
//        FPNSLog(@"rtm P2P audioMessage duration or audioFile is nil");
//        return ;
    }
    
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
//        FPNSLog(@"rtm P2P audioMessage get audioData error");
//        return ;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(31) forKey:@"mtype"];
    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
    if (resultData) {
        [dic setValue:resultData forKey:@"msg"];
    }else{
        FPNSLog(@"rtm P2P audioDataAddHeader error");
//        return ;
    }
    
    
    
    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setValue:@(duration) forKey:@"duration"];
    [attrsDic setValue:lang forKey:@"lang"];
    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
}



//-(void)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
//                        audioData:(NSData * _Nonnull)audioData
//                            attrs:(NSDictionary * )attrs
//                             lang:(NSString * _Nonnull)lang
//                         duration:(long long)duration
//                          timeout:(int)timeout
//                          success:(void(^)(int64_t mtime))successCallback
//                             fail:(RTMAnswerFailCallBack)failCallback{
//
//
//    clientConnectStatueVerify
//    if (duration == 0 || audioData == nil) {
//        FPNSLog(@"rtm P2P audioMessage duration or audioData is nil");
//        return ;
//    }
//
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userId forKey:@"to"];
//    [dic setValue:mid forKey:@"mid"];
//    [dic setValue:@(31) forKey:@"mtype"];
//    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
//    if (resultData) {
//        [dic setValue:resultData forKey:@"msg"];
//    }else{
//        FPNSLog(@"rtm P2P audioDataAddHeader error");
//        return ;
//    }
//
//
//    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
//    if (attrsDic == nil) {
//        attrsDic = [NSMutableDictionary dictionary];
//    }
//    [attrsDic setValue:@(duration) forKey:@"duration"];
//    [attrsDic setValue:lang forKey:@"lang"];
//    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
//    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
//
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
//
//    BOOL result = [mainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//
//        if (successCallback) {
//            successCallback([[data objectForKey:@"mtime"] longLongValue]);
//        }
//
//    }fail:^(FPNError * _Nullable error) {
//
//          _failCallback(error);
//
//    }];
//
//    handlerNetworkError;
//
//}
//-(RTMAnswer*)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
//                              audioData:(NSData * _Nonnull)audioData
//                                  attrs:(NSDictionary * )attrs
//                                   lang:(NSString * _Nonnull)lang
//                               duration:(long long)duration
//                                timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    if (duration == 0 || audioData == nil) {
//        FPNSLog(@"rtm P2P audioMessage duration or audioData is nil");
//        return nil;
//    }
//    
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userId forKey:@"to"];
//    [dic setValue:mid forKey:@"mid"];
//    [dic setValue:@(31) forKey:@"mtype"];
//    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
//    if (resultData) {
//        [dic setValue:resultData forKey:@"msg"];
//    }else{
//        FPNSLog(@"rtm P2P audioDataAddHeader error");
//        return nil;
//    }
//    
//    
//    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
//    if (attrsDic == nil) {
//        attrsDic = [NSMutableDictionary dictionary];
//    }
//    [attrsDic setValue:@(duration) forKey:@"duration"];
//    [attrsDic setValue:lang forKey:@"lang"];
//    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
//    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
//    
//    return  handlerResult(quest,timeout);
//    
//}
//
-(void)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(int64_t mtime))successCallback
                           fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            successCallback([[data objectForKey:@"mtime"] longLongValue]);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                                  message:(NSString * _Nonnull)message
                                    attrs:(NSString * _Nonnull)attrs
                                  timeout:(int)timeout{
    
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}






-(void)getP2PHistoryMessageChatWithUserId:(NSNumber * _Nonnull)userId
                                     desc:(BOOL)desc
                                      num:(NSNumber * _Nonnull)num
                                    begin:(NSNumber * _Nullable)begin
                                      end:(NSNumber * _Nullable)end
                                   lastid:(NSNumber * _Nullable)lastid
                                  timeout:(int)timeout
                                  success:(void(^)(RTMHistory* _Nullable history))successCallback
                                     fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    
    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    
//    BOOL result = handlerCallResult(quest,timeout,tag);
    
//    BOOL result = [mainClient sendQuest:quest
//                                timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)
//                                success:^(NSDictionary * _Nullable data) {
//
//        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
//        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
//            int mType = [[itemArray objectAtIndex:2] intValue];
//            if (mType == 31) {//音频的要去头再返回
//                NSData * msg = [itemArray objectAtIndex:5];
//                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
//                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
//                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
//                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
//            }
//        }];
//        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
//        [newData setValue:msgArray forKey:@"msgs"];
//        _successCallback(newData,tag);
//
//    }
//                                   fail:^(FPNError * _Nullable error) {
//        _failCallback(error,tag);
//
//    }];
//
//    handlerResultFail;
    
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    BOOL result = [mainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
    
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray];
            [resultArray addObject:msgOb];
            
        }];
        
        if (successCallback) {

            RTMHistory * history = [RTMHistory new];
            history.begin = [[data objectForKey:@"begin"] longLongValue];
            history.end = [[data objectForKey:@"end"] longLongValue];
            history.lastid = [[data objectForKey:@"lastid"] longLongValue];
            history.messageArray = resultArray;
            
            successCallback(history);
        }
        

        }fail:^(FPNError * _Nullable error) {
    
            _failCallback(error);

        }];
    
    handlerNetworkError;
    
}
-(RTMHistoryMessageAnswer*)getP2PHistoryMessageChatWithUserId:(NSNumber * _Nonnull)userId
                                                         desc:(BOOL)desc
                                                          num:(NSNumber * _Nonnull)num
                                                        begin:(NSNumber * _Nullable)begin
                                                          end:(NSNumber * _Nullable)end
                                                       lastid:(NSNumber * _Nullable)lastid
                                                      timeout:(int)timeout{
    
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray];
            [resultArray addObject:msgOb];
            
        }];
        
        RTMHistory * history = [RTMHistory new];
        history.begin = [[answer.responseData objectForKey:@"begin"] longLongValue];
        history.end = [[answer.responseData objectForKey:@"end"] longLongValue];
        history.lastid = [[answer.responseData objectForKey:@"lastid"] longLongValue];
        history.messageArray = resultArray;
        model.history = history;
        
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}

@end
