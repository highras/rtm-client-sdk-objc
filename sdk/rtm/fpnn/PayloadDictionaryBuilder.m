//
//  PayloadDictionaryBuilder.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/22.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "PayloadDictionaryBuilder.h"

@interface PayloadDictionaryBuilder ()

- (void)buildAction:(int)actionId;

@end


void buildActionFunc(void* obj, int actionId) {
    [(__bridge PayloadDictionaryBuilder*)obj buildAction:actionId];
}
void addPositiveIntFunc(void* obj, uint64_t v) {
    [(__bridge PayloadDictionaryBuilder*)obj addPositiveInt:v];
}
void addNegativeIntFunc(void* obj, int64_t v) {
    [(__bridge PayloadDictionaryBuilder*)obj addNegativeInt:v];
}
void addFloatFunc(void* obj, float v) {
    [(__bridge PayloadDictionaryBuilder*)obj addFloat:v];
}
void addDoubleFunc(void* obj, double v) {
    [(__bridge PayloadDictionaryBuilder*)obj addDouble:v];
}
void addStringFunc(void* obj, const char* buf, uint32_t size) {
    [(__bridge PayloadDictionaryBuilder*)obj addString:buf withLength:size];
}
void addBinaryFunc(void* obj, const char* buf, uint32_t size) {
    [(__bridge PayloadDictionaryBuilder*)obj addBinary:buf withLength:size];
}


@implementation PayloadDictionaryBuilder
{
    NSObject<NSCopying>* _currKey;
    NSObject* _currValue;
    
    NSMutableArray* _currArray;
    NSMutableArray* _arrayStack;
    PayloadDictionaryBuilder* _subBuilder;
    BOOL _wantMapValue;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _actionFunc = buildActionFunc;
        _addPositiveIntFunc = addPositiveIntFunc;
        _addNegativeIntFunc = addNegativeIntFunc;
        _addFloatFunc = addFloatFunc;
        _addDoubleFunc = addDoubleFunc;
        _addStringFunc = addStringFunc;
        _addBinaryFunc = addBinaryFunc;
        
        _payload = nil;
        _buildFinish = NO;
        
        _currKey = nil;
        _currValue = nil;

        _currArray = nil;
        _arrayStack = [NSMutableArray array];
        _subBuilder = nil;
        _wantMapValue = NO;
    }
    return self;
}

- (void)addNil
{
    if (_subBuilder)
        [_subBuilder addNil];
    else if (_currArray)
        [_currArray addObject:[NSNull null]];
    else if (_wantMapValue)
        _currValue = [NSNull null];
    else
        _currKey = [NSNull null];
}

- (void)addBool:(BOOL)v
{
    if (_subBuilder)
        [_subBuilder addBool:v];
    else
    {
        NSNumber *number = [NSNumber numberWithBool:v];
        if (_currArray)
            [_currArray addObject:number];
        else if (_wantMapValue)
            _currValue = number;
        else
            _currKey = number;
    }
}

- (void)addPositiveInt:(uint64_t)v
{
    if (_subBuilder)
        [_subBuilder addPositiveInt:v];
    else
    {
        NSNumber *number = [NSNumber numberWithUnsignedLongLong:v];
        if (_currArray)
            [_currArray addObject:number];
        else if (_wantMapValue)
            _currValue = number;
        else
            _currKey = number;
    }
}

- (void)addNegativeInt:(int64_t)v
{
    if (_subBuilder)
        [_subBuilder addNegativeInt:v];
    else
    {
        NSNumber *number = [NSNumber numberWithLongLong:v];
        if (_currArray)
            [_currArray addObject:number];
        else if (_wantMapValue)
            _currValue = number;
        else
            _currKey = number;
    }
}

- (void)addFloat:(float)v
{
    if (_subBuilder)
        [_subBuilder addFloat:v];
    else
    {
        NSNumber *number = [NSNumber numberWithFloat:v];
        if (_currArray)
            [_currArray addObject:number];
        else if (_wantMapValue)
            _currValue = number;
        else
            _currKey = number;
    }
}

- (void)addDouble:(double)v
{
    if (_subBuilder)
        [_subBuilder addDouble:v];
    else
    {
        NSNumber *number = [NSNumber numberWithDouble:v];
        if (_currArray)
            [_currArray addObject:number];
        else if (_wantMapValue)
            _currValue = number;
        else
            _currKey = number;
    }
}

- (void)addString:(const char*)buf withLength:(uint32_t)length
{
    if (_subBuilder)
        [_subBuilder addString:buf withLength:length];
    else
    {
        NSObject<NSCopying> *string = nil;
        if (length)
        {
            string = [[NSString alloc] initWithBytes:buf length:length encoding:NSUTF8StringEncoding];
            if (string == nil)
                string = [NSData dataWithBytes:buf length:length];
        }
        else
            string = @"";
        
        if (_currArray)
            [_currArray addObject:string];
        else if (_wantMapValue)
            _currValue = string;
        else
            _currKey = string;
    }
}

- (void)addBinary:(const char*)buf withLength:(uint32_t)length
{
    if (_subBuilder)
        [_subBuilder addBinary:buf withLength:length];
    else
    {
        NSData *data;
        if (length)
            data = [NSData dataWithBytes:buf length:length];
        else
            data = [NSData data];
        
        if (_currArray)
            [_currArray addObject:data];
        else if (_wantMapValue)
            _currValue = data;
        else
            _currKey = data;
    }
}

- (void)startArray
{
    if (_subBuilder)
        [_subBuilder startArray];
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        
        if (_currArray)
            [_currArray addObject:array];
        else if (_wantMapValue)
            _currValue = array;
        else
            _currKey = array;
        
        [_arrayStack addObject:array];
    }
}

- (void)finishArray
{
    if (_subBuilder)
        [_subBuilder finishArray];
    else
    {
        [_arrayStack removeLastObject];
        NSUInteger count = [_arrayStack count];
        if (count)
            _currArray = [_arrayStack objectAtIndex:(count - 1)];
        else
            _currArray = nil;
    }
}

- (void)startMap
{
    if (_payload)
    {
        if (_subBuilder)
            [_subBuilder startMap];
        else
            _subBuilder = [[PayloadDictionaryBuilder alloc] init];
    }
    else
        _payload = [NSMutableDictionary dictionary];
}

- (void)startMapKey
{
    if (_subBuilder)
        [_subBuilder startMapKey];
    else
        _wantMapValue = NO;
}

- (void)finishMapKey
{
    if (_subBuilder)
        [_subBuilder finishMapKey];
    else
    {
        _wantMapValue = YES;
        if (_currKey && _currValue)
        {
            [_payload setObject:_currValue forKey:_currKey];
            _currKey = nil;
            _currValue = nil;
        }
    }
}

- (void)startMapValue
{
    if (_subBuilder)
        [_subBuilder startMapValue];
    else
        _wantMapValue = YES;
}

- (void)finishMapValue
{
    if (_subBuilder)
        [_subBuilder finishMapValue];
    else
    {
        _wantMapValue = NO;
        if (_currKey && _currValue)
        {
            [_payload setObject:_currValue forKey:_currKey];
            _currKey = nil;
            _currValue = nil;
        }
    }
}

- (void)finishMap
{
    if (_subBuilder)
    {
        [_subBuilder finishMap];
        if (_subBuilder.buildFinish)
        {
            if (_currArray)
                [_currArray addObject:_subBuilder.payload];
            else if (_wantMapValue)
                _currValue = _subBuilder.payload;
            else
                _currKey = _subBuilder.payload;
            
            _subBuilder = nil;
        }
    }
    else
        _buildFinish = YES;
}

- (void)buildAction:(int)actionId
{
    if (actionId == FPNN_PDB_StartMapKey)
    {
        [self startMapKey];
    }
    else if (actionId == FPNN_PDB_FinishMapKey)
    {
        [self finishMapKey];
    }
    else if (actionId == FPNN_PDB_StartMapValue)
    {
        [self startMapValue];
    }
    else if (actionId == FPNN_PDB_FinishMapValue)
    {
        [self finishMapValue];
    }
    else if (actionId == FPNN_PDB_StartArray)
    {
        [self startArray];
    }
    else if (actionId == FPNN_PDB_FinishArray)
    {
        [self finishArray];
    }
    else if (actionId == FPNN_PDB_StartMap)
    {
        [self startMap];
    }
    else if (actionId == FPNN_PDB_FinishMap)
    {
        [self finishMap];
    }
    else if (actionId == FPNN_PDB_AddTrue)
    {
        [self addBool:YES];
    }
    else if (actionId == FPNN_PDB_AddFalse)
    {
        [self addBool:NO];
    }
    else if (actionId == FPNN_PDB_AddNil)
    {
        [self addNil];
    }
}

@end
