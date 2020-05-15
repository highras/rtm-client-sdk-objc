//
//  FPNNTCPClient+Send.m
//  Fpnn
//
//  Created by zsl on 2019/11/26.
//  Copyright © 2019 FunPlus. All rights reserved.
//

//#include "FPNNCppSDK.hpp"
//#import "FPNNTCPClient.h"


#import "NSDictionary+MsgPack.h"
#import "FPNNCallBackHandler.h"

#import "FPNNTCPClient+Send.h"
#import "FPNNTCPClient.h"
#import "FPNNQuest.h"
#import "FPNNAnswer.h"
#import "FPNNAsyncAnswer.h"
#import "FPNNCallBackDefinition.h"



@implementation FPNNTCPClient (Send)

#pragma mark set asyn listen

-(void)_setConnectionStatusAndReplyListen:(fpnn::TCPClientPtr)client{
    if (Listen == nil || Listen == nullptr) {
        Listen = FPNNCppConnectionListen::createCppConnectionListen(self.connectionSuccessCallBack, self.connectionCloseCallBack, self.listenAndReplyCallBack,self);
        client->setQuestProcessor(Listen);
    }
}

#pragma mark return FPNNAnswer

-(fpnn::FPAnswerPtr)_send:(FPNNQuest *)quest timeout:(int)timeout{
    if (quest == nil) {
        FPNSLog(@"fpnn FPNNTCPClient send error. quest is nil");
        return nil;
    }
    fpnn::TCPClientPtr client = Client;
    fpnn::FPQuestPtr cppQuest = Quest(quest);
    if (client == nil || cppQuest  == nil) {
        FPNSLog(@"fpnn FPNNTCPClient send error. getCpp client or quest is nil");
        return nil;
    }
    [self _setConnectionStatusAndReplyListen:client];
    return (timeout <= 0 ? client->sendQuest(cppQuest) : client->sendQuest(cppQuest,timeout));
}

-(FPNNAnswer *)_handleAnswer:(FPNNMessageDecoder*)decoder quest:(FPNNQuest*)quest{
    if (decoder.error == nil) {
        //NSAllLog(@"%@成功返回数据 11 == %@",quest.method,decoder.decodeResult);
        if ([self.delegate respondsToSelector:@selector(fpnnReceiveDataSuccess:client:quest:)]) {
            [self.delegate fpnnReceiveDataSuccess:decoder.decodeResult client:self quest:quest];
        }
        return [FPNNAnswer answerWithMessage:decoder.decodeResult];
    }else{
        //NSAllLog(@"%@错误返回数据 11 == %@",quest.method,decoder.decodeResult);
        if ([self.delegate respondsToSelector:@selector(fpnnReceiveDataError:client:quest:)]) {
            [self.delegate fpnnReceiveDataError:decoder.error client:self quest:quest];
        }
        return [FPNNAnswer answerWithError:decoder.error];
    }
}

- (FPNNAnswer *)sendQuest:(NSString *)method message:(NSDictionary *)message timeout:(int)timeout{
    FPNNQuest * quest = [FPNNQuest questWithMethod:method message:message twoWay:YES];
    fpnn::FPAnswerPtr cppAnswer = [self _send:quest timeout:timeout];
    if (quest.twoWay && cppAnswer != nil) {
        return [self _handleAnswer:[[FPNNMessageDecoder alloc] initWithAnswer:cppAnswer] quest:quest];
    }else{
        return nil;
    }
}

- (FPNNAnswer *)sendQuest:(NSString *)method message:(NSDictionary *)message{
    FPNNQuest * quest = [FPNNQuest questWithMethod:method message:message twoWay:YES];
    fpnn::FPAnswerPtr cppAnswer = [self _send:quest timeout:0];
    if (quest.twoWay && cppAnswer != nil) {
        return [self _handleAnswer:[[FPNNMessageDecoder alloc] initWithAnswer:cppAnswer] quest:quest];
    }else{
        return nil;
    }
}
- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest timeout:(int)timeout{
    fpnn::FPAnswerPtr cppAnswer = [self _send:quest timeout:timeout];
    if (quest.twoWay && cppAnswer != nil) {
        return [self _handleAnswer:[[FPNNMessageDecoder alloc] initWithAnswer:cppAnswer] quest:quest];
    }else{
        return nil;
    }
}

- (FPNNAnswer *)sendQuest:(FPNNQuest *)quest{
    fpnn::FPAnswerPtr cppAnswer = [self _send:quest timeout:0];
    if (quest.twoWay && cppAnswer != nil) {
        return [self _handleAnswer:[[FPNNMessageDecoder alloc] initWithAnswer:cppAnswer] quest:quest];
    }else{
        return nil;
    }
}

#pragma mark return callBack

- (BOOL)sendQuest:(NSString*)method
          message:(NSDictionary *)message
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback{
    
        FPNNQuest * quest = [FPNNQuest questWithMethod:method message:message twoWay:YES];
        return [self _send:quest success:successCallback fail:failCallback timeout:0];
        
}

- (BOOL)sendQuest:(NSString*)method
          message:(NSDictionary*)message
          timeout:(int)timeout
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback {
    
        FPNNQuest * quest = [FPNNQuest questWithMethod:method message:message twoWay:YES];
        return [self _send:quest success:successCallback fail:failCallback timeout:timeout];
}

- (BOOL)sendQuest:(FPNNQuest*)quest
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback{
    
        return [self _send:quest success:successCallback fail:failCallback timeout:0];
        
}

- (BOOL)sendQuest:(FPNNQuest*)quest
          timeout:(int)timeout
          success:(FPNNAnswerSuccessCallBack)successCallback
             fail:(FPNNAnswerFailCallBack)failCallback {
    
        return [self _send:quest success:successCallback fail:failCallback timeout:timeout];
        
}

-(BOOL)_send:(FPNNQuest *)quest
     success:(FPNNAnswerSuccessCallBack)successCallback
        fail:(FPNNAnswerFailCallBack)failCallback
     timeout:(int)timeout{
    
    if (quest == nil) {
        return NO;
    }
    
    fpnn::TCPClientPtr client = Client;
    [self _setConnectionStatusAndReplyListen:client];
    fpnn::FPQuestPtr cppQuest = Quest(quest);
    FPNNCppAnswerCallback * call = new FPNNCppAnswerCallback(successCallback,failCallback,self,quest);
    
    if (client == nil || cppQuest  == nil) {
        FPNSLog(@"fpnn FPNNTCPClient send callback error. getCpp client or quest is nil");
        return NO;
    }
    
    bool status;
    if (timeout <= 0) {
        status = client->sendQuest(cppQuest,call);
    }else{
        status = client->sendQuest(cppQuest,call,timeout);
    }
    return status == true ? YES : NO;
}
@end
