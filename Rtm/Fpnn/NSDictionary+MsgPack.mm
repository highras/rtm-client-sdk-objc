//
//  NSDictionary+Msgpack.m
//  Fpnn
//
//  Created by zsl on 2019/11/26.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#include "PayloadDictionaryBuildDelegate.hpp"
#import "PayloadDictionaryBuilder.h"
#import "NSDictionary+MsgPack.h"
#import "MPMessagePackReader.h"
#import "MPMessagePackWriter.h"

@implementation NSDictionary (MsgPack)

-(std::string)msgPack{
    
    return [[[FPNNMessageEncoder alloc]init] initWithMessage:self].encodeResult;
    
}
-(void)setMsgPack:(std::string)msgPack{
    
}
@end

@interface FPNNMessageDecoder()
{
//    std::stringstream _ss;
//    msgpack::packer<std::stringstream>* _packer;
}
@end


@implementation FPNNMessageDecoder
-(void)dealloc{
    //FPNSLog(@"FPNNMessageDecoder dealloc");
}

- (instancetype)initWithAnswer:(fpnn::FPAnswerPtr)cppAnswer errorCode:(int)errorCode{
    self = [super init];
    if (self) {
        
        if (cppAnswer == nil || cppAnswer == nullptr) {
            
            _error = [FPNError errorWithEx:@"fpnn decoder error. server return answer is nil. " code:errorCode];
            
        }else{

            [self _decoderAnswer:cppAnswer];
            
        }
        
    }
    return self;
}

- (instancetype)initWithAnswer:(fpnn::FPAnswerPtr)cppAnswer{
    
    
    self = [super init];
    if (self) {
        
        if (cppAnswer == nil || cppAnswer == nullptr) {
            
            _error = [FPNError errorWithEx:@"fpnn decoder error. server return answer is nil. " code:fpnn::FPNN_EC_CORE_UNKNOWN_ERROR];
            
        }else{
            
            [self _decoderAnswer:cppAnswer];
        
        }

    }
    return self;
}

-(void)_decoderAnswer:(fpnn::FPAnswerPtr)cppAnswer{
        
    if (cppAnswer->status() != 0){
        fpnn::FPAReader ar(cppAnswer);
        int code = (int)ar.getInt("code", fpnn::FPNN_EC_CORE_UNKNOWN_ERROR);
        std::string ex = ar.getString("ex");

        _error = [FPNError errorWithEx:[NSString stringWithFormat:@"fpnn decoder answer status != 0. %@",[NSString stringWithUTF8String:ex.c_str()]] code:code];
    }
    
    std::string cppData = cppAnswer->payload();
    Byte * bytes = (Byte*)cppData.c_str();
    NSData * ocData = [NSData dataWithBytes:bytes length:cppData.length()];
    NSError * error;
    NSDictionary * resultDic = [MPMessagePackReader readData:ocData error:&error];
    if (error == nil) {
        _decodeResult = resultDic;
    }else{
        FPNSLog(@"fpnn decoderAnswer MPMessagePackWriter error.");
    }
//    const std::string& cppPayload = cppAnswer->payload();
//    PayloadDictionaryBuilder* ocBuilder = [[PayloadDictionaryBuilder alloc] init];
//    ocBuilder.mainStart = YES;
//    ocBuilder.mainoOver = YES;
//    PayloadDictionaryBuildDelegate msgVisitor((__bridge void*)ocBuilder,
//                                              ocBuilder.actionFunc,
//                                              ocBuilder.addPositiveIntFunc,
//                                              ocBuilder.addNegativeIntFunc,
//                                              ocBuilder.addFloatFunc,
//                                              ocBuilder.addDoubleFunc,
//                                              ocBuilder.addStringFunc,
//                                              ocBuilder.addBinaryFunc);
//
//    std::size_t off = 0;
//    if (msgpack::parse(cppPayload.c_str(), cppPayload.length(), off, msgVisitor) == false){
//        _error = [FPNError errorWithEx:@"fpnn decoder answer error. convert answer message to oc failed." code:fpnn::FPNN_EC_CORE_DECODING];
//    }
//
//    if (!ocBuilder.buildFinish){
//        _error = [FPNError errorWithEx:@"fpnn decoder answer error. convert answer message to oc failed." code:fpnn::FPNN_EC_CORE_DECODING];
//    }
//
//    //NSAllLog(@"answer我的结果 %@",ocBuilder.tmpDic);
////    NSData *jsonData = [[NSString stringWithFormat:@"%s",cppAnswer->json().c_str()] dataUsingEncoding:NSUTF8StringEncoding];
////    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    _decodeResult = ocBuilder.tmpDic;
}


- (instancetype)initWithQuest:(fpnn::FPQuestPtr)cppQuest{
    
    self = [super init];
    if (self) {
        
        if (cppQuest == nil || cppQuest == nullptr) {
            
            _error = [FPNError errorWithEx:@"fpnn decoder quest error. server return quest is nil." code:fpnn::FPNN_EC_CORE_UNKNOWN_ERROR];
            
        }else{
            
    
            [self _decoderQuest:cppQuest];
            
        }
        
    }
    return self;
}

-(void)_decoderQuest:(fpnn::FPQuestPtr)cppQuest{
    
    std::string cppData = cppQuest->payload();
    Byte * bytes = (Byte*)cppData.c_str();
    NSData * ocData = [NSData dataWithBytes:bytes length:cppData.length()];
    NSError * error;
    NSDictionary * resultDic = [MPMessagePackReader readData:ocData error:&error];
    if (error == nil) {
        _decodeResult = resultDic;
    }else{
        FPNSLog(@"fpnn _decoderQuest MPMessagePackWriter error.");
    }
    
//    const std::string& cppPayload = cppQuest->payload();
////    std::cout << cppQuest->payload() << std::endl;
//    PayloadDictionaryBuilder* ocBuilder = [[PayloadDictionaryBuilder alloc] init];
//    ocBuilder.mainStart = YES;
//    ocBuilder.mainoOver = YES;
//    PayloadDictionaryBuildDelegate msgVisitor((__bridge void*)ocBuilder,
//                                   ocBuilder.actionFunc,
//                                   ocBuilder.addPositiveIntFunc,
//                                   ocBuilder.addNegativeIntFunc,
//                                   ocBuilder.addFloatFunc,
//                                   ocBuilder.addDoubleFunc,
//                                   ocBuilder.addStringFunc,
//                                   ocBuilder.addBinaryFunc);
//
//    std::size_t off = 0;
//    if (msgpack::parse(cppPayload.c_str(), cppPayload.length(), off, msgVisitor) == false)
//
//        _error = [FPNError errorWithEx:@"fpnn decoder quest Error. convert quest message to oc failed." code:fpnn::FPNN_EC_CORE_DECODING];
//
//    if (!ocBuilder.buildFinish)
//
//        _error = [FPNError errorWithEx:@"fpnn decoder quest Error. convert quest message to oc failed." code:fpnn::FPNN_EC_CORE_DECODING];
//
//
//    //NSAllLog(@"quest我的结果 %@",ocBuilder.tmpDic);
////    NSData *jsonData = [[NSString stringWithFormat:@"%s",cppQuest->json().c_str()] dataUsingEncoding:NSUTF8StringEncoding];
////    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    _decodeResult = ocBuilder.tmpDic;
}

@end






@interface FPNNMessageEncoder (){
//    std::stringstream _ss;
//    msgpack::packer<std::stringstream>* _packer;
}
@end

@implementation FPNNMessageEncoder
-(void)dealloc{
//    delete _packer;
    //FPNSLog(@"FPNNMessageEncoder dealloc");
}
- (instancetype)initWithMessage:(NSDictionary*)message{
    if (message == nil) {
        FPNSLog(@"fpnn FPNNMessageEncoder init error.  Please input valid message");
        return nil;
    }
    self = [super init];
    if (self) {

//        _packer = new msgpack::packer<std::stringstream>(_ss);
//        _encodeResult = [self convertFrom:message];
        
        NSError *error = nil;
        NSData * messageData = [MPMessagePackWriter writeObject:message error:&error];
        if (error == nil) {
            NSUInteger len = [messageData length];
//            Byte *byteData = (Byte*)malloc(len);
//            memcpy(byteData, [messageData bytes], len);
            std::string resultStr((char*)[messageData bytes], len);
            _encodeResult = resultStr;
        }else{
            FPNSLog(@"fpnn MPMessagePackWriter error.");
            return nil;
        }
    }
    return self;
}


//- (BOOL)packObject:(NSObject*)obj
//{
//    if ([obj isKindOfClass:[NSString class]])
//        return [self packNSString:(NSString*)obj];
//    
//    if ([obj isKindOfClass:[NSNumber class]])
//        return [self packNSNumber:(NSNumber*)obj];
//    
//    if ([obj isKindOfClass:[NSData class]])
//        return [self packNSData:(NSData*)obj];
//    
//    if ([obj isKindOfClass:[NSArray class]])
//        return [self packNSArray:(NSArray*)obj];
//    
//    if ([obj isKindOfClass:[NSDictionary class]])
//        return [self packNSDictionary:(NSDictionary*)obj];
//    
//    if ([obj isKindOfClass:[NSNull class]])
//        return [self packNSNull];
//    
//    if ([obj isKindOfClass:[NSSet class]])
//        return [self packNSSet:(NSSet*)obj];
//    
//    if ([obj isKindOfClass:[NSIndexSet class]])
//        return [self packNSIndexSet:(NSIndexSet*)obj];
//    
//    if ([obj isKindOfClass:[NSOrderedSet class]])
//        return [self packNSOrderedSet:(NSOrderedSet*)obj];
//    
//    if ([obj isKindOfClass:[NSHashTable class]])
//        return [self packNSHashTable:(NSHashTable*)obj];
//    
//    if ([obj isKindOfClass:[NSMapTable class]])
//        return [self packNSMapTable:(NSMapTable*)obj];
//    
//    return NO;
//}
//
//- (BOOL)packNSNull{
//    _packer->pack_nil();
//    return YES;
//}
//
//- (BOOL)packNSString:(NSString*)string{
//    //_packer->pack([string UTF8String]);
//    uint32_t length = (uint32_t)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    _packer->pack_str(length);
//    _packer->pack_str_body([string UTF8String], length);
//    return YES;
//}
//
//- (BOOL)packNSNumber:(NSNumber*)number{
//    if ([number isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
//        _packer->pack((bool)[number boolValue]);
//        return YES;
//    }
//    
//    char type = number.objCType[0];
//    switch (type)
//    {
//        case 'f':
//        case 'F':
//            _packer->pack([number floatValue]);
//            break;
//            
//        case 'd':
//        case 'D':
//            _packer->pack([number doubleValue]);
//            break;
//            
//        default:
//            _packer->pack([number longLongValue]);
//            break;
//    }
//    
//    return YES;
//}
//
//- (BOOL)packNSData:(NSData*)data{
//    _packer->pack_bin((uint32_t)data.length);
//    _packer->pack_bin_body((const char*)data.bytes, (uint32_t)data.length);
//    return YES;
//}
//
//- (BOOL)packNSArray:(NSArray*)array{
//    int size = (int)[array count];
//    _packer->pack_array(size);
//    
//    for (NSObject* obj in array)
//    {
//        if (![self packObject:obj])
//            return NO;
//    }
//    return YES;
//}
//
//- (BOOL)packNSSet:(NSSet*)set{
//    int size = (int)[set count];
//    _packer->pack_array(size);
//    
//    for (NSObject* obj in set)
//    {
//        if (![self packObject:obj])
//            return NO;
//    }
//    return YES;
//}
//
//- (BOOL)packNSIndexSet:(NSIndexSet*)set{
//    int size = (int)[set count];
//    _packer->pack_array(size);
//    
//    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*){
//        _packer->pack((uint64_t)idx);
//    }];
//    return YES;
//}
//
//- (BOOL)packNSOrderedSet:(NSOrderedSet*)set{
//    int size = (int)[set count];
//    _packer->pack_array(size);
//    
//    for (NSObject* obj in set)
//    {
//        if (![self packObject:obj])
//            return NO;
//    }
//    return YES;
//}
//
//- (BOOL)packNSHashTable:(NSHashTable*)table{
//    NSArray* array = table.allObjects;
//    return [self packNSArray:array];
//}
//
//- (BOOL)packNSMapTable:(NSMapTable*)table{
//    int size = (int)[table count];
//    _packer->pack_map(size);
//    
//    for (NSObject* key in table) {
//        NSObject* value = [table objectForKey:key];
//        
//        if (![self packObject:key])
//            return NO;
//        
//        if (![self packObject:value])
//            return NO;
//    }
//    return YES;
//}
//
//- (BOOL)packNSDictionary:(NSDictionary*)dict{
//    int size = (int)[dict count];
//    _packer->pack_map(size);
//    
//    for (NSObject* key in dict) {
//        NSObject* value = [dict objectForKey:key];
//        
//        if (![self packObject:key])
//            return NO;
//        
//        if (![self packObject:value])
//            return NO;
//    }
//    
//    return YES;
//}
//
//- (std::string)convertFrom:(NSDictionary*)payload{
//    std::string result;
//    if ([self packNSDictionary:payload]) {
//        result = _ss.str();
//    }
//    
//    return result;
//}
@end

