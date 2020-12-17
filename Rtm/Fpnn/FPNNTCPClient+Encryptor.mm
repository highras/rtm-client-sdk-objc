//
//  FPNNTCPClient+Encryptor.m
//  Fpnn
//
//  Created by zsl on 2019/11/28.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#include "TCPClient.h"
#import "FPNNTCPClient+Encryptor.h"
#import "FPNNCallBackDefinition.h"
#import "FPNNTCPClient.h"
#import "FpnnDefine.h"
@implementation FPNNTCPClient (Encryptor)
- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string binaryPublicKey((const char*)publicKey.bytes, publicKey.length);
    fpnn::TCPClientPtr client = Client;
    client->enableEncryptor([curve UTF8String], binaryPublicKey, packageMode, reinforce);
}

- (BOOL)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string der((const char*)derData.bytes, derData.length);
    fpnn::TCPClientPtr client = Client;
    return client->enableEncryptorByDerData(der, packageMode, reinforce);
}

- (BOOL)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string pem((const char*)pemData.bytes, pemData.length);
    fpnn::TCPClientPtr client = Client;
    return client->enableEncryptorByPemData(pem, packageMode, reinforce);
}

- (BOOL)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    fpnn::TCPClientPtr client = Client;
    return client->enableEncryptorByDerFile([derFilePath UTF8String], packageMode, reinforce);
}

- (BOOL)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    fpnn::TCPClientPtr client = Client;
    return client->enableEncryptorByPemFile([pemFilePath UTF8String], packageMode, reinforce);
}
@end
