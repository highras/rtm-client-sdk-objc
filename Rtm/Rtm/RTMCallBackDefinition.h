//
//  RTMCallBackDefinition.h
//  Rtm
//
//  Created by zsl on 2019/12/13.
//  Copyright © 2019 FunPlus. All rights reserved.
//

@class FPNError,RTMAnswer;

typedef void (^RTMAnswerSuccessCallBack)(NSDictionary * _Nullable data);
typedef void (^RTMAnswerFailCallBack)(FPNError * _Nullable error);

