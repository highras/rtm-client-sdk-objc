//
//  FPNNProtocol.h
//  Fpnn
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FPNNTCPClient,FPNNAnswer,FPNNQuest;

@protocol FPNNProtocol <NSObject>

@optional
//发送Answer结果
-(void)fpnnReceiveDataSuccess:(NSDictionary * _Nullable )responseData client:(FPNNTCPClient * _Nullable)client quest:(FPNNQuest * _Nullable)quest;
-(void)fpnnReceiveDataError:(FPNError * _Nullable)error client:(FPNNTCPClient * _Nullable)client quest:(FPNNQuest * _Nullable)quest;
//client 连接断开
-(void)fpnnConnectionSuccess:(FPNNTCPClient * _Nullable) client;
-(void)fpnnConnectionClose:(FPNNTCPClient * _Nullable) client;

//接收quest 返回FPNNAnswer  耗时操作使用FPNNAsyncAnswer (见demo)
//如果指定method方法 则不会被调用
-(FPNNAnswer*)fpnnListenAndReplyMessage:(NSDictionary * _Nullable)data method:(NSString * _Nullable)method client:(FPNNTCPClient * _Nullable)client ;

@end

NS_ASSUME_NONNULL_END
