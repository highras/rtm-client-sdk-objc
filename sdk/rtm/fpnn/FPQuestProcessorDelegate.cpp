//
//  FPQuestProcessorDelegate.cpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "ObjcUtils.hpp"
#include "FPQuestProcessorDelegate.hpp"

void FPQuestProcessorDelegate::connected(const fpnn::ConnectionInfo&)
{
    _ocConnectEvent(_ocQuestProcessor);
}

void FPQuestProcessorDelegate::connectionWillClose(const fpnn::ConnectionInfo& connInfo, bool closeByError)
{
    _ocCloseEvent(_ocQuestProcessor, closeByError ? 1 : 0);
}

fpnn::FPAnswerPtr FPQuestProcessorDelegate::processQuest(const fpnn::FPReaderPtr args, const fpnn::FPQuestPtr quest, const fpnn::ConnectionInfo& connInfo)
{
    void* result = _ocQuestEvent(_ocQuestProcessor, &quest, this);
    if (result)
    {
        fpnn::FPAnswerPtr* ans = (fpnn::FPAnswerPtr*)result;
        fpnn::FPAnswerPtr answer = *ans;
        delete ans;
        return answer;
    }
    else
        return nullptr;
}

fpnn::IAsyncAnswerPtr FPQuestProcessorDelegate::genAsyncAnswer()
{
    return fpnn::IQuestProcessor::genAsyncAnswer();
}

FPQuestProcessorDelegate::~FPQuestProcessorDelegate()
{
    ObjCRelease(_ocQuestProcessor);
}
