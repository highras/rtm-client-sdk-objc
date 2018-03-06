//
//  FPNNBridgeCallback.hpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/21.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#ifndef FPNNBridgeCallback_hpp
#define FPNNBridgeCallback_hpp

#include <stdio.h>
#include "AnswerCallbacks.h"
#include "FPNNSDKInternalFuncDefinition.h"

class FPNNBridgeCallback: public fpnn::AnswerCallback
{
    void* _ocCBObj;
    FPNNAnswerBridgeCallback _ocCBFunc;
    
public:
    virtual void onAnswer(fpnn::FPAnswerPtr);
    virtual void onException(fpnn::FPAnswerPtr answer, int errorCode);
    
    FPNNBridgeCallback(void* ocAnswerCallbackObj, FPNNAnswerBridgeCallback ocAnswerCallbackFunc):
        _ocCBObj(ocAnswerCallbackObj), _ocCBFunc(ocAnswerCallbackFunc)
    {}
    virtual ~FPNNBridgeCallback();
};

#endif /* FPNNBridgeCallback_hpp */
