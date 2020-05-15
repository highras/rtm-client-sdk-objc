//
//  FPNNCallBackDefinition.h
//  Fpnn
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//



@class FPNNAnswer,FPNError;

//发送Answer结果
typedef void (^FPNNAnswerSuccessCallBack)(NSDictionary * _Nullable data);
typedef void (^FPNNAnswerFailCallBack)(FPNError * _Nullable error);

//client 连接断开
typedef void (^FPNNConnectionSuccessCallBack)(void);
typedef void (^FPNNConnectionCloseCallBack)(void);

//接收quest 返回FPNNAnswer  耗时操作使用FPNNAsyncAnswer (见demo)
typedef FPNNAnswer * _Nullable  (^FPNNListenAndReplyCallBack)(NSDictionary * _Nullable data,NSString * _Nullable method);


