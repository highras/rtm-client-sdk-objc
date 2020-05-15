//
//  RTMCallBackDefinition.h
//  Rtm
//
//  Created by zsl on 2019/12/13.
//  Copyright © 2019 FunPlus. All rights reserved.
//

@class FPNError,RTMAnswer;
typedef void (^RTMAnswerSuccessCallBack)(NSDictionary * _Nullable data,id _Nullable tag);
typedef void (^RTMAnswerFailCallBack)(FPNError * _Nullable error,id _Nullable tag);

typedef void (^RTMConnectSuccessCallBack)(NSDictionary * _Nullable data);
typedef void (^RTMConnectFailCallBack)(FPNError * _Nullable error);

//接收服务端发送的quest  处理twoway返回answer(耗时返回操作 见demo)  quest是oneway下会自动返回
typedef RTMAnswer * _Nullable (^RTMListenAndReplyCallBack)(NSDictionary * _Nullable data,NSString * _Nullable method);


typedef void (^RTMConnectStateSuccessCallBack)(void);
typedef void (^RTMConnectstateCloseCallBack)(void);
