//
//  PayloadDictionaryBuilder.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/22.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PayloadDictionaryBuildFunc.h"

@interface PayloadDictionaryBuilder : NSObject

@property (strong, nonatomic) NSMutableDictionary* payload;
@property (readonly, nonatomic) BOOL buildFinish;

@property (nonatomic) PDB_Action actionFunc;
@property (nonatomic) PDB_AddPositiveInt addPositiveIntFunc;
@property (nonatomic) PDB_AddNegativeInt addNegativeIntFunc;
@property (nonatomic) PDB_AddFloat addFloatFunc;
@property (nonatomic) PDB_AddDouble addDoubleFunc;
@property (nonatomic) PDB_AddString addStringFunc;
@property (nonatomic) PDB_AddBinary addBinaryFunc;

- (instancetype)init;

- (void)addNil;
- (void)addBool:(BOOL)v;
- (void)addPositiveInt:(uint64_t)v;
- (void)addNegativeInt:(int64_t)v;
- (void)addFloat:(float)v;
- (void)addDouble:(double)v;
- (void)addString:(const char*)buf withLength:(uint32_t)length;
- (void)addBinary:(const char*)buf withLength:(uint32_t)length;
- (void)startArray;
- (void)finishArray;
- (void)startMap;
- (void)startMapKey;
- (void)finishMapKey;
- (void)startMapValue;
- (void)finishMapValue;
- (void)finishMap;

@end
