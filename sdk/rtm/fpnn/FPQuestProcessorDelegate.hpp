//
//  FPQuestProcessorDelegate.hpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#ifndef FPQuestProcessorDelegate_hpp
#define FPQuestProcessorDelegate_hpp

#include <stdio.h>
#include "IQuestProcessor.h"
#include "FPNNSDKInternalFuncDefinition.h"

class FPQuestProcessorDelegate: public fpnn::IQuestProcessor
{
    void* _ocQuestProcessor;
    FPNNConnectEvent _ocConnectEvent;
    FPNNConnectWillCloseEvent _ocCloseEvent;
    FPNNQuestEvent _ocQuestEvent;
    
public:
    virtual void connected(const fpnn::ConnectionInfo&);
    virtual void connectionWillClose(const fpnn::ConnectionInfo& connInfo, bool closeByError);
    virtual fpnn::FPAnswerPtr processQuest(const fpnn::FPReaderPtr args, const fpnn::FPQuestPtr quest, const fpnn::ConnectionInfo& connInfo);
    
    fpnn::IAsyncAnswerPtr genAsyncAnswer();
    
    FPQuestProcessorDelegate(void* ocQuestProcessor,
                             FPNNConnectEvent connectEvent,
                             FPNNConnectWillCloseEvent closeEvent,
                             FPNNQuestEvent questEvent):
        _ocQuestProcessor(ocQuestProcessor),
        _ocConnectEvent(connectEvent), _ocCloseEvent(closeEvent), _ocQuestEvent(questEvent)
    {}
    virtual ~FPQuestProcessorDelegate();
};

typedef std::shared_ptr<FPQuestProcessorDelegate> FPQuestProcessorDelegatePtr;

#endif /* FPQuestProcessorDelegate_hpp */
