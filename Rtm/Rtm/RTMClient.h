//
//  RTMClient.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMProtocol.h"
#import "RTMCallBackDefinition.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RTMClientStatus)
{
    RTMConnecting = 0,
    RTMConnected = 1,
    RTMConnectClose = 2,
    RTMConnectFail = 3
};



@interface RTMClient : NSObject

@property (nonatomic,readonly,strong) NSString * token;//验证用 server获取
@property (nonatomic,readonly,assign) int32_t pid;//项目id
@property (nonatomic,readonly,assign) int64_t uid;//用户id
@property (nonatomic,strong) NSString * _Nullable lang;//当前语言
@property (nonatomic,strong) NSDictionary * _Nullable attrs;//例如 设置客户端信息，会保存在当前链接中，客户端可以获取到
@property (nonatomic,strong) NSString * _Nullable os;//系统
@property (nonatomic,strong) NSString * _Nullable addrType;//string: ipv4、ipv6、domain
@property (nonatomic,strong) NSString * _Nullable proto;//string: tcp、ssl

@property (nonatomic,readonly,assign) BOOL isDisconnected;
@property (nonatomic,readonly,assign) BOOL isConnected;
@property (nonatomic,readonly,strong) NSString * connectedHost;
@property (nonatomic,readonly,assign) int connectedPort;

@property (nonatomic,assign)id <RTMProtocol> delegate;

@property (nonatomic,readonly,assign) RTMClientStatus clientStatus;

@property (nonatomic,readonly,strong)NSString * sdkVersion;
@property (nonatomic,readonly,strong)NSString * apiVersion;

- (instancetype _Nullable)initWithEndpoint:(NSString * _Nonnull)endpoint pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token;
- (instancetype _Nullable)initWithHost:(NSString * _Nonnull)host port:(int)port pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token;
+ (instancetype _Nullable)clientWithEndpoint:(NSString * _Nonnull)endpoint pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token;
+ (instancetype _Nullable)clientWithHost:(NSString * _Nonnull)host port:(int)port pid:(int32_t)pid uid:(int64_t)uid token:(NSString*)token;

@property (nonatomic,assign) int sendQuestTimeout;//默认30秒

- (void)verifyConnectSuccess:(RTMConnectSuccessCallBack)success connectFali:(RTMConnectFailCallBack)fail;
- (void)closeConnect;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
