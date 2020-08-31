//
//  IPV4HandleTools.cpp
//  Rtm
//
//  Created by zsl on 2020/2/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

//#include "IPV4HandleTools.hpp"
//std::string IPV4Tools::ipv4Toipv6(const std::string& ipv4) {
//  // https://tools.ietf.org/html/rfc6052
//  std::vector<std::string> parts;
//  IPV4Tools::split(ipv4, ".", parts);
//  if (parts.size() != 4)
//    return "";
//  for (auto& part : parts) {
//    int32_t p = atoi(part.c_str());
//    if (p < 0 || p > 255)
//      return "";
//  }
//  int32_t part7 = atoi(parts[0].c_str()) * 256 + atoi(parts[1].c_str());
//  int32_t part8 = atoi(parts[2].c_str()) * 256 + atoi(parts[3].c_str());
//  std::stringstream ss;
//  ss << "64:ff9b::" << std::hex << part7 << ":" << std::hex << part8;
//  return ss.str();
//}
//std::vector<std::string>& IPV4Tools::split(const std::string& s, const std::string& delim, std::vector<std::string> &elems) {
//    if(s.empty()) return elems;
//    
//    std::string::size_type pos_begin = s.find_first_not_of(delim);
//    std::string::size_type comma_pos = 0;
//    std::string tmp;
//    while (pos_begin != std::string::npos){
//        comma_pos = s.find_first_of(delim, pos_begin);
//        if (comma_pos != std::string::npos){
//            tmp = s.substr(pos_begin, comma_pos - pos_begin);
//            pos_begin = comma_pos + 1;
//        }
//        else{
//            tmp = s.substr(pos_begin);
//            pos_begin = comma_pos;
//        }
//        if (!tmp.empty()){
//            elems.push_back(tmp);
//            tmp.clear();
//        }
//    }
//
//    return elems;
//}
