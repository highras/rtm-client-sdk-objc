//
//  PayloadDictionaryBuildFunc.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/22.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#ifndef PayloadDictionaryBuildFunc_h
#define PayloadDictionaryBuildFunc_h

enum FPNN_PDB_Action
{
    FPNN_PDB_AddNil = 0,
    FPNN_PDB_AddTrue,
    FPNN_PDB_AddFalse,
    FPNN_PDB_StartArray,
    FPNN_PDB_FinishArray,
    FPNN_PDB_StartMap,
    FPNN_PDB_StartMapKey,
    FPNN_PDB_FinishMapKey,
    FPNN_PDB_StartMapValue,
    FPNN_PDB_FinishMapValue,
    FPNN_PDB_FinishMap
};

typedef void (*PDB_Action)(void* obj, int actionId);
typedef void (*PDB_AddPositiveInt)(void* obj, uint64_t v);
typedef void (*PDB_AddNegativeInt)(void* obj, int64_t v);
typedef void (*PDB_AddFloat)(void* obj, float v);
typedef void (*PDB_AddDouble)(void* obj, double v);
typedef void (*PDB_AddString)(void* obj, const char* buf, uint32_t size);
typedef void (*PDB_AddBinary)(void* obj, const char* buf, uint32_t size);

#endif /* PayloadDictionaryBuildFunc_h */
