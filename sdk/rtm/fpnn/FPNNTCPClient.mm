//
//  FPNNTCPClient.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/17.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "FPNNCppSDK.hpp"
#include "FPNNBridgeCallback.hpp"
#include "FPQuestProcessorDelegate.hpp"
#import "FPNNQuest.h"
#import "FPNNAnswer.h"
#import "FPNNAnswerCallback.h"
#import "FPNNQuestProcessor.h"
#import "FPNNMessageConvertor.h"
#import "DictionaryToMsgPackConvertor.h"
#import "FPNNConnectionEventProcessor.h"
#import "FPNNTCPClient.h"

#define FPNN_Client_CallbackMapSize 6

@implementation FPNNTCPClient
{
    fpnn::TCPClientPtr _client;
    __weak FPNNQuestProcessor* _questProcessor;
}

//-------------[ init methods ]-------------//
- (instancetype)initWithEndpoint:(NSString*)endpoint autoReconnection:(BOOL)autoReconnect
{
    self = [super init];
    if (self)
    {
        _questProcessor = nil;
        /**
         BOOL is typedef of int, if without force convert, it will be call
            fpnn::TCPClient::createClient(const std::String& host, int port, bool autoReconnect = true);
         But we want it call
            fpnn::TCPClient::createClient(const std::String& endpoint, bool autoReconnect);
         So, autoReconnect MUST cover from BOOL to bool.
         */
        _client = fpnn::TCPClient::createClient([endpoint UTF8String], (bool)autoReconnect);
    }
    return self;
}

- (instancetype)initWithHost:(NSString*)host andPort:(int)port autoReconnection:(BOOL)autoReconnect
{
    self = [super init];
    if (self)
    {
        _questProcessor = nil;
        _client = fpnn::TCPClient::createClient([host UTF8String], port, autoReconnect);
    }
    return self;
}

+ (instancetype)clientWithEndpoint:(NSString*)endpoint
{
    return [[FPNNTCPClient alloc] initWithEndpoint:endpoint autoReconnection:YES];
}
+ (instancetype)clientWithHost:(NSString*)host andPort:(int)port
{
    return [[FPNNTCPClient alloc] initWithHost:host andPort:port autoReconnection:YES];
}

//-------------[ Properties ]-------------//

- (BOOL)connected
{
    if (_client != nullptr)
        return _client->connected();
    else
        return NO;
}

- (NSString*)endpoint
{
    if (_client != nullptr)
        return [NSString stringWithUTF8String:_client->endpoint().c_str()];
    else
        return nil;
}

- (int)questTimeout
{
    if (_client != nullptr)
        return (int)_client->getQuestTimeout();
    else
        return 0;
}

- (void)setQuestTimeout:(int)questTimeout
{
    if (_client != nullptr)
        _client->setQuestTimeout(questTimeout);
}

- (BOOL)autoReconnect
{
    if (_client != nullptr)
        return _client->isAutoReconnect();
    else
        return NO;
}

- (void)setAutoReconnect:(BOOL)autoReconnect
{
    if (_client != nullptr)
        _client->setAutoReconnect(autoReconnect);
}

- (void)setQuestProcessor:(FPNNQuestProcessor *)questProcessor
{
    _questProcessor = questProcessor;
    FPQuestProcessorDelegatePtr processor(new FPQuestProcessorDelegate((__bridge_retained void*)questProcessor,
                                                                       questProcessor.connectedEventCallback,
                                                                       questProcessor.closeEventCallback,
                                                                       questProcessor.questEventCallback));
    
    _client->setQuestProcessor(processor);
}

//-------------[ Configures ]-------------//

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string binaryPublicKey((const char*)publicKey.bytes, publicKey.length);
    _client->enableEncryptor([curve UTF8String], binaryPublicKey, packageMode, reinforce);
}

- (BOOL)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string der((const char*)derData.bytes, derData.length);
    return _client->enableEncryptorByDerData(der, packageMode, reinforce);
}

- (BOOL)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    std::string pem((const char*)pemData.bytes, pemData.length);
    return _client->enableEncryptorByPemData(pem, packageMode, reinforce);
}

- (BOOL)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    return _client->enableEncryptorByDerFile([derFilePath UTF8String], packageMode, reinforce);
}

- (BOOL)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce
{
    return _client->enableEncryptorByPemFile([pemFilePath UTF8String], packageMode, reinforce);
}

//-------------[ Client Methods ]-------------//

- (fpnn::FPQuestPtr)buildCppQuest:(NSString*)method withPayload:(NSDictionary*)params
{
    std::string msgBuf;
    DictionaryToMsgPackConvertor* convertor = [[DictionaryToMsgPackConvertor alloc] init];
    if (![convertor convertFrom:params toCppString:&msgBuf])
        return nullptr;
    
    fpnn::FPQuestPtr quest = fpnn::FPQWriter::emptyQuest([method UTF8String]);
    quest->setPayload(msgBuf);
    quest->setPayloadSize((uint32_t)msgBuf.length());
    
    return quest;
}

- (FPNNAnswer*)sendQuest:(NSString*)method withPayload:(NSDictionary*)params
{
    return [self sendQuest:method withPayload:params withTimeout:0];
}

- (FPNNAnswer*)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withTimeout:(int)timeout
{
    fpnn::FPQuestPtr quest = [self buildCppQuest:method withPayload:params];
    if (quest == nullptr)
    {
        return [FPNNAnswer answerWithErrorCode:fpnn::FPNN_EC_CORE_ENCODING andDescription:@"Convert quest params to msgPack failed."];
    }
    
    fpnn::FPAnswerPtr answer = _client->sendQuest(quest, timeout);
    
    if (answer)
        return [FPNNMessageConvertor convertFPAnswer:&answer];
    
    return nil;
}

 - (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallback:(FPNNAnswerCallback*)callback
{
    return [self sendQuest:method withPayload:params withCallback:callback timeout:0];
}

 - (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout
{
    fpnn::FPQuestPtr quest = [self buildCppQuest:method withPayload:params];
    if (quest == nullptr)
        return NO;
    
    FPNNBridgeCallback* cppCB = new FPNNBridgeCallback((__bridge_retained void*)callback, callback.cppCallback);
    bool status = _client->sendQuest(quest, cppCB, timeout);
    if (status)
        return YES;
    
    delete cppCB;
    return NO;
}

 - (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block
{
    return [self sendQuest:method withPayload:params withCallbackBlock:block timeout:0];
}

 - (BOOL)sendQuest:(NSString*)method withPayload:(NSDictionary*)params withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout
{
    fpnn::FPQuestPtr quest = [self buildCppQuest:method withPayload:params];
    if (quest == nullptr)
        return NO;
    
    FPNNAnswerBlockCallback *callback = [[FPNNAnswerBlockCallback alloc] initWithBlock:block];
    FPNNBridgeCallback* cppCB = new FPNNBridgeCallback((__bridge_retained void*)callback, callback.cppCallback);
    bool status = _client->sendQuest(quest, cppCB, timeout);
    if (status)
        return YES;
    
    delete cppCB;
    return NO;
}

- (void)sendNotify:(NSString*)method withPayload:(NSDictionary*)params
{
    std::string msgBuf;
    DictionaryToMsgPackConvertor* convertor = [[DictionaryToMsgPackConvertor alloc] init];
    if (![convertor convertFrom:params toCppString:&msgBuf])
        return;
    
    fpnn::FPQuestPtr quest = fpnn::FPQWriter::emptyQuest([method UTF8String], true);
    quest->setPayload(msgBuf);
    quest->setPayloadSize((uint32_t)msgBuf.length());
    
    _client->sendQuest(quest);
}

//-----------[ Sending Functions ]----------------//

- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withTimeout:0];
    else
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return nil;
    }
}
- (FPNNAnswer*)sendQuest:(FPNNQuest*)quest withTimeout:(int)timeout
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withTimeout:timeout];
    else
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return nil;
    }
}
- (BOOL)sendQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withCallback:callback timeout:0];
    else if (callback == nil)
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return YES;
    }
    else
        return NO;
}
- (BOOL)sendQuest:(FPNNQuest*)quest withCallback:(FPNNAnswerCallback*)callback timeout:(int)timeout
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withCallback:callback timeout:timeout];
    else if (callback == nil)
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return YES;
    }
    else
        return NO;
}
- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withCallbackBlock:block timeout:0];
    else if (block == nil)
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return YES;
    }
    else
        return NO;
}
- (BOOL)sendQuest:(FPNNQuest*)quest withCallbackBlock:(void(^)(int errorCode, NSDictionary* payload))block timeout:(int)timeout
{
    if (quest.twoway)
        return [self sendQuest:quest.method withPayload:quest.payload withCallbackBlock:block timeout:timeout];
    else if (block == nil)
    {
        [self sendNotify:quest.method withPayload:quest.payload];
        return YES;
    }
    else
        return NO;
}

//-----------[ Connection Operation Functions ]----------------//

- (BOOL)connect
{
    if (_client != nullptr)
        return _client->connect();
    else
        return NO;
}

- (BOOL)reconnect
{
    if (_client != nullptr)
        return _client->reconnect();
    else
        return NO;
}

- (void)close
{
    if (_client != nullptr)
        _client->close();
}

- (void)setConnectedCallback:(void(^)(void))block
{
    if (_questProcessor == nil)
    {
        FPNNConnectionEventProcessor* processor = [[FPNNConnectionEventProcessor alloc] init];
        [processor setConnectedCallback:block];
        [self setQuestProcessor:processor];
    }
    else if ([_questProcessor isKindOfClass:[FPNNConnectionEventProcessor class]])
    {
        FPNNConnectionEventProcessor* processor = (FPNNConnectionEventProcessor*)_questProcessor;
        [processor setConnectedCallback:block];
    }
}

- (void)setConnectionWillCloseCallback:(void(^)(BOOL causedByError))block
{
    if (_questProcessor == nil)
    {
        FPNNConnectionEventProcessor* processor = [[FPNNConnectionEventProcessor alloc] init];
        [processor setConnectionWillCloseCallback:block];
        [self setQuestProcessor:processor];
    }
    else if ([_questProcessor isKindOfClass:[FPNNConnectionEventProcessor class]])
    {
        FPNNConnectionEventProcessor* processor = (FPNNConnectionEventProcessor*)_questProcessor;
        [processor setConnectionWillCloseCallback:block];
    }
}

@end
