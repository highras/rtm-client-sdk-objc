//
//  FPNNCallBackHandler.m
//  Fpnn
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "FPNNCallBackHandler.h"
#import "NSDictionary+MsgPack.h"
@implementation FPNNCallBackHandler

@end

#pragma mark FPNNCppAnswerCallback

void FPNNCppAnswerCallback::onAnswer(fpnn::FPAnswerPtr answer){
        
    @autoreleasepool {
        //NSLog(@"%s",__FUNCTION__);
        FPNNMessageDecoder * decoder = [[FPNNMessageDecoder alloc] initWithAnswer:answer];
        
        //NSLog(@"%@成功返回数据 22 == %@",_quest.method,decoder.decodeResult);
        if (decoder.error == nil) {
            
            if (_successCallBack) {
                _successCallBack(decoder.decodeResult);
            }
            
            if ([_client.delegate respondsToSelector:@selector(fpnnReceiveDataSuccess:client:quest:)]) {
                [_client.delegate fpnnReceiveDataSuccess:decoder.decodeResult client:_client quest:_quest];
            }
            
        }else{
            
            if (_failCallBack) {
                _failCallBack(decoder.error);
            }

            if ([_client.delegate respondsToSelector:@selector(fpnnReceiveDataError:client:quest:)]) {
                [_client.delegate fpnnReceiveDataError:decoder.error client:_client quest:_quest];
            }
            
        }
    }
    
    
    
       
}

void FPNNCppAnswerCallback::onException(fpnn::FPAnswerPtr answer, int errorCode){
    
     @autoreleasepool {
         
         //NSLog(@"%s",__FUNCTION__);
         FPNNMessageDecoder * decoder = [[FPNNMessageDecoder alloc] initWithAnswer:answer errorCode:errorCode];
         
         //NSLog(@"%@错误返回数据 22 == %@  %@ %d",_quest.method,decoder.decodeResult,decoder.error,errorCode);
         
         if (_failCallBack) {
             _failCallBack(decoder.error);
         }

         if ([_client.delegate respondsToSelector:@selector(fpnnReceiveDataError:client:quest:)]) {
             [_client.delegate fpnnReceiveDataError:decoder.error client:_client quest:_quest];
         }
         
     }
    
    
}

FPNNCppAnswerCallback::~FPNNCppAnswerCallback(){
//    NSLog(@"FPNNCppAnswerCallback dealloc");
    
}





#pragma mark FPNNCppConnectionListen


FPNNCppConnectionListen:: ~FPNNCppConnectionListen(){
    //NSAllLog(@"FPNNCppConnectionListen dealloc");
}

void FPNNCppConnectionListen::connected(const fpnn::ConnectionInfo&connectionInfo){
    
    @autoreleasepool {
        //NSLog(@"%s",__FUNCTION__);
        @synchronized (_client) {
            [_client setValue:[NSString stringWithFormat:@"%s",connectionInfo.ip.c_str()] forKey:@"connectedHost"];
            [_client setValue:@(connectionInfo.port) forKey:@"connectedPort"];
            [_client setValue:@(YES) forKey:@"isConnected"];
            [_client setValue:@(NO) forKey:@"isDisconnected"];
        }
        
        //NSAllLog(@"%@ connect",_client);
        
        if (_connectionSuccessCallBack) {
            _connectionSuccessCallBack();
        }
        
        if ([_client.delegate respondsToSelector:@selector(fpnnConnectionSuccess:)]) {
            [_client.delegate fpnnConnectionSuccess:_client];
        }
    }
    
}

void FPNNCppConnectionListen::connectionWillClose(const fpnn::ConnectionInfo& connInfo, bool closeByError){
    
    @autoreleasepool {
        //NSLog(@"%s",__FUNCTION__);
        @synchronized (_client) {
            [_client setValue:nil forKey:@"connectedHost"];
            [_client setValue:@(0) forKey:@"connectedPort"];
            //[_client setValue:nil forKey:@"connectedPort"];无效 不重写 setNilValueForKey 会自动 return
            [_client setValue:@(NO) forKey:@"isConnected"];
            [_client setValue:@(YES) forKey:@"isDisconnected"];
        }
        //NSAllLog(@"%@ connectClose",_client);
        
        if (_connectionCloseCallBack) {
            _connectionCloseCallBack();
        }
        
        if ([_client.delegate respondsToSelector:@selector(fpnnConnectionClose:)]) {
            [_client.delegate fpnnConnectionClose:_client];
        }
    }
    
    
}


fpnn::FPAnswerPtr FPNNCppConnectionListen::processQuest(const fpnn::FPReaderPtr args, const fpnn::FPQuestPtr quest, const fpnn::ConnectionInfo& connInfo)
{
    //NSLog(@"%s",__FUNCTION__);
    
    @autoreleasepool {
        NSString* method;
        if (quest != nullptr) {
            
            if (quest->method().empty() == false) {
                
                    method = [NSString stringWithUTF8String:quest->method().c_str()];
                }
            
            if (method == nil) {
                FPNSLog(@"fpnn processQuest get method is nil");
                return nullptr;
            }
            
        }else{
            
            FPNSLog(@"fpnn processQuest get quest is nil");
            return nullptr;
            
        }
        
        
        FPNNMessageDecoder * decoder = [[FPNNMessageDecoder alloc] initWithQuest:quest];
        
        //NSLog(@"\n接收 quest response == %@\nmethod == %@  ",decoder.decodeResult,method);
        //block
        if (_listenAndReplyCallBack && decoder.error == nil) {

            
            FPNNAnswer * answer = _listenAndReplyCallBack(decoder.decodeResult,method);

            if (quest->isTwoWay() == false) {
                return nullptr;
            }
            
            if (answer.error) {
                
                NSDictionary * data = @{@"code":[NSString stringWithFormat:@"%ld",(long)answer.error.code],
                                        @"ex":answer.error.ex};
            
                return handleAnswer(data.msgPack, quest);
            }


            if (answer.responseData) {

               
                    
                    return handleAnswer(answer.responseData.msgPack, quest);
                    
               
                

            }
            return nullptr;
        }
        
    
    
    
    


//    //delegate 指定方法
//    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:method:client:", method]);
//    if([_client.delegate respondsToSelector:selector] && decoder.error == nil){
//
//        FPNNAnswer * answer = ((FPNNAnswer* (*)(id, SEL,NSDictionary* ,NSString*,FPNNTCPClient*))[(id)_client.delegate methodForSelector:selector])((id)_client.delegate, selector,decoder.decodeResult,method,_client);
//
//        if (quest->isTwoWay() == false) {
//            return nullptr;
//        }
//
//        if (answer.error) {
//            NSDictionary * data = @{@"code":[NSString stringWithFormat:@"%ld",(long)answer.error.code],
//                                        @"ex":answer.error.ex};
//
//            return handleAnswer(data.msgPack, quest);
//        }
//
//        if (answer.responseData) {
//
//            return handleAnswer(answer.responseData.msgPack, quest);
//
//        }
//
//        return nullptr;
//
//    }
//
//
//
//    //delegate 通用方法
//    if ([_client.delegate respondsToSelector:@selector(fpnnListenAndReplyMessage:method:client:)] && decoder.error == nil ) {
//
//        FPNNAnswer * answer = [_client.delegate fpnnListenAndReplyMessage:decoder.decodeResult
//                                                                   method:method
//                                                                   client:_client];
//
//        if (quest->isTwoWay() == false) {
//            return nullptr;
//        }
//
//        if (answer.error) {
//            NSDictionary * data = @{@"code":[NSString stringWithFormat:@"%ld",(long)answer.error.code],
//                                        @"ex":answer.error.ex};
//            return handleAnswer(data.msgPack, quest);
//        }
//
//
//        if (answer.responseData) {
//
//            return handleAnswer(answer.responseData.msgPack, quest);
//
//        }
//
//        return nullptr;
//
//    }

        return nullptr;
}
}

fpnn::FPAnswerPtr FPNNCppConnectionListen::handleAnswer(std::string msgPackResult , const fpnn::FPQuestPtr quest){
    
            @autoreleasepool {
                
                fpnn::FPAnswerPtr cppAnswer = fpnn::FPAWriter::emptyAnswer(quest);
                if (!msgPackResult.empty()) {
                    cppAnswer->setPayload(msgPackResult);
                    cppAnswer->setPayloadSize((uint32_t)msgPackResult.length());
                    return cppAnswer;
                }else{
                    return fpnn::FPAWriter::errorAnswer(quest, fpnn::FPNN_EC_CORE_ENCODING,
                                                        "Concert answer payload to msgPack failed.",
                                                        "FPNN Objective-C SDK (Base on C++)");
                }
                
            }
    
    
    
    
}

fpnn::IAsyncAnswerPtr FPNNCppConnectionListen::genAsyncAnswer()
{
    @autoreleasepool {
        return fpnn::IQuestProcessor::genAsyncAnswer();
    }
    
}

