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
#import "RTMMessageModelConvert.h"
#import "RTMClient+FileToken.h"
#import "RTMIPv6Adapter.h"
@implementation RTMClient (Room_Chat)
-(void)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                           message:(NSString * _Nonnull)message
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                        success:(void(^)(RTMSendAnswer* sendAnswer))successCallback
                            fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
            sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
            sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
            successCallback(sendAnswer);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendRoomMessageChatWithId:(NSNumber * _Nonnull)roomId
                                   message:(NSString * _Nonnull)message
                                     attrs:(NSString * _Nonnull)attrs
                                   timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(30) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
}




-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                                  audioModel:(RTMAudioModel * _Nonnull)audioModel
                                        attrs:(NSDictionary * _Nullable)attrs
                                     timeout:(int)timeout
                                     success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                                        fail:(RTMAnswerFailCallBack)failCallback{
    
    clientConnectStatueVerify
    
    NSString * audioFilePath = audioModel.audioFilePath;
    int duration = audioModel.duration;
    NSString * lang = audioModel.lang;
    
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm Room audioMessage duration or audioFile is nil");
        return ;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm Room audioMessage get audioData error");
        return ;
    }
    
    
    if ([RTMAudioTools isAmrVerify:audioData] == NO) {
        FPNSLog(@"rtm Room sendAudioMessageChatWithId no amr type");
        return ;
    }
    
    [self getRoomFileTokenWithId:roomId
                          timeout:RTMClientFileQuestTimeout
                          success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getGroupFileTokenWithId return data is nil");
            return ;
        }
        NSDictionary * resultBody = [self getAudioFileQuestBody:data
                                                         recvId:roomId
                                                       fileData:audioData
                                                           lang:lang
                                                       duration:duration
                                                          attrs:attrs];
        [resultBody setValue:roomId forKey:@"rid"];
        

        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroomfile" message:resultBody twoWay:YES];
        BOOL result = [fileClient sendQuest:quest
                                    timeout:RTMClientSendQuestTimeout
                                    success:^(NSDictionary * _Nullable data) {

            
            if (successCallback) {

                RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
                sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
                sendAnswer.messageId = [[resultBody objectForKey:@"mid"] longLongValue];
                successCallback(sendAnswer);
            }

        } fail:^(FPNError * _Nullable error) {
            _failCallback(error);

        }];


        handlerNetworkError

        
        
        
    } fail:^(FPNError * _Nullable error) {

        _failCallback(error);

    }];
//    clientConnectStatueVerify
//    if (duration == 0 || audioFilePath == nil) {
//        FPNSLog(@"rtm room audioMessage duration or audioFile is nil");
//        return ;
//    }
//    
//    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
//    if (audioData == nil) {
//        FPNSLog(@"rtm room audioMessage get audioData error");
//        return ;
//    }
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:roomId forKey:@"rid"];
//    [dic setValue:mid forKey:@"mid"];
//    [dic setValue:@(31) forKey:@"mtype"];
////    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
////    if (resultData) {
//        [dic setValue:audioData forKey:@"msg"];
////    }else{
////        FPNSLog(@"rtm room audioDataAddHeader error");
////        return ;
////    }
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
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
//    BOOL result = [fpnnMainClient sendQuest:quest
//                                timeout:RTMClientSendQuestTimeout
//                                success:^(NSDictionary * _Nullable data) {
//        
//        if (successCallback) {
//            RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
//            sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
//            sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
//            successCallback(sendAnswer);
//        }
//    
//    }fail:^(FPNError * _Nullable error) {
//        
//          _failCallback(error);
//
//    }];
//        
//    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
                                     audioModel:(RTMAudioModel * _Nonnull)audioModel
                                          attrs:(NSDictionary * _Nullable)attrs
                                        timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSString * audioFilePath = audioModel.audioFilePath;
    int duration = audioModel.duration;
    NSString * lang = audioModel.lang;
    
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm Room audioMessage duration or audioFile is nil");
        return nil;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm Room audioMessage get audioData error");
        return nil;
    }
    
    if ([RTMAudioTools isAmrVerify:audioData] == NO) {
        FPNSLog(@"rtm Room sendAudioMessageChatWithId no amr type");
        return nil;
    }
    
    FPNNAnswer * answer = [self getRoomFileTokenWithId:roomId timeout:RTMClientFileQuestTimeout];
    if (answer.error == nil) {
        
        NSDictionary * data = answer.responseData;
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getRoomFileTokenWithId return data is nil");
            return nil;
        }
        NSDictionary * resultBody = [self getAudioFileQuestBody:data
                                                         recvId:roomId
                                                       fileData:audioData
                                                           lang:lang
                                                       duration:duration
                                                          attrs:attrs];
        [resultBody setValue:roomId forKey:@"rid"];
        
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroomfile" message:resultBody twoWay:YES];
        FPNNAnswer * answer = [fileClient sendQuest:quest timeout:RTMClientSendQuestTimeout];
        if (answer.error == nil) {
            model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
            model.messageId = [[resultBody objectForKey:@"mid"] longLongValue];
        }else{
            model.error = answer.error;
        }
        
        
    }else{
       
        model.error = answer.error;
        
    }

           
    
    return model;
    
//    RTMSendAnswer * model = [RTMSendAnswer new];
//                clientConnectStatueVerifySync
//                
//                
//                if (duration == 0 || audioFilePath == nil) {
//            //        FPNSLog(@"rtm P2P audioMessage duration or audioFile is nil");
//            //        return ;
//                }
//                
//                
//                NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
//                if (audioData == nil) {
//            //        FPNSLog(@"rtm P2P audioMessage get audioData error");
//            //        return ;
//                }
//                
//                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//                [dic setValue:roomId forKey:@"rid"];
//                [dic setValue:mid forKey:@"mid"];
//                [dic setValue:@(31) forKey:@"mtype"];
//                NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
//                if (resultData) {
//                    [dic setValue:resultData forKey:@"msg"];
//                }else{
//                    FPNSLog(@"rtm room audioDataAddHeader error");
//    //                return ;
//                }
//                
//                NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
//                if (attrsDic == nil) {
//                    attrsDic = [NSMutableDictionary dictionary];
//                }
//                [attrsDic setValue:@(duration) forKey:@"duration"];
//                [attrsDic setValue:lang forKey:@"lang"];
//                NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
//                [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
//                
//                FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
//                
//                FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
//                                                   timeout:RTMClientSendQuestTimeout];
//                
//                if (answer.error == nil) {
//                    model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
//                    model.messageId = [[dic objectForKey:@"mid"] longLongValue];
//                }else{
//                    model.error = answer.error;
//                }
//                
//                return model;
//    
}






//-(void)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
//                            audioData:(NSData * _Nonnull)audioData
//                                attrs:(NSDictionary * )attrs
//                                 lang:(NSString * _Nonnull)lang
//                             duration:(long long)duration
//                              timeout:(int)timeout
//                              success:(void(^)(int64_t mtime))successCallback
//                                 fail:(RTMAnswerFailCallBack)failCallback{
//    
//    
//    clientConnectStatueVerify
//    if (duration == 0 || audioData == nil) {
//        FPNSLog(@"rtm room audioMessage duration or audioData is nil");
//        return ;
//    }
//    
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:roomId forKey:@"rid"];
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
//    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
//    if (attrsDic == nil) {
//        attrsDic = [NSMutableDictionary dictionary];
//    }
//    [attrsDic setValue:@(duration) forKey:@"duration"];
//    [attrsDic setValue:lang forKey:@"lang"];
//    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
//    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
//    BOOL result = [fpnnMainClient sendQuest:quest
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
//-(RTMAnswer*)sendRoomAudioMessageChatWithId:(NSNumber * _Nonnull)roomId
//                                  audioData:(NSData * _Nonnull)audioData
//                                       attrs:(NSDictionary * )attrs
//                                        lang:(NSString * _Nonnull)lang
//                                    duration:(long long)duration
//                                    timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    if (duration == 0 || audioData == nil) {
//        FPNSLog(@"rtm room audioMessage duration or audioData is nil");
//        return nil;
//    }
//    
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:roomId forKey:@"rid"];
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
//    NSMutableDictionary * attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
//    if (attrsDic == nil) {
//        attrsDic = [NSMutableDictionary dictionary];
//    }
//    [attrsDic setValue:@(duration) forKey:@"duration"];
//    [attrsDic setValue:lang forKey:@"lang"];
//    NSData * strData = [NSJSONSerialization dataWithJSONObject:attrsDic options:NSJSONWritingPrettyPrinted error:nil];
//    [dic setValue:[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] forKey:@"attrs"];
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
//    
//    return  handlerResult(quest,timeout);
//    
//}
//
//
//
-(void)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                           message:(NSString * _Nonnull)message
                             attrs:(NSString * _Nonnull)attrs
                           timeout:(int)timeout
                            success:(void(^)(RTMSendAnswer* sendAnswer))successCallback
                               fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientConnectStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
        
        if (successCallback) {
            RTMSendAnswer* sendAnswer  = [RTMSendAnswer new];
            sendAnswer.mtime = [[data objectForKey:@"mtime"] longLongValue];
            sendAnswer.messageId = [[dic objectForKey:@"mid"] longLongValue];
            successCallback(sendAnswer);
        }
    
    }fail:^(FPNError * _Nullable error) {
        
          _failCallback(error);

    }];
        
    handlerNetworkError;
    
}
-(RTMBaseAnswer*)sendRoomCmdMessageChatWithId:(NSNumber * _Nonnull)roomId
                                      message:(NSString * _Nonnull)message
                                        attrs:(NSString * _Nonnull)attrs
                                      timeout:(int)timeout{
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:@(32) forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];

    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendroommsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
}





-(void)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
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
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    
//    BOOL result = [fpnnMainClient sendQuest:quest
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
    
    BOOL result = [fpnnMainClient sendQuest:quest
                                timeout:RTMClientSendQuestTimeout
                                success:^(NSDictionary * _Nullable data) {
//        NSLog(@"%@",data);
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert roomHistoryMessageModelConvert:itemArray];
            if (msgOb != nil) {
                [resultArray addObject:msgOb];
            }
            
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
-(RTMHistoryMessageAnswer*)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
                                                          desc:(BOOL)desc
                                                           num:(NSNumber * _Nonnull)num
                                                         begin:(NSNumber * _Nullable)begin
                                                           end:(NSNumber * _Nullable)end
                                                        lastid:(NSNumber * _Nullable)lastid
                                                       timeout:(int)timeout{
    
    RTMHistoryMessageAnswer * model = [RTMHistoryMessageAnswer new];
    clientConnectStatueVerifySync
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:roomId forKey:@"rid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [fpnnMainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
//
//        NSLog(@"%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert roomHistoryMessageModelConvert:itemArray ];
            if (msgOb != nil) {
                [resultArray addObject:msgOb];
            }
            
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
//-(RTMAnswer*)getRoomHistoryMessageChatWithRoomId:(NSNumber * _Nonnull)roomId
//                                              desc:(BOOL)desc
//                                               num:(NSNumber * _Nonnull)num
//                                             begin:(NSNumber * _Nullable)begin
//                                               end:(NSNumber * _Nullable)end
//                                            lastid:(NSNumber * _Nullable)lastid
//                                         timeout:(int)timeout{
//    
//    
//    clientStatueVerify
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:roomId forKey:@"rid"];
//    [dic setValue:@(desc) forKey:@"desc"];
//    [dic setValue:num forKey:@"num"];
//    [dic setValue:begin forKey:@"begin"];
//    [dic setValue:end forKey:@"end"];
//    [dic setValue:lastid forKey:@"lastid"];
//    [dic setValue:@[@(30),@(31),@(32),@(40),@(41),@(42)] forKey:@"mtypes"];
//    
//    
//    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getroommsg" message:dic twoWay:YES];
//    
////    RTMAnswer * answer = (RTMAnswer*)[fpnnMainClient sendQuest:quest timeout:(timeout <= 0 ? self.sendQuestTimeout : timeout)];
////    if (answer.error == nil && answer.responseData != nil) {
////        
////        NSDictionary * data = answer.responseData;
////        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:(NSArray*)[data objectForKey:@"msgs"]];
////        [msgArray enumerateObjectsUsingBlock:^(NSArray *  itemArray,  NSUInteger idx, BOOL * _Nonnull stop) {
////            int mType = [[itemArray objectAtIndex:2] intValue];
////            if (mType == 31) {//音频的要去头再返回
////                NSData * msg = [itemArray objectAtIndex:5];
////                NSData * noHeaderData = [RTMAudioTools audioDataRemoveHeader:msg];
////                NSMutableArray * noHeaderItemArray = [NSMutableArray arrayWithArray:itemArray];
////                [noHeaderItemArray replaceObjectAtIndex:5 withObject:noHeaderData];
////                [msgArray replaceObjectAtIndex:idx withObject:noHeaderItemArray];
////            }
////        }];
////        NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:data];
////        [newData setValue:msgArray forKey:@"msgs"];
////        answer.responseData = newData;
////    }
////    return  answer;
//    return  handlerResult(quest,timeout);
//}
@end
