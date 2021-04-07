//
//  NSDictionary+Msgpack.h
//  Fpnn
//
//  Created by zsl on 2019/11/26.
//  Copyright © 2019 FunPlus. All rights reserved.
//

//#include <iostream>
//#include <msgpack.hpp>
//#include <string>
//#include <sstream>
#include "TCPClient.h"
#import <Foundation/Foundation.h>
#import "FPNError.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MsgPack)
//@property(nonatomic,assign)std::string msgPack;
-(std::string)toMsgPack:(NSString * _Nullable)pid;//rtm专用
@end

@interface FPNNMessageEncoder : NSObject
//- (instancetype)initWithMessage:(NSDictionary*)message;
- (instancetype)initWithMessage:(NSDictionary*)message pid:(NSString * _Nullable)pid;
@property(nonatomic,assign)std::string encodeResult;
@end


@interface FPNNMessageDecoder : NSObject
- (instancetype)initWithAnswer:(fpnn::FPAnswerPtr)cppAnswer;
- (instancetype)initWithAnswer:(fpnn::FPAnswerPtr)cppAnswer errorCode:(int)errorCode;
- (instancetype)initWithQuest:(fpnn::FPQuestPtr)cppQuest;
@property(nonatomic,strong)NSDictionary * decodeResult;
@property(nonatomic,strong)FPNError * error;
@end

NS_ASSUME_NONNULL_END
