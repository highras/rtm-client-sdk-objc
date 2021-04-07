//
//  FPNNTCPClient+Connect.m
//  Fpnn
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#import "FPNNCallBackHandler.h"
#import "FPNNTCPClient+Connect.h"
#import "FPNNCallBackDefinition.h"
#import "FpnnDefine.h"

@implementation FPNNTCPClient (Connect)
- (BOOL)connect{
    fpnn::TCPClientPtr client = Client;
    if (Listen == nil || Listen == nullptr) {
        Listen = FPNNCppConnectionListen::createCppConnectionListen(self.connectionSuccessCallBack,
                                                                    self.connectionCloseCallBack,
                                                                    self.listenAndReplyCallBack,
                                                                    self,
                                                                    self.pid);
        client->setQuestProcessor(Listen);
    }
    if (client) {
        if (client->connect() == true) {
            
            return YES;
            
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
    
}
- (BOOL)reconnect{
    fpnn::TCPClientPtr client = Client;
    if (client) {
        if (client->reconnect() == true) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
- (void)closeConnect{
    fpnn::TCPClientPtr client = Client;
    if (client) {
        client->close();
    }
}
@end

