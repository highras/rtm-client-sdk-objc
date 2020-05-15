//
//  FPNNCallBackHandler.h
//  Fpnn
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#include "TCPClient.h"
#import <Foundation/Foundation.h>
#import "FPNNCallBackDefinition.h"
#import "FPNNTCPClient.h"
#import "FPNNAnswer.h"
#import "FPNNQuest.h"
@interface FPNNCallBackHandler : NSObject{

}
@end

class FPNNCppAnswerCallback: public fpnn::AnswerCallback{

     FPNNAnswerSuccessCallBack _successCallBack;
     FPNNAnswerFailCallBack _failCallBack;
     __weak FPNNTCPClient * _client;
     FPNNQuest * _quest;
     
     public:
        virtual void onAnswer(fpnn::FPAnswerPtr);
        virtual void onException(fpnn::FPAnswerPtr answer, int errorCode);
        FPNNCppAnswerCallback(FPNNAnswerSuccessCallBack successCallBack,FPNNAnswerFailCallBack failCallBack,FPNNTCPClient* client,FPNNQuest * quest){
            _successCallBack = successCallBack;
            _failCallBack = failCallBack;
            _client = client;
            _quest = quest;
        }
        virtual ~FPNNCppAnswerCallback();
};


class FPNNCppConnectionListen;
typedef std::shared_ptr<FPNNCppConnectionListen> FPNNCppConnectionListenPtr;
class FPNNCppConnectionListen: public fpnn::IQuestProcessor{

    
    
public:
    
     FPNNConnectionSuccessCallBack _connectionSuccessCallBack;
     FPNNConnectionCloseCallBack _connectionCloseCallBack;
     FPNNListenAndReplyCallBack _listenAndReplyCallBack;
     __weak FPNNTCPClient * _client;
//     FPNNQuest * _quest;
    
    virtual void connected(const fpnn::ConnectionInfo&);
    virtual void connectionWillClose(const fpnn::ConnectionInfo& connInfo, bool closeByError);
    
    virtual fpnn::FPAnswerPtr processQuest(const fpnn::FPReaderPtr args, const fpnn::FPQuestPtr quest, const fpnn::ConnectionInfo& connInfo);
    fpnn::IAsyncAnswerPtr genAsyncAnswer();
    
    fpnn::FPAnswerPtr handleAnswer(std::string msgPackResult , const fpnn::FPQuestPtr quest);
    
    FPNNCppConnectionListen(FPNNConnectionSuccessCallBack connectionSuccessCallBack,FPNNConnectionCloseCallBack connectionCloseCallBack,FPNNListenAndReplyCallBack listenAndReplyCallBack,FPNNTCPClient* client){
        _connectionSuccessCallBack = connectionSuccessCallBack;
        _connectionCloseCallBack = connectionCloseCallBack;
        _listenAndReplyCallBack = listenAndReplyCallBack;
        _client = client;
//        _quest = quest;
    }
    
    
    inline static FPNNCppConnectionListenPtr createCppConnectionListen(FPNNConnectionSuccessCallBack connectionSuccessCallBack,FPNNConnectionCloseCallBack connectionCloseCallBack,FPNNListenAndReplyCallBack listenAndReplyCallBack,FPNNTCPClient* client)
    {
        
        return FPNNCppConnectionListenPtr(new FPNNCppConnectionListen(connectionSuccessCallBack, connectionCloseCallBack, listenAndReplyCallBack,client));
    }
    virtual ~FPNNCppConnectionListen();
    
};

