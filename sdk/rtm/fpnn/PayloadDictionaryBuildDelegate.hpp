//
//  PayloadDictionaryBuildDelegate.hpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/23.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#ifndef PayloadDictionaryBuildDelegate_hpp
#define PayloadDictionaryBuildDelegate_hpp

#include <stdio.h>
#include <msgpack.hpp>
#include "PayloadDictionaryBuildFunc.h"

class PayloadDictionaryBuildDelegate: public msgpack::null_visitor
{
    void* _ocBuilder;
    PDB_Action _ocActionFunc;
    PDB_AddPositiveInt _ocAddPositiveIntFunc;
    PDB_AddNegativeInt _ocAddNegativeIntFunc;
    PDB_AddFloat _ocAddFloatFunc;
    PDB_AddDouble _ocAddDoubleFunc;
    PDB_AddString _ocAddStringFunc;
    PDB_AddBinary _ocAddBinaryFunc;

public:
    PayloadDictionaryBuildDelegate(void* ocBuilder,
                                   PDB_Action actionFunc,
                                   PDB_AddPositiveInt addPositiveIntFunc,
                                   PDB_AddNegativeInt addNegativeIntFunc,
                                   PDB_AddFloat addFloatFunc,
                                   PDB_AddDouble addDoubleFunc,
                                   PDB_AddString addStringFunc,
                                   PDB_AddBinary addBinaryFunc):
    _ocBuilder(ocBuilder),
    _ocActionFunc(actionFunc), _ocAddPositiveIntFunc(addPositiveIntFunc), _ocAddNegativeIntFunc(addNegativeIntFunc), _ocAddFloatFunc(addFloatFunc), _ocAddDoubleFunc(addDoubleFunc), _ocAddStringFunc(addStringFunc), _ocAddBinaryFunc(addBinaryFunc)
    {}
    virtual ~PayloadDictionaryBuildDelegate() {}
    
    bool visit_nil();
    bool visit_boolean(bool v);
    bool visit_positive_integer(uint64_t v);
    bool visit_negative_integer(int64_t v);
    bool visit_float32(float v);
    bool visit_float64(double v);
    bool visit_str(const char* v, uint32_t size);
    bool visit_bin(const char* v, uint32_t size);
    bool visit_ext(const char* v, uint32_t size);
    bool start_array(uint32_t num_elements);
    bool start_array_item();
    bool end_array_item();
    bool end_array();
    bool start_map(uint32_t num_kv_pairs);
    bool start_map_key();
    bool end_map_key();
    bool start_map_value();
    bool end_map_value();
    bool end_map();
};

#endif /* PayloadDictionaryBuildDelegate_hpp */
