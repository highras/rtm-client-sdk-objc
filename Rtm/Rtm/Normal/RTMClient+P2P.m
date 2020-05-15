//
//  RTMClient+PtoP.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+P2P.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"
#import "RTMAnswer.h"

@implementation RTMClient (P2P)

-(void)sendP2PMessageWithId:(NSNumber *)userId
                messageType:(NSNumber *)messageType
                    message:(NSString *)message
                      attrs:(NSString *)attrs
                    timeout:(int)timeout
                        tag:(id)tag
                    success:(RTMAnswerSuccessCallBack)successCallback
                       fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    messageTypeCallFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);

}
-(RTMAnswer*)sendP2PMessageWithId:(NSNumber *)userId
                      messageType:(NSNumber *)messageType
                          message:(NSString *)message
                            attrs:(NSString *)attrs
                          timeout:(int)timeout{
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:message forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
}



-(void)sendP2PBinaryMessageWithId:(NSNumber *)userId
                      messageType:(NSNumber *)messageType
                             data:(NSData *)data
                            attrs:(NSString *)attrs
                          timeout:(int)timeout
                              tag:(id)tag
                          success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    
    clientCallStatueVerify
    messageTypeCallFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);

}
-(RTMAnswer*)sendP2PBinaryMessageWithId:(NSNumber *)userId
                            messageType:(NSNumber *)messageType
                                   data:(NSData *)data
                                  attrs:(NSString *)attrs
                                timeout:(int)timeout{
    
    clientStatueVerify
    messageTypeFilter(messageType.intValue);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"to"];
    [dic setValue:mid forKey:@"mid"];
    [dic setValue:messageType forKey:@"mtype"];
    [dic setValue:data forKey:@"msg"];
    [dic setValue:attrs forKey:@"attrs"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"sendmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
}





-(void)getP2PHistoryMessageWithUserId:(NSNumber *)userId
                                 desc:(BOOL)desc
                                  num:(NSNumber *)num
                                begin:(NSNumber *)begin
                                  end:(NSNumber *)end
                               lastid:(NSNumber *)lastid
                               mtypes:(NSArray *)mtypes
                              timeout:(int)timeout
                                  tag:(id)tag
                              success:(RTMAnswerSuccessCallBack)successCallback
                                 fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getP2PHistoryMessageWithUserId:(NSNumber *)userId
                                       desc:(BOOL)desc
                                        num:(NSNumber *)num
                                      begin:(NSNumber *)begin
                                        end:(NSNumber *)end
                                     lastid:(NSNumber *)lastid
                                     mtypes:(NSArray *)mtypes
                                    timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"ouid"];
    [dic setValue:@(desc) forKey:@"desc"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:begin forKey:@"begin"];
    [dic setValue:end forKey:@"end"];
    [dic setValue:lastid forKey:@"lastid"];
    [dic setValue:mtypes forKey:@"mtypes"];
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getp2pmsg" message:dic twoWay:YES];
    return  handlerResult(quest,timeout);
    
}


-(void)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                           userId:(NSNumber * _Nonnull)userId
                          timeout:(int)timeout
                              tag:(id)tag
                          success:(RTMAnswerSuccessCallBack)successCallback
                             fail:(RTMAnswerFailCallBack)failCallback{
    
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:userId forKey:@"xid"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
}
-(RTMAnswer*)deleteMessageWithMessageId:(NSNumber * _Nonnull)messageId
                                 userId:(NSNumber * _Nonnull)userId
                                timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:userId forKey:@"xid"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"delmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
}



-(void)getMessageWithMessageId:(NSNumber * _Nonnull)messageId
                        userId:(NSNumber * _Nonnull)userId
                       timeout:(int)timeout
                           tag:(id _Nullable)tag
                       success:(RTMAnswerSuccessCallBack)successCallback
                          fail:(RTMAnswerFailCallBack)failCallback{
    clientCallStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:userId forKey:@"xid"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    BOOL result = handlerCallResult(quest,timeout,tag);
    handlerResultFail;
    //return  handlerCallResult(quest,timeout,tag);
    
}
-(RTMAnswer*)getMessageWithMessageId:(NSNumber * _Nonnull)messageId
                              userId:(NSNumber * _Nonnull)userId
                             timeout:(int)timeout{
    
    clientStatueVerify
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:messageId forKey:@"mid"];
    [dic setValue:userId forKey:@"xid"];
    [dic setValue:@(1) forKey:@"type"];
    // type: 1,p2p; 2,group; 3, room
    
    FPNNQuest * quest = [FPNNQuest questWithMethod:@"getmsg" message:dic twoWay:YES];
    
    return  handlerResult(quest,timeout);
    
}



@end

