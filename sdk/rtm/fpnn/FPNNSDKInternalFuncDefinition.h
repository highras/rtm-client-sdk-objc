//
//  FPNNSDKInternalFuncDefinition.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/20.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#ifndef FPNNSDKInternalFuncDefinition_h
#define FPNNSDKInternalFuncDefinition_h

//-- For FPNNQuestProcessor Bridge
typedef void (*FPNNConnectEvent)(void* obj);
typedef void (*FPNNConnectWillCloseEvent)(void* obj, int closedByError);
typedef void* (*FPNNQuestEvent)(void* obj, const void* fpQuest, void* processor);

//-- For FPNNBridgeCallback
typedef void (*FPNNAnswerBridgeCallback)(void* obj, void* fpAnswer, int errorCode);

#endif /* FPNNSDKInternalFuncDefinition_h */
