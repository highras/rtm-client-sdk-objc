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
- (void)connect{
    fpnn::TCPClientPtr client = Client;
    if (Listen == nil || Listen == nullptr) {
        Listen = FPNNCppConnectionListen::createCppConnectionListen(self.connectionSuccessCallBack, self.connectionCloseCallBack, self.listenAndReplyCallBack,self);
        client->setQuestProcessor(Listen);
    }
    if (client) {
        client->connect();
    }
}
- (void)reconnect{
    fpnn::TCPClientPtr client = Client;
    if (client) {
        client->reconnect();
    }
}
- (void)closeConnect{
    fpnn::TCPClientPtr client = Client;
    if (client) {
        client->close();
    }
}
@end
