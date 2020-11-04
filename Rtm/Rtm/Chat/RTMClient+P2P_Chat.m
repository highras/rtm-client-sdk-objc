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
#import "RTMClient+FileToken.h"
#import "RTMIPv6Adapter.h"

@implementation RTMClient (P2P_Chat)
-(void)sendP2PMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(RTMSendAnswer* sendAnswer))successCallback
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
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
    }else{
        model.error = answer.error;
    }
    
    return model;
    
    
}




-(void)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                        audioModel:(RTMAudioModel * _Nonnull)audioModel
                            attrs:(NSDictionary * _Nullable)attrs
                          timeout:(int)timeout
                          success:(void(^)(RTMSendAnswer* sendAnswer))successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    if ([attrs objectForKey:@"rtm"] != nil) {
        FPNSLog(@"rtm sendAudioMessageChatWithId error. sendAudioMessageChatWithId attrs exist rtm key");
        return;
    }
    
    clientConnectStatueVerify
    
    NSString * audioFilePath = audioModel.audioFilePath;
    int duration = audioModel.duration;
    NSString * lang = audioModel.lang;
    
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm P2P audioMessage duration or audioFile is nil");
        return ;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm P2P audioMessage get audioData error");
        return ;
    }
    
    
    if ([RTMAudioTools isAmrVerify:audioData] == NO) {
        FPNSLog(@"rtm P2P sendAudioMessageChatWithId no amr type");
        return ;
    }
    
    [self getP2PFileTokenWithId:userId
                        timeout:RTMClientFileQuestTimeout
                        success:^(NSDictionary * _Nullable data) {
        
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getP2PFileTokenWithId return data is nil");
            return ;
        }
        NSDictionary * resultBody = [self getAudioFileQuestBody:data
                                                         recvId:userId
                                                       fileData:audioData
                                                           lang:lang
                                                       duration:duration
                                                          attrs:attrs];
                                                      
        [resultBody setValue:userId forKey:@"to"];

        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendfile" message:resultBody twoWay:YES];
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
    
    
    
    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userId forKey:@"to"];
//    [dic setValue:mid forKey:@"mid"];
//    [dic setValue:@(31) forKey:@"mtype"];
////    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
////    if (resultData) {
//        [dic setValue:audioData forKey:@"msg"];
////    }else{
////        FPNSLog(@"rtm P2P audioDataAddHeader error");
////        return ;
////    }
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
        
//    handlerNetworkError;
    
}
-(RTMSendAnswer*)sendAudioMessageChatWithId:(NSNumber * _Nonnull)userId
                                 audioModel:(RTMAudioModel * _Nonnull)audioModel
                                      attrs:(NSDictionary * _Nullable)attrs
                                    timeout:(int)timeout{
    
    if ([attrs objectForKey:@"rtm"] != nil) {
        FPNSLog(@"rtm sendAudioMessageChatWithId error. sendAudioMessageChatWithId attrs exist rtm key");
        return nil;
    }
    
    RTMSendAnswer * model = [RTMSendAnswer new];
    clientConnectStatueVerifySync
    
    NSString * audioFilePath = audioModel.audioFilePath;
    int duration = audioModel.duration;
    NSString * lang = audioModel.lang;
    
    if (duration == 0 || audioFilePath == nil) {
        FPNSLog(@"rtm P2P audioMessage duration or audioFile is nil");
        return nil;
    }
    
    NSData * audioData = [NSData dataWithContentsOfFile:audioFilePath];
    if (audioData == nil) {
        FPNSLog(@"rtm P2P audioMessage get audioData error");
        return nil;
    }
    
    if ([RTMAudioTools isAmrVerify:audioData] == NO) {
        FPNSLog(@"rtm P2P sendAudioMessageChatWithId no amr type");
        return nil;
    }
    
    FPNNAnswer * answer = [self getP2PFileTokenWithId:userId timeout:RTMClientFileQuestTimeout];
    if (answer.error == nil) {
        
        NSDictionary * data = answer.responseData;
        if (RTMNullString(data[@"endpoint"]) || RTMNullString(data[@"token"])) {
            FPNSLog(@"rtm sendFile error. getP2PFileTokenWithId return data is nil");
            return nil;
        }
        NSDictionary * resultBody = [self getAudioFileQuestBody:data
                                                         recvId:userId
                                                       fileData:audioData
                                                           lang:lang
                                                       duration:duration
                                                          attrs:attrs];
        [resultBody setValue:userId forKey:@"to"];
        
        NSString * endPoint = data[@"endpoint"];
        if ([[RTMIPv6Adapter getInstance] isIPv6OnlyNetwork]) {
            endPoint = [[RTMIPv6Adapter getInstance] handleIpv4Address:endPoint];
        }
        FPNNTCPClient * fileClient = [self getFileClient:endPoint];
        FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendfile" message:resultBody twoWay:YES];
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
                               

                               
    
    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:userId forKey:@"to"];
//    [dic setValue:mid forKey:@"mid"];
//    [dic setValue:@(31) forKey:@"mtype"];
//    NSData * resultData = [RTMAudioTools audioDataAddHeader:audioData lang:lang time:duration srate:16000];
//    if (resultData) {
//        [dic setValue:resultData forKey:@"msg"];
//    }else{
//        FPNSLog(@"rtm P2P audioDataAddHeader error");
////        return ;
//    }
//
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
//    FPNNAnswer * answer = [mainClient sendQuest:quest
//                                       timeout:RTMClientSendQuestTimeout];
//
//    if (answer.error == nil) {
//        model.mtime = [[answer.responseData objectForKey:@"mtime"] longLongValue];
//        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
//    }else{
//        model.error = answer.error;
//    }
//
//    return model;
}




-(void)sendCmdMessageChatWithId:(NSNumber * _Nonnull)userId
                        message:(NSString * _Nonnull)message
                          attrs:(NSString * _Nonnull)attrs
                        timeout:(int)timeout
                        success:(void(^)(RTMSendAnswer* sendAnswer))successCallback
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
        model.messageId = [[dic objectForKey:@"mid"] longLongValue];
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
    [dic setValue:@[@(30),@(32),@(40),@(41),@(42),@(50)] forKey:@"mtypes"];
    
    
    
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
//        NSLog(@"%@",data);
        NSArray * array = [data objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray toUserId:userId.longLongValue myUserId:self.userId];
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
    [dic setValue:@[@(30),@(32),@(40),@(41),@(42),@(50)] forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    FPNNAnswer * answer = [mainClient sendQuest:quest
                                       timeout:RTMClientSendQuestTimeout];
    
    if (answer.error == nil) {
        
//        NSLog(@"----%@",answer.responseData);
        NSArray * array = [answer.responseData objectForKey:@"msgs"];
        NSMutableArray * resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull itemArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RTMHistoryMessage * msgOb = [RTMMessageModelConvert p2pHistoryMessageModelConvert:itemArray toUserId:userId.longLongValue myUserId:self.userId];
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
