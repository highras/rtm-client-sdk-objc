//
//  FPNNBridgeCallback.cpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/21.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "ObjcUtils.hpp"
#include "FPNNBridgeCallback.hpp"

void FPNNBridgeCallback::onAnswer(fpnn::FPAnswerPtr answer)
{
    _ocCBFunc(_ocCBObj, &answer, fpnn::FPNN_EC_OK);
}

void FPNNBridgeCallback::onException(fpnn::FPAnswerPtr answer, int errorCode)
{
    if (answer)
        _ocCBFunc(_ocCBObj, &answer, errorCode);
    else
        _ocCBFunc(_ocCBObj, NULL, errorCode);
}

FPNNBridgeCallback::~FPNNBridgeCallback()
{
    ObjCRelease(_ocCBObj);
}
