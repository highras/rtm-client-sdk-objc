//
//  IPV4HandleTools.hpp
//  Rtm
//
//  Created by zsl on 2020/2/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#ifndef IPV4HandleTools_hpp
#define IPV4HandleTools_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include <sstream>
using namespace std;
class IPV4Tools {
    
public:
    
    
    std::string ipv4Toipv6(const std::string& ipv4);
    std::vector<std::string>& split(const std::string& s, const std::string& delim, std::vector<std::string> &elems) ;
    
};
#endif /* IPV4HandleTools_hpp */
