//
//  PayloadDictionaryBuildDelegate.cpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/23.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include "PayloadDictionaryBuildDelegate.hpp"

bool PayloadDictionaryBuildDelegate::visit_nil()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_AddNil);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_boolean(bool v)
{
    if (v)
        _ocActionFunc(_ocBuilder, FPNN_PDB_AddTrue);
    else
        _ocActionFunc(_ocBuilder, FPNN_PDB_AddFalse);
    
    return true;
}

bool PayloadDictionaryBuildDelegate::visit_positive_integer(uint64_t v)
{
    _ocAddPositiveIntFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_negative_integer(int64_t v)
{
    _ocAddNegativeIntFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_float32(float v)
{
    _ocAddFloatFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_float64(double v)
{
    _ocAddDoubleFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_str(const char* v, uint32_t size)
{
    _ocAddStringFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_bin(const char* v, uint32_t size)
{
    _ocAddBinaryFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_ext(const char* v, uint32_t size)
{
    _ocAddBinaryFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_array(uint32_t num_elements)
{
    (void)num_elements;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartArray);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_array_item()
{
    return true;
}
bool PayloadDictionaryBuildDelegate::end_array_item()
{
    return true;
}
bool PayloadDictionaryBuildDelegate::end_array()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishArray);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map(uint32_t num_kv_pairs)
{
    (void)num_kv_pairs;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMap);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map_key()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMapKey);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map_key()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMapKey);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map_value()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMapValue);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map_value()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMapValue);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map()
{
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMap);
    return true;
}
