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
    FPNN_PDB_AddTrue = 1,
    FPNN_PDB_AddFalse = 2,
    FPNN_PDB_StartArray = 3,
    FPNN_PDB_FinishArray = 4,
    FPNN_PDB_StartMap = 5,
    FPNN_PDB_StartMapKey = 6,
    FPNN_PDB_FinishMapKey = 7,
    FPNN_PDB_StartMapValue = 8,
    FPNN_PDB_FinishMapValue = 9,
    FPNN_PDB_FinishMap = 10
};

typedef void (*PDB_Action)(void* obj, int actionId);
typedef void (*PDB_AddPositiveInt)(void* obj, uint64_t v);
typedef void (*PDB_AddNegativeInt)(void* obj, int64_t v);
typedef void (*PDB_AddFloat)(void* obj, float v);
typedef void (*PDB_AddDouble)(void* obj, double v);
typedef void (*PDB_AddString)(void* obj, const char* buf, uint32_t size);
typedef void (*PDB_AddBinary)(void* obj, const char* buf, uint32_t size);

#endif /* PayloadDictionaryBuildFunc_h */
