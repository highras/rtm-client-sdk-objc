//
//  DictionaryToMsgPackConvertor.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/23.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include <string>
#include <sstream>
#include <msgpack.hpp>
#import "DictionaryToMsgPackConvertor.h"

@implementation DictionaryToMsgPackConvertor
{
    std::stringstream _ss;
    msgpack::packer<std::stringstream>* _packer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _packer = new msgpack::packer<std::stringstream>(_ss);
    }
    return self;
}

- (void)dealloc
{
    delete _packer;
}

- (BOOL)packObject:(NSObject*)obj
{
    if ([obj isKindOfClass:[NSString class]])
        return [self packNSString:(NSString*)obj];
    
    if ([obj isKindOfClass:[NSNumber class]])
        return [self packNSNumber:(NSNumber*)obj];
    
    if ([obj isKindOfClass:[NSData class]])
        return [self packNSData:(NSData*)obj];
    
    
    
    if ([obj isKindOfClass:[NSArray class]])
        return [self packNSArray:(NSArray*)obj];
    
    if ([obj isKindOfClass:[NSDictionary class]])
        return [self packNSDictionary:(NSDictionary*)obj];
    
    
    if ([obj isKindOfClass:[NSNull class]])
        return [self packNSNull];
    
    
    
    if ([obj isKindOfClass:[NSSet class]])
        return [self packNSSet:(NSSet*)obj];
    
    if ([obj isKindOfClass:[NSIndexSet class]])
        return [self packNSIndexSet:(NSIndexSet*)obj];
    
    if ([obj isKindOfClass:[NSOrderedSet class]])
        return [self packNSOrderedSet:(NSOrderedSet*)obj];
    
    if ([obj isKindOfClass:[NSHashTable class]])
        return [self packNSHashTable:(NSHashTable*)obj];
    
    if ([obj isKindOfClass:[NSMapTable class]])
        return [self packNSMapTable:(NSMapTable*)obj];
    
    return NO;
}

- (BOOL)packNSNull
{
    _packer->pack_nil();
    return YES;
}

- (BOOL)packNSString:(NSString*)string
{
    //_packer->pack([string UTF8String]);
    uint32_t length = (uint32_t)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    _packer->pack_str(length);
    _packer->pack_str_body([string UTF8String], length);
    return YES;
}

- (BOOL)packNSNumber:(NSNumber*)number
{
    if ([number isKindOfClass:NSClassFromString(@"__NSCFBoolean")])
    {
        _packer->pack((bool)[number boolValue]);
        return YES;
    }
    
    char type = number.objCType[0];
    switch (type)
    {
        case 'f':
        case 'F':
            _packer->pack([number floatValue]);
            break;
            
        case 'd':
        case 'D':
            _packer->pack([number doubleValue]);
            break;
            
        default:
            _packer->pack([number longLongValue]);
            break;
    }
    
    return YES;
}

- (BOOL)packNSData:(NSData*)data
{
    _packer->pack_bin((uint32_t)data.length);
    _packer->pack_bin_body((const char*)data.bytes, (uint32_t)data.length);
    return YES;
}

- (BOOL)packNSArray:(NSArray*)array
{
    int size = (int)[array count];
    _packer->pack_array(size);
    
    for (NSObject* obj in array)
    {
        if (![self packObject:obj])
            return NO;
    }
    return YES;
}

- (BOOL)packNSSet:(NSSet*)set
{
    int size = (int)[set count];
    _packer->pack_array(size);
    
    for (NSObject* obj in set)
    {
        if (![self packObject:obj])
            return NO;
    }
    return YES;
}

- (BOOL)packNSIndexSet:(NSIndexSet*)set
{
    int size = (int)[set count];
    _packer->pack_array(size);
    
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*){
        _packer->pack((uint64_t)idx);
    }];
    return YES;
}

- (BOOL)packNSOrderedSet:(NSOrderedSet*)set
{
    int size = (int)[set count];
    _packer->pack_array(size);
    
    for (NSObject* obj in set)
    {
        if (![self packObject:obj])
            return NO;
    }
    return YES;
}

- (BOOL)packNSHashTable:(NSHashTable*)table
{
    NSArray* array = table.allObjects;
    return [self packNSArray:array];
}

- (BOOL)packNSMapTable:(NSMapTable*)table
{
    int size = (int)[table count];
    _packer->pack_map(size);
    
    for (NSObject* key in table) {
        NSObject* value = [table objectForKey:key];
        
        if (![self packObject:key])
            return NO;
        
        if (![self packObject:value])
            return NO;
    }
    return YES;
}

- (BOOL)packNSDictionary:(NSDictionary*)dict
{
    int size = (int)[dict count];
    _packer->pack_map(size);
    
    for (NSObject* key in dict) {
        NSObject* value = [dict objectForKey:key];
        
        if (![self packObject:key])
            return NO;
        
        if (![self packObject:value])
            return NO;
    }
    
    return YES;
}

- (BOOL)convertFrom:(NSDictionary*)payload toCppString:(void*)stringPtr
{
    if (![self packNSDictionary:payload])
        return NO;
    
    std::string* outStr = (std::string*)stringPtr;
    *outStr = _ss.str();
    return YES;
}

@end
