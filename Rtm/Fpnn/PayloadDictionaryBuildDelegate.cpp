//
//  PayloadDictionaryBuildDelegate.cpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/23.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include <iostream>
#include "PayloadDictionaryBuildDelegate.hpp"
bool PayloadDictionaryBuildDelegate::visit_nil()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_AddNil);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_boolean(bool v)
{
    //std::cout << __FUNCTION__ << std::endl;
    if (v)
        _ocActionFunc(_ocBuilder, FPNN_PDB_AddTrue);
    else
        _ocActionFunc(_ocBuilder, FPNN_PDB_AddFalse);
    
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_positive_integer(uint64_t v)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddPositiveIntFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_negative_integer(int64_t v)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddNegativeIntFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_float32(float v)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddFloatFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_float64(double v)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddDoubleFunc(_ocBuilder, v);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_str(const char* v, uint32_t size)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddStringFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_bin(const char* v, uint32_t size)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddBinaryFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::visit_ext(const char* v, uint32_t size)
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocAddBinaryFunc(_ocBuilder, v, size);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_array(uint32_t num_elements)
{
    //std::cout << __FUNCTION__ << std::endl;
    (void)num_elements;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartArray);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_array_item()
{
    //std::cout << __FUNCTION__ << std::endl;
    return true;
}
bool PayloadDictionaryBuildDelegate::end_array_item()
{
    //std::cout << __FUNCTION__ << std::endl;
    return true;
}
bool PayloadDictionaryBuildDelegate::end_array()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishArray);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map(uint32_t num_kv_pairs)
{
    //std::cout << __FUNCTION__ << std::endl;
    (void)num_kv_pairs;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMap);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map_key()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMapKey);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map_key()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMapKey);
    return true;
}
bool PayloadDictionaryBuildDelegate::start_map_value()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_StartMapValue);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map_value()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMapValue);
    return true;
}
bool PayloadDictionaryBuildDelegate::end_map()
{
    //std::cout << __FUNCTION__ << std::endl;
    _ocActionFunc(_ocBuilder, FPNN_PDB_FinishMap);
    return true;
}
