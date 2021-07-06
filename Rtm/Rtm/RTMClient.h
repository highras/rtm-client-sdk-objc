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
#import "RTMClientConfig.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RTMClientConnectStatus){
    
    RTMClientConnectStatusConnectClosed = 0,
    RTMClientConnectStatusConnecting = 1,
    RTMClientConnectStatusConnected = 2,
    
};
typedef void (^RTMLoginSuccessCallBack)(void);
typedef void (^RTMLoginFailCallBack)(FPNError * _Nullable error);

@interface RTMClient : NSObject


+ (nullable instancetype)clientWithEndpoint:(nonnull NSString * )endpoint
                                   projectId:(int64_t)projectId
                                      userId:(int64_t)userId
                                    delegate:(id <RTMProtocol>)delegate
                                      config:(nullable RTMClientConfig *)config
                                 autoRelogin:(BOOL)autoRelogin;


- (void)loginWithToken:(nonnull NSString *)token
              language:(nullable NSString *)language
             attribute:(nullable NSDictionary *)attribute
               timeout:(int)timeout //默认30秒
               success:(RTMLoginSuccessCallBack)loginSuccess
           connectFail:(RTMLoginFailCallBack)loginFail;



@property (nonatomic,strong)RTMClientConfig * clientConfig;
+(NSString*)getSdkVersion;
@property (nonatomic,readonly,strong)NSString * sdkVersion;
@property (nonatomic,readonly,strong)NSString * apiVersion;
@property (nonatomic,readonly,assign)RTMClientConnectStatus currentConnectStatus;
@property (nonatomic,assign,nullable)id <RTMProtocol> delegate;
@property(nonatomic,readonly,assign)int64_t projectId;
@property(nonatomic,readonly,assign)int64_t userId;

- (void)closeConnect;





- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
