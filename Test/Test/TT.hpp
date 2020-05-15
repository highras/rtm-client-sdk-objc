//
//  TT.hpp
//  Test
//
//  Created by zsl on 2020/2/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#ifndef TT_hpp
#define TT_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include <sstream>
using namespace std;
class ServerInfo {
    
public:
    
    
    std::string ipv4Toipv6(const std::string& ipv4);
    std::vector<std::string>& split(const std::string& s, const std::string& delim, std::vector<std::string> &elems) ;
    
};
#endif /* TT_hpp */
